//
//  NSString+Additions.m
//  UsenMusicPlayer
//
//  Created by veam on 2013/02/18.
//  Copyright (c) 2013年 veam All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions)

- (NSString*)uriEncode
{
    return ((NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8)));
}


@end
