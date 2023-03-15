//
//  Configurations.h
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configurations : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary* dictionary ;
    BOOL isParsing ;
}

- (id)initWithResourceFile ;
- (id)initWithData:(NSData *)data ;
- (id)initWithUrl:(NSURL *)url ;
- (NSString *)getValueForKey:(NSString *)key ;
- (void)setValueForKey:(NSString *)key value:(NSString *)value ;

@end
