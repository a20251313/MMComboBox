//
//  FFIconFontDefine.h
//  FFIconFontDemo
//
//  Created by 石贵峰 on 2016/10/27.
//  Copyright © 2016年 shiguifeng. All rights reserved.
//
#import "UIImage+IconFont.h"
#import "FFIconLabel.h"
#import "FFIconButton.h"



//iconfont地址:http://www.iconfont.cn/plus/manage/index?manage_type=myprojects&spm=a313x.7781069.1998910419.10.QTiuIg&projectId=179657
//GitHub账号：mayushi@wanda.cn
//密码 ffan123456

/* 当前define文件是根据当前的iconfont.ttf得到的对应文件，如果iconfont文件有变动，请变动者check
 * 一下相应的对应表是否正确. 如果有任何其余的问题，请与shiguifeng，yaoming，ranjingfu联系
 *
 */

#ifndef FFIconFontDefine_h
#define FFIconFontDefine_h

#define kICONFONT_FONTNAME  @"iconfont" // 字体的名字
#define kICONFONT(a)   [UIFont fontWithName:kICONFONT_FONTNAME size:a]; // 新字体
#define kICON_FONT_SCALE    1//---------------------------------|默认宽高比例


#define         kChild_2Icon                @"\U0000e655" //一个孩子的标识 孩子的头像
#define         kPark_2Icon                 @"\U0000e653" //停车icon  中间有个P的标识
#define         kTag_2Icon                  @"\U0000e652" //tag标识 倾斜负45度
#define         kMovie_2Icon                @"\U0000e651" //电影的icon
#define         kWifi_2Icon                 @"\U0000e650" //这个WiFi的圆是实心的
#define         kForkIcon                   @"\U0000e64b" //🍴 刀叉相交的icon
#define         kWifiIcon                   @"\U0000e647" //Wifi的icon 这个不知道我就不知道说什么了
#define         kSquare_2Icon               @"\U0000e645" //一个圆角的长方形
#define         kListIcon                   @"\U0000e644" //列表icon
#define         kQuanjingIcon               @"\U0000e643" //全景icon（有全景两个字）
#define         kFfanTongIcon               @"\U0000e63c" //飞凡痛标识icon 有字和鲸鱼
#define         kFowordArrow_2Icon          @"\U0000e63a" //向右的箭头 ->
#define         kHourGlassIcon              @"\U0000e638" //一个⏳沙漏icon
#define         kCircle_2Icon               @"\U0000e635" //一个实心圆
#define         kCircleIcon                 @"\U0000e633" //一个空心圆
#define         kUpArrow_2                  @"\U0000e632" //向上的实心箭头
#define         kDownArrow_2Icon            @"\U0000e631" //向下的实心箭头
#define         kSecurityIcon               @"\U0000e630" // 安全标识icon
#define         kFlipIcon                   @"\U0000e62f" //这。。。
#define         kHistoryIcon                @"\U0000e62e" //历史icon  逆时针旋转的钟表
#define         kTelephoneIcon              @"\U0000e62d" //拨打电话的icon
#define         kLocation_2Icon             @"\U0000e628" //一个定位icon
#define         kTimeIcon                   @"\U0000e627" //一个时钟符号
#define         kDeleteIcon                 @"\U0000e626" //垃圾箱icon
#define         kStar_2Icon                 @"\U0000e624" //实心的星星符号
#define         kStarIcon                   @"\U0000e623" //空心的星星符号
#define         kClose_2Icon                @"\U0000e620" //一个X 外面有个圆
#define         kCheckBoxIcon               @"\U0000e61f" //正方形里面有个勾
#define         kTagIcon                    @"\U0000e61e" //标签符号（45度角的）
#define         kDiamondIcon                @"\U0000e61c" //钻石符号
#define         kHeart_2Icon                @"\U0000e618" //实心的心形符号
#define         kEditIcon                   @"\U0000e616" //编辑icon
#define         kAttentionIcon              @"\U0000e614"  // 封闭圆里面有个字母i
#define         kHeartIcon                  @"\U0000e613" //桃心（喜欢，关注神马的）
#define         kNotificationIcon           @"\U0000e612"   //消息按钮，一个没有打开的信封
#define         kSecrchLackIcon             @"\U0000e60e" //搜索按钮（有一点儿不封闭）
#define         kRefreshIcon                @"\U0000e60d"   //刷新按钮
#define         kSuccessIon                 @"\U0000e604" //勾的外面有个圆
#define         kHelpIcon                   @"\U0000e603"  // 封闭圆里面有个?
#define         kLogoFullIconIcon           @"\U0000e602"   //飞凡的 有鲸鱼，文字，网址
#define         kLogoWhalelIcon             @"\U0000e601"   //飞凡的一只鲸鱼（实心的）
#define         kCheckIcon                  @"\U0000e606" //勾
#define         kSortedIcon                 @"\U0000e87f"     //排序icon
#define         kFilterIcon                 @"\U0000e6b1"     //筛选icon（一个漏斗）
#define         kStarFiveIcon               @"\U0000e641"     //实心的⭐️
#define         kSearchIcon                 @"\U0000e625"    //搜索icon
#define         kTypeIcon                   @"\U0000e67f"     //类型icon
#define         kPatrkRoundIcon             @"\U0000e67d"     //一个P字icon（有圆形外框）
#define         kMinusChineseIcon           @"\U0000e67c"   //一个减字icon
#define         kSacnOnceIcon               @"\U0000e67b"   //扫一扫icon
#define         kMineIcon                   @"\U0000e67a"   //我的icon
#define         kDiscountIcon               @"\U0000e679"   //折扣icon（有字在矩形里面）
#define         kAiGuangJieIcon             @"\U0000e678"   //爱逛街icon
#define         kFeifanTongIcon             @"\U0000e677"   //飞凡通icon
#define         kBackTopIcon                @"\U0000e674"   //列表返回顶部的icon
#define         kWhalelCoinIcon             @"\U0000e672"   //飞凡的一只鲸鱼（空心的）
#define         kRocketIcon                 @"\U0000e66d" //🚀火箭icon
#define         kVoiceIcon                  @"\U0000e66c" //语音icon
#define         kQRCoedIcon                 @"\U0000e63b" //二维码扫码icon
#define         kShakeIcon                  @"\U0000e617" //摇一摇手势icon
#define         kFowordArrowIcon            @"\U0000e611"   //向右的箭头，也是醉了 >
#define         kDownArrowIcon              @"\U0000e610"   //向下的箭头
#define         kUpArrowIcon                @"\U0000e60f"   //向上的箭头
#define         kMinusIcon                  @"\U0000e60c"    //减按钮 形状 ——
#define         kAddIcon                    @"\U0000e60b"    //加按钮 形状 +
#define         kCloseIcon                  @"\U0000e60a"    //关闭按钮 形状如X
#define         kMoreIcon                   @"\U0000e609"     //三个点，省略号，更多什么的
#define         kShareIcon                  @"\U0000e608"    //分享icon （三个点，两条线）
#define         kBackArrowIcon              @"\U0000e607"   //向左的箭头，如后退按钮
#define         kLocationIcon               @"\U0000e66e"   //定位按钮，这个不知道怎么描述



#endif /* FFIconFontDefine_h */
