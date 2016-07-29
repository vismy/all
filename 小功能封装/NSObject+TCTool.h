//
//  NSObject+TCTool.h
//  小功能封装
//
//  Created by macPro on 16/7/29.
//  Copyright © 2016年 macPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (TCTool)
//获取系统版本
+ (NSString *) getVersion;
//获取磁盘总空间大小
+ (CGFloat)diskOfAllSizeMBytes;
//获取磁盘可用空间大小
+ (CGFloat)diskOfFreeSizeMBytes;
//获取指定路径下的某个文件的大小
+ (CGFloat)fileSizeAtPath:(NSString *)filePath;
//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)floderPath;

@end
