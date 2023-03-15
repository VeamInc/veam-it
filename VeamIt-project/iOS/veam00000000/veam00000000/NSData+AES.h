//
//  NSData+AES.h
//  VEAM DRM対応
//
//  Created by veam on 12/01/15.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface NSData (AES)
- (NSData *)AES128Operation:(CCOperation)operation key:(NSData *)key iv:(NSData *)iv;
- (NSData *)AES128EncryptWithKey:(NSData *)key iv:(NSData *)iv;
- (NSData *)AES128DecryptWithKey:(NSData *)key iv:(NSData *)iv;
@end
