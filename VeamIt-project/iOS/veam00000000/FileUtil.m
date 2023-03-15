//
//  FileUtil.m
//  TestWebapi2
//
//  Created by veam on 2014/02/02.
//  Copyright (c) 2014年 veam All rights reserved.
//

#import "FileUtil.h"

#define CACHE_PATH @"cache"

@implementation FileUtil

//ファイル一覧の取得
+ (NSArray*)fileNames:(NSString*)pathName {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathName error:nil];
}

//ファイル・ディレクトリが存在するか
+ (BOOL)existsFileWithName:(NSString*)pathName {
	return [[NSFileManager defaultManager] fileExistsAtPath:pathName];
}

//ディレクトリの生成
+ (void)makeDir:(NSString*)pathName {
    if ([FileUtil existsFileWithName:pathName]){
        return;
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
}

//ファイル・ディレクトリの削除
+ (void)removeFileWithName:(NSString*)pathName {
    if (![FileUtil existsFileWithName:pathName]){
        return;
    }
	[[NSFileManager defaultManager] removeItemAtPath:pathName error:nil];
}

+(NSString*)getTemporaryDirectory
{
    NSString* cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:CACHE_PATH];
    return cachePath;
}

@end
