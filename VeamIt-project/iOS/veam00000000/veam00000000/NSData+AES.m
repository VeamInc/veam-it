//
//  NSData+AES.h
//  VEAM DRM対応
//
//  Created by veam on 12/01/15.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//
#import "NSData+AES.h"


@implementation NSData (AES)

- (NSData *)AES128Operation:(CCOperation)operation key:(NSData *)key iv:(NSData *)iv
{
	const unsigned char* pKey = (const unsigned char*)[key bytes];
	char keyPtr[kCCKeySizeAES128 + 1]; 
	memset(keyPtr, 0, sizeof(keyPtr));
	memcpy(keyPtr, pKey, [key length]);

	const unsigned char* pIv = (const unsigned char*)[iv bytes];
	char ivPtr[kCCBlockSizeAES128 + 1]; 
	memset(ivPtr, 0, sizeof(ivPtr));
	memcpy(ivPtr, pIv, [iv length]);

	NSUInteger dataLength = [self length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);

	size_t numBytesCrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(operation,
											kCCAlgorithmAES128,
											0,	// no padding
											keyPtr,
											kCCBlockSizeAES128,
												ivPtr,
											[self bytes],
											dataLength,
											buffer,
											bufferSize,
											&numBytesCrypted);
    
    NSData *retData ;
	if (cryptStatus == kCCSuccess) {
		//return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        retData = [NSData dataWithBytes:buffer length:numBytesCrypted] ;
	}
	free(buffer);
	return retData ;
}

- (NSData *)AES128EncryptWithKey:(NSData *)key iv:(NSData *)iv
{
  return [self AES128Operation:kCCEncrypt key:key iv:iv];
}

- (NSData *)AES128DecryptWithKey:(NSData *)key iv:(NSData *)iv
{
  return [self AES128Operation:kCCDecrypt key:key iv:iv];
}

@end
