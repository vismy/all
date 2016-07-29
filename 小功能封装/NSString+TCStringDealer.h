//
//  NSString+TCStringDealer.h
//  小功能封装
//
//  Created by macPro on 16/7/29.
//  Copyright © 2016年 macPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface NSString (TCStringDealer)

//MD5加密
- (NSString *)MD5;

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor;

//计算字节长度
-(int)charNumber;

//计算字符串长度
- (CGFloat)stringLength:(NSInteger)size;


//设置字符串样式
//字典包含字段 attributedName value range(la,lo)
//  attributedName :
//kCTFontAttributeName 这个键是字体的名称 必须传入CTFont对象
//kCTKernAttributeName 这个键设置字体间距 传入必须是数字对象 默认为0
//kCTLigatureAttributeName  这个键设置连字方式 必须传入CFNumber对象
//kCTParagraphStyleAttributeName  段落对其方式
//kCTForegroundColorAttributeName 字体颜色 必须传入CGColor对象
//kCTStrokeWidthAttributeName 笔画宽度 必须是CFNumber对象
//kCTStrokeColorAttributeName 笔画颜色
//kCTSuperscriptAttributeName 控制垂直文本定位 CFNumber对象
//kCTUnderlineColorAttributeName 下划线颜色
- (NSMutableAttributedString *)createAttributedStringWithAttributedStyles:(NSArray<NSDictionary *> *)styles;

//获取字符串（或汉字）首字母
+ (NSString *)firstCharacterWithString:(NSString *)string;

//对中文英文 按照首字母排序
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;

//获取当前时间
//format:@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)currentDateWithFormat:(NSString *)format;

//计算上次日期距离现在多久，如xx小时前，xx分钟前等
//时间要和format对应
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     CurrentTimeFormat:(NSString *)format2;

//判断手机号码格式是否正确
+ (BOOL)validataMobile:(NSString *)mobile;

//判断邮箱格式是否正确
+ (BOOL)validateEmail:(NSString *)email;

//将十六进制颜色转换成 UIcolor
+ (UIColor *)colorWithHexString:(NSString *)color;

//对图片进行滤镜处理
+ (UIImage *)filterWithOriginalImage:(UIImage *)image fiterName:(NSString *)name;

//对图片进行模糊处理
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

//调整图片饱和度、亮度、对比度
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

//创建一张实时模糊效果的view
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

//全屏截图
+ (UIImage *)shotScreen;

//截取一张view生成图片
+ (UIImage *)shotWithView:(UIView *)view;

//截取view某个区域 生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

//压缩图片到指定尺寸大小
+ (UIImage *)conpressOriginalImage:(UIImage *)image toSize:(CGSize)size;

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;


//获取设备IP地址
+ (NSString *)getIPAddress;

//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string;

//判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;

//判断字符串中是否含有中文
+ (BOOL)isHaceChineseInString:(NSString *)string;

//判断字符串中是否全部为数字
+ (BOOL)isAllNum:(NSString *)string;

//绘制虚线
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;



@end
