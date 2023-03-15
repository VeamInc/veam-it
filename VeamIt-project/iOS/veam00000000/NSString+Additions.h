//
//  NSString+Additions.h
//  UsenMusicPlayer
//
//  Created by veam on 2013/02/18.
//  Copyright (c) 2013年 veam All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)unMask:(NSString *)maskFrom MaskTo:(NSString *)maskTo;
- (NSString*)uriEncode;

@end
