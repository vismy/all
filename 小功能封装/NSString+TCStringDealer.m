//
//  NSString+TCStringDealer.m
//  小功能封装
//
//  Created by macPro on 16/7/29.
//  Copyright © 2016年 macPro. All rights reserved.
//

#import "NSString+TCStringDealer.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (TCStringDealer)

- (NSString *)MD5{
    return [NSString MD5ByString:self];
}

+ (NSString *)MD5ByString:(NSString *)str{
    const char* cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

//计算字节长度
-(int)charNumber {
    
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}


- (CGFloat)stringLength:(NSInteger)size{
    CGRect frame = [self boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    return frame.size.width+5;
}


- (NSMutableAttributedString *)createAttributedStringWithAttributedStyles:(NSArray<NSDictionary *> *)styles{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    
    for (NSDictionary *dic in styles) {
        NSRange range = NSMakeRange([[[dic[@"range"] componentsSeparatedByString:@","] firstObject] integerValue], [[[dic[@"range"] componentsSeparatedByString:@","] lastObject] integerValue]);
        
        [attributedString addAttribute:dic[@"attributedName"] value:dic[@"value"] range:range];
        
    }
    return attributedString;
}



//获取字符串（或汉字）首字母
+ (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    
    return [pingyin substringToIndex:1];
}


+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    
    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    for (int i=0; i<indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [objects addObject:obj];
    }
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:objects.count];
    //按字母顺序进行分组
    NSInteger lastIndex = -1;
    for (int i=0; i<array.count; i++) {
        NSInteger index = [indexedCollation sectionForObject:array[i] collationStringSelector:@selector(uppercaseString)];
        [[objects objectAtIndex:index] addObject:array[i]];
        lastIndex = index;
    }
    //去掉空数组
    for (int i=0; i<objects.count; i++) {
        NSMutableArray *obj = objects[i];
        if (obj.count == 0) {
            [objects removeObject:obj];
        }
    }
    
    //获取索引字母
    for (NSMutableArray *array in objects) {
        NSString *str = array[0];
        NSString  *key = [self firstCharacterWithString:str];
        [keys addObject:key];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:objects forKey:keys];
    return dic;
}

//获取当前时间
//format:@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)currentDateWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//计算上次日期距离现在多久，如xx小时前，xx分钟前等
//时间要和format对应
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     CurrentTimeFormat:(NSString *)format2{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    dateFormatter1.dateFormat = format1;
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    dateFormatter2.dateFormat = format2;
    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];
    
    return [self timeIntervalFromLastTime:lastDate toCurrentTime:currentDate];
}

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime toCurrentTime:(NSDate *)currentTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
    NSInteger intervalTime = [currentDate timeIntervalSinceReferenceDate]- [lastDate timeIntervalSinceReferenceDate];
    
    NSInteger min = intervalTime/60;
    NSInteger hour = intervalTime/60/60;
    NSInteger day = intervalTime/60/60/24;
    NSInteger month = intervalTime/60/60/24/30;
    NSInteger year = intervalTime/60/60/24/365;
    
    if (min <= 10) {
        return @"刚刚";
    }else if (min < 60){
        return [NSString stringWithFormat:@"%ld分钟前",(long)min];
    }else if (hour < 24){
        return [NSString stringWithFormat:@"%ld小时前",(long)hour];
    }else if (day < 30){
        return [NSString stringWithFormat:@"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"M月d日";
        NSString *time = [df stringFromDate:lastDate];
        return time;
    }else if (year >= 1){
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年M月d日";
        NSString *time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
    
}

//判断手机号码格式是否正确
+ (BOOL)validataMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    }else{
        //移动号段正则表达式
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        //联通号段正则表达式
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        //电信号段正则表达式
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

//判断邮箱格式是否正确
+ (BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"^[A-Z0-9a-z._%+_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHED %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//将十六进制颜色转换成 UIcolor
+ (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
    
}

//对图片进行滤镜处理
+ (UIImage *)filterWithOriginalImage:(UIImage *)image fiterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return resultImage;
}

//对图片进行模糊处理
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}

//调整图片饱和度、亮度、对比度
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return resultImage;
}

//创建一张实时模糊效果的view
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}

//全屏截图
+ (UIImage *)shotScreen{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//截取一张view生成图片
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//截取view某个区域 生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}

//压缩图片到指定尺寸大小
+ (UIImage *)conpressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage *resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return resultImage;
}

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length /1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length/1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}


//获取设备IP地址
+ (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

//判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2{
    NSRange range = [string2 rangeOfString:string1];
    if (range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

//判断字符串中是否含有中文
+ (BOOL)isHaceChineseInString:(NSString *)string{
    for (NSInteger i=0; i<[string length]; i++) {
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

//判断字符串中是否全部为数字
+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c = [string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

//绘制虚线
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc]initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame), CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length],[NSNumber numberWithInt:spacing],nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
    
}


@end
