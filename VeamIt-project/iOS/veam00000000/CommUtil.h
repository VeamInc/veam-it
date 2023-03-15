//
//  CommUtil.h
//  TestWebapi2
//
//  Created by veam on 2014/02/02.
//  Copyright (c) 2014年 veam All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommUtil : NSObject

+(void)requestFile:(NSString*)urlString Target:(id)target Selector:(SEL)callback;

@end
