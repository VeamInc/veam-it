//
//  FileUtil.h
//  TestWebapi2
//
//  Created by veam on 2014/02/02.
//  Copyright (c) 2014年 veam All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+ (NSArray*)fileNames:(NSString*)pathName;

//ファイル・ディレクトリが存在するか
+ (BOOL)existsFileWithName:(NSString*)pathName;

//ディレクトリの生成
+ (void)makeDir:(NSString*)pathName;

//ファイル・ディレクトリの削除
+ (void)removeFileWithName:(NSString*)fileName;

+(NSString*)getTemporaryDirectory;

@end
