//
//  WebServer.h
//  VEAM DRM対応
//
//  Created by veam on 12/01/20.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#include <netdb.h>
#include <sys/types.h>

#define DEFAULT_SERVER_PORT	8888
//#define DEFAULT_SERVER_PORT	7654

@interface WebServer : NSObject
{
    int portNumber;
    unsigned long long sendSeq;
    unsigned long long sendFileSize;
    int listenSock;
    struct sockaddr_in serv_addr;
    unsigned long long rStartLength;
    unsigned long long rEndLength;
    int serverSock;
    FILE *out;

    NSThread *thread;
}

@property(nonatomic,assign) int portNumber;

- (BOOL)startServer;
- (void)stopServer;


// private
- (void)sendContents;
- (void)threadMain;
- (BOOL)readLine:(char *)line size:(int)size;
- (NSString *)parseHttpRequest;
- (void)sendString:(NSString *)string;
- (Boolean)sendData:(const unsigned char *)string length:(int)length;
- (Boolean)sendData:(NSData*)data;

@end

NSString* getHttpUrl(NSString* strFileName);
