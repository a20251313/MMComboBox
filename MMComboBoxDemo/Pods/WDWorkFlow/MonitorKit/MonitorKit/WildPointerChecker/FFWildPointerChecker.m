//
//  WildPointerChecker.m
//  WildPointerCheckerDemo
//
//  Created by XXXXXX on 16/8/26.
//  Copyright © 2016年 hdurtt. All rights reserved.
//

#import "FFWildPointerChecker.h"
#import "malloc/malloc.h"
#import "pthread.h"
#import "fishhook.h"
#import <objc/runtime.h>
#import "FFZombieObject.h"
#import <dlfcn.h>

//define
#define MAX_UNFREE_POINTER 1024*1024*1  //1MB
#define MAX_UNFREE_MEM     1024*1024*5 //5MB
#define FREE_POINTER_NUM   1000           //每次释放1000个指针

typedef struct unfreeMem {
    void *p;
    struct unfreeMem *next;
}UNFREE_MEM, *PUNFREE_MEM;

typedef struct unfreeList {
    PUNFREE_MEM header_list;
    PUNFREE_MEM tail_list;
    size_t      unfree_count;
    size_t      unfree_size;
}UNFREE_LIST, *PUNFREE_LIST;

void (*orig_free)(void *);
void myfree(void *p);
PUNFREE_LIST createList();
void addUnFreeMemToListSync(PUNFREE_LIST unfreeList, void *p);
void freeMemInListSync(PUNFREE_LIST unfreeList, size_t freeNum);

PUNFREE_LIST global_unfree_list = NULL;
pthread_mutex_t global_mutex;
Class global_zombie;
size_t global_zombie_size;
CFMutableSetRef global_registerdClasses;
BOOL isRunningWildPointerCheck = NO;

//method
void startWildPointerCheck()
{
    //获取已注册的类
    orig_free = dlsym(RTLD_DEFAULT, "free");
    global_registerdClasses = CFSetCreateMutable(NULL, 0, NULL);
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(global_registerdClasses, (__bridge const void *)(classes[i]));
    }
    free(classes);
    classes = NULL;
    //获取僵尸对象和其大小
    global_zombie = objc_getClass("FFZombieObject");
    global_zombie_size = class_getInstanceSize(global_zombie);
    //创建未释放内存的链表(带链表头)
    global_unfree_list = createList();
    //创建同步互斥量
    pthread_mutex_init(&global_mutex, NULL);
    //hook free
    rebind_symbols((struct rebinding[1]){{"free", myfree, (void *)&orig_free}}, 1);
    
    isRunningWildPointerCheck = YES;
}

void stopWildPointerCheck()
{
    isRunningWildPointerCheck = NO;
}

void myfree(void *p)
{
    if (!isRunningWildPointerCheck) {
        orig_free(p);
        return;
    }
    
    if (global_unfree_list->unfree_count > MAX_UNFREE_POINTER * 0.9 || global_unfree_list->unfree_size > MAX_UNFREE_MEM) {
        freeMemInListSync(global_unfree_list, FREE_POINTER_NUM);
    }
    
    size_t size = malloc_size(p);
    if (size >= global_zombie_size) {
        __unsafe_unretained id obj = (__bridge id)p;
        Class originClass = object_getClass(obj);
        if (originClass && CFSetContainsValue(global_registerdClasses, (__bridge const void *)(originClass))) {
            memset(p, 0x55, size);
            memcpy(p, &global_zombie, sizeof(void *));
            
            FFZombieObject *zombie = (__bridge FFZombieObject *)p;
            zombie.origClass = originClass;
        } else {
            memset(p, 0x55, size);
        }
    } else {
        memset(p, 0x55, size);
    }
    
    addUnFreeMemToListSync(global_unfree_list, p);
}

PUNFREE_LIST createList()
{
    PUNFREE_LIST unfreeList = (PUNFREE_LIST)malloc(sizeof(UNFREE_LIST));
    unfreeList->header_list = (PUNFREE_MEM)malloc(sizeof(UNFREE_MEM));
    unfreeList->header_list->p = NULL;
    unfreeList->header_list->next = NULL;
    unfreeList->tail_list = unfreeList->header_list;
    unfreeList->unfree_count = 0;
    unfreeList->unfree_size = 0;
    return unfreeList;
}

void addUnFreeMemToListSync(PUNFREE_LIST unfreeList, void *p)
{
    pthread_mutex_lock(&global_mutex);
    if (!unfreeList || !p) {
        pthread_mutex_unlock(&global_mutex);
        return;
    }
    
    PUNFREE_MEM unfreeMem = (PUNFREE_MEM)malloc(sizeof(UNFREE_MEM));
    unfreeMem->p = p;
    unfreeMem->next = NULL;
    
    unfreeList->tail_list->next = unfreeMem;
    unfreeList->tail_list = unfreeMem;
    unfreeList->unfree_count++;
    unfreeList->unfree_size += malloc_size(p);
    pthread_mutex_unlock(&global_mutex);
}

void freeMemInListSync(PUNFREE_LIST unfreeList, size_t freeNum)
{
    pthread_mutex_lock(&global_mutex);
    if (!unfreeList || freeNum <= 0) {
        pthread_mutex_unlock(&global_mutex);
        return;
    }
    
    if (!unfreeList->header_list->next) {
        pthread_mutex_unlock(&global_mutex);
        return;
    }
    
    for (int i = 0; i < freeNum && unfreeList->header_list->next; i++) {
        PUNFREE_MEM memToDelete = unfreeList->header_list->next;
        if (memToDelete == unfreeList->tail_list) {
            unfreeList->tail_list = unfreeList->header_list;
        }
        unfreeList->header_list->next = memToDelete->next;
        unfreeList->unfree_size -= malloc_size(memToDelete->p);
        unfreeList->unfree_count--;;
        orig_free(memToDelete->p);
        orig_free(memToDelete);
    }
    pthread_mutex_unlock(&global_mutex);
}
