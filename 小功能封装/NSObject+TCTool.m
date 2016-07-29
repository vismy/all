//
//  NSObject+TCTool.m
//  小功能封装
//
//  Created by macPro on 16/7/29.
//  Copyright © 2016年 macPro. All rights reserved.
//

#import "NSObject+TCTool.h"

@implementation NSObject (TCTool)

+ (NSString *) getVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (CGFloat)diskOfAllSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error:%@",error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}

//获取磁盘可用空间大小
+ (CGFloat)diskOfFreeSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error:%@",error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}
//获取指定路径下的某个文件的大小
+ (CGFloat)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return 0;
    }
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}

+ (long long)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:filePath];
    }
    return folderSize;
}


@end
