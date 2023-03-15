//
//  WebServer.m
//  VEAM DRM対応
//
//  Created by veam on 12/01/20.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//


#import <arpa/inet.h>
#import <fcntl.h>
#import "WebServer.h"
#import "NSData+AES.h" // remove due to export laws
#import "AppDelegate.h"
//#import "utils.h"
#import "VeamUtil.h"

@implementation WebServer
@synthesize portNumber;

#define BLOCK_LENGTH 8192
#define HOSTNAME @"localhost"


unsigned char pStaticKey[] = {
    0x4D,0xA7,0xFB,0x38,0xE9,0x67,0x96,0xB2,0xFD,0x07,0x5D,0x4C,0x25,0x0B,0x0A,0xBC,
    0x69,0xAE,0x3C,0x05,0xC7,0x5C,0x75,0x50,0xC7,0x62,0xCF,0xBE,0x34,0x59,0xBF,0xDC,
    0x42,0x26,0xF0,0x37,0x94,0xBC,0x3B,0x97,0xEA,0x6C,0x65,0xBE,0xB8,0x1F,0xE1,0x9B,
    0xE2,0xC8,0xCA,0x2A,0x01,0xA6,0x8D,0xFE,0x07,0x98,0x0B,0xCC,0x26,0x1F,0x1A,0x90,
    0x02,0xDE,0xD1,0xED,0x20,0x2F,0xB0,0x34,0xD7,0x29,0xBA,0x6A,0xBB,0x7B,0xF3,0x4C,
    0x71,0x71,0x18,0xD9,0xAD,0x3D,0x20,0x1F,0xEB,0xBF,0x87,0x43,0x92,0x58,0x4A,0x25,
    0x19,0x08,0xB7,0x0F,0x08,0x8B,0x31,0xE2,0xCA,0x07,0x22,0xB7,0x10,0x6E,0x0E,0xF5,
    0x8A,0x26,0x84,0x19,0xA3,0xEF,0xA6,0xB2,0x38,0x62,0x17,0x92,0xB7,0x9A,0xEB,0xF4,
    0xBC,0x8F,0xE6,0x81,0xA9,0xD8,0x13,0xBD,0xBF,0x90,0x5B,0x54,0x71,0x6A,0xD9,0xFA,
    0x09,0x4E,0x0F,0xB8,0xCE,0x6C,0xAB,0x51,0xC4,0xB0,0xA8,0x39,0x6C,0xE7,0xCE,0x5C,
    0x0E,0x61,0x29,0xD8,0x34,0xD4,0x7A,0x2A,0x7B,0x89,0xF5,0x22,0xC3,0xD9,0xE3,0xF8,
    0x17,0xE5,0x30,0x3B,0xAA,0x52,0x2F,0x00,0xA1,0xCA,0x2C,0xD6,0x4B,0xDC,0x89,0x6F,
    0x4B,0x8C,0xB9,0x37,0xDB,0x3B,0xB8,0xAD,0x1F,0x71,0xC3,0x9F,0x6B,0xC6,0x6F,0xED,
    0xCD,0x0C,0xCC,0xD9,0xD3,0x26,0x18,0x41,0x44,0x0B,0x7B,0xEF,0xBC,0x9E,0xD3,0xE0,
    0x28,0xC3,0x39,0x86,0xD3,0xF3,0x07,0x30,0x15,0x8E,0x58,0x8D,0xED,0x92,0x29,0x3C,
    0x7E,0xE6,0x35,0xCE,0xB5,0x4E,0x5E,0x11,0xC4,0x84,0xFB,0xC5,0x8A,0xEA,0x52,0xAA
};

NSString* pPrivate = @"E1A8C6A4BAF9ACF0EDDE4C36AFB6F72C00AE4D427F317313E452D4166B876507"; // 目くらましダミー


// 動画ファイルのURLを作成
NSString* getHttpUrl(NSString* strFileName)
{
	NSString* strPathName
    = [NSString stringWithFormat:@"http://%@:%d/%@", HOSTNAME, DEFAULT_SERVER_PORT, strFileName];
	//NSLog(@"%@", strPathName);
    
    
	return strPathName;
}

// 文字列を16進数としてデータ化する
- (NSData*) toByte:(NSString*) hexString
{
	int len = [hexString length] / 2;
    
	NSMutableData* resultBuf = [[NSMutableData alloc] initWithLength:len];
    if(resultBuf == nil){
        //NSLog(@"resultBuf is nil") ;
    }

	unsigned char* pResultBuf = [resultBuf mutableBytes];
    
	for(int i=0; i<len; i++){
		NSString* strValue = [hexString substringWithRange:NSMakeRange(2*i,2)];
		unsigned int result;
		[[NSScanner scannerWithString:strValue] scanHexInt:&result];
    	*(pResultBuf+i) = (char)result;
	}
	return resultBuf;
}

// remove due to export laws
// デコード処理
// AES/CBC/NoPadding キー長128bit ブロック長128bitでデコード
- (NSData*) decrypt:(NSString*)pPrivate readbuf:(NSData*)readBuf 
{
	// keyデータの作成(0~31byte目をkeyとして扱う)
	NSString* strKey = [pPrivate substringWithRange:NSMakeRange( 0,32)];
	NSData* key = [self toByte:strKey];
    
	// ivデータの作成(32~63byte目をivとして扱う)
	NSString* strIv  = [pPrivate substringWithRange:NSMakeRange(32,32)];
	NSData* iv = [self toByte:strIv];
    
	// AESデコード
	NSData *decodeData = [readBuf AES128DecryptWithKey:key iv:iv];
    
	return decodeData;
}


//WebServerスタート
- (BOOL)startServer
{
    int on;
    struct sockaddr_in addr;
    
	pPrivate = @"__PRIVATE_KEY__"; 
    
    pPrivate = [[AppDelegate sharedInstance] movieKey] ;
    /*
     if(pPrivate == nil){
     //NSLog(@"pPrivate == nil") ;
     } else  {
     //NSLog(@"streaming use key %@",pPrivate) ;
     }
     */
    
    
    portNumber = DEFAULT_SERVER_PORT;
    
    //初期化処理開始。Linuxと同じ仕組み
    listenSock = socket(AF_INET, SOCK_STREAM, 0);
    if (listenSock < 0) {
        return NO;
    }
    
    on = 1;
    setsockopt(listenSock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
    
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port = htons(portNumber);
    
    if (bind(listenSock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        close(listenSock);
        return NO;
    }
	
    socklen_t len = sizeof(serv_addr);
    if (getsockname(listenSock, (struct sockaddr *)&serv_addr, &len)  < 0) {
        close(listenSock);
        return NO;
    }
    
    if (listen(listenSock, 16) < 0) {
        close(listenSock);
        return NO;
    }
    
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil];
    [thread start];
	
    return YES;
}

//WebServer停止
- (void)stopServer
{
    if (listenSock >= 0) {
        close(listenSock);
    }
    listenSock = -1;
}

// 接続待ちスレッド、クライアントが接続してくるのを待つ
- (void)threadMain
{
    socklen_t len;
    struct sockaddr_in caddr;
    
    for (;;) {
        len = sizeof(caddr);
        serverSock = accept(listenSock, (struct sockaddr *)&caddr, &len);
        if (serverSock < 0) {
            break;
        }
        //NSLog(@"accept  serverSock");
        
        ///接続がきたら、応答メッセージ、データを送る。単一クライアントのみ想定複数だと配列で管理する必要あり
        [self sendContents];
        //NSLog(@"Close  serverSock");
        
        close(serverSock);
        serverSock = 0;
    }
    
    if (listenSock >= 0) {
        close(listenSock);
    }
    listenSock = -1;
    
    [NSThread exit];
}

//リクエストヘッダ解析　一行読み込み　改行まで
- (BOOL)readLine:(char *)line size:(int)size
{
    char *p = line;
    
    while (p < line + size) {
        int len = read(serverSock, p, 1);
        if (len <= 0) {
            return NO;
        }
        if (p > line && *p == '\n' && *(p-1) == '\r') {
            *(p-1) = 0; // nullでおわり
            return YES;
        }
        p++;
    }
    return NO; // メッセージがないよ
}

//リクエストヘッダ解析
- (NSString*)parseHttpRequest
{
    char line[1024];
    int lineno = 0;
    NSString *filereq = @"/";
    
    // リクエストヘッダ解析
    
    for (;;) {
        memset(line, 0, 1024);
        if (![self readLine:line size:1024]) {
            return nil; // error
        }
        //NSLog(@"%s", line);
        
        if (strlen(line) == 0) {
            break; // ヘッダ終わり
        }
        
        if (lineno == 0) {
            char *p, *p2 = NULL;
            p = strtok(line, " ");
            if (p){
				p2 = strtok(NULL, " ");
            }
			if (p2){
                filereq = [NSString stringWithCString:p2 encoding:NSASCIIStringEncoding];
            }
        }
		else if (strncasecmp(line, "Range:", 6) == 0) {
            char *p, *p2 = NULL;
            p = strtok(line, "=");
            if (p){
				p2 = strtok(NULL, "-");
            }
			if (p2){
                rStartLength = atoi(p2);
            }
            if (p){
				p2 = strtok(NULL, "-");
            }
			if (p2){
                rEndLength = atoi(p2);
            }
			else{
                rEndLength = -1;
            }
        }
        lineno++;
    }
    return filereq;
}

//返信データ作成
- (void)sendContents
{
    @autoreleasepool
    {
        //206の分割コンテンツとして返す　複数返さないので、multipart形式でなくてよい
        sendSeq = 0;
        sendFileSize = 0;
        int set = 1;
        //SIGPIPEは無効にする。
        setsockopt(serverSock, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
        out = NULL;

        NSDate *dateLast = nil;
        NSDate *dateNow = nil;
        NSTimeInterval since;
        bool lastFlag = false;
        int currentPosi = 0;
        int fileLength = 0;
        int endLength = 0;

        for(;;)
        {
            NSString* filereq = [self parseHttpRequest];
            if(filereq == nil)
            {
                if(dateNow == nil)
                    dateLast = [NSDate date];
                dateNow = [NSDate date];
                since = [dateNow timeIntervalSinceDate:dateLast];
                if(since > 10){
                    NSLog(@"timeout");
                    break;
                }
                continue;
            }
            dateNow = nil;
            
            NSString* filereq2 = [filereq stringByReplacingOccurrencesOfString:@"/" withString:@""];
            //NSArray *names = [filereq2 componentsSeparatedByString:@"."];
            //NSLog(@"%@,%@,%llu,%d", filereq, filereq2, sendSeq, [names count]);
            //NSLog(@"%@,%@,%llu", filereq, filereq2, sendSeq);
            
            //        if(filereq != nil && sendSeq == 0 && [names count] == 2)
            if(filereq != nil && sendSeq == 0)
            {
                // 入力ファイルのパスを作成
                //NSString* strInputPath = [VeamUtil getPreviewPath:filereq2] ;
                NSString *fileName = [NSString stringWithFormat:@"p%@.mp4",filereq2] ;
                NSString* strInputPath = [VeamUtil getFilePathAtCachesDirectory:fileName] ;
                //NSLog(@"filePath:%@", strInputPath);
                
                /* ファイルの存在確認 */
                if ([[NSFileManager defaultManager] fileExistsAtPath:strInputPath]) {
                    /* ファイルタイプの取得 */
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:strInputPath error:NULL];
                    NSString *fileSize = [dict objectForKey:NSFileSize];
                    sendFileSize = [fileSize longLongValue];
                    out = fopen((char *) [strInputPath UTF8String], "rb");
                    
                    fileLength = endLength = [dict fileSize];
                    currentPosi = 0;
                    lastFlag = false;
                    
                    if(out){
                        if(pPrivate != nil){
                            // 鍵が渡された場合ファイルが本当に暗号化されているかどうかチェック
                            unsigned char workBuf[12] ;
                            fread(workBuf, sizeof(unsigned char), 12, out);
                            if(strncmp((char *)(workBuf+4), "ftypmmp4", 8) == 0){
                                //NSLog(@"pPrivate!=nil but ftype=mmp4") ;
                                pPrivate = nil ;
                            }
                        }
                    }
                }
            }        
            if(out)
            {
                // NSDateFormatterのインスタンス生成
                NSDateFormatter* form = [[NSDateFormatter alloc] init];
                // NSDateFormatterに書式指定を行う
                [form setDateFormat:@"EEE, dd MMM yyyy H:mm:ss"];
                form.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
                // 書式指定に従って文字出力
                NSString* strDate = [form stringFromDate:[NSDate date]];
                
                unsigned long long  readLength = 1;
                if((rEndLength==0 && rStartLength ==0)){
                    // Rangeの開始と終了が０だった
                    // 開始を０，長さを１にする
                    rEndLength = 1;
                    rStartLength = 0;
                    if(rEndLength > sendFileSize){
                        rEndLength = sendFileSize;
                    }
                }
                
                if(rEndLength==-1){
                    // Rangeの終了が入っていなかったとき
                    // Endを適当に指定
                    rEndLength = rStartLength + 1024*1024*3;
                    if(rEndLength > sendFileSize){
                        rEndLength = sendFileSize;
                    }
                }
                readLength = (rEndLength - rStartLength) + 1;
                NSString* hed1 = [NSString stringWithFormat:@"HTTP/1.1 206 Partial content\r\n"];
                NSString* hed2 = [NSString stringWithFormat:@"Accept-Ranges: bytes\r\n"];
                NSString* hed3 = [NSString stringWithFormat:@"Content-Range: bytes %lld-%lld/%lld\r\n", rStartLength, rEndLength, sendFileSize];
                NSString* hed4 = [NSString stringWithFormat:@"Content-Length: %lld\r\n", readLength];
                NSString* hed5 = [NSString stringWithFormat:@"Last-Modified: %@\r\n", strDate];
                NSString* hed6 = [NSString stringWithFormat:@"Content-Type: video/3gpp\r\n"];
                NSString* hed7 = [NSString stringWithFormat:@"Connection: Keep-Alive\r\n\r\n"];
                NSString *hedline = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", hed1, hed2, hed3, hed4, hed5, hed6, hed7];
                
                //NSLog(@"Content-Range: bytes %lld-%lld/%lld", rStartLength, rEndLength, sendFileSize) ;
                
                //NSLog(@"%@", hedline);
                [self sendString:hedline];
                
                // rStartLength 読み込み開始位置
                // rEndLength   読み込み終了位置
                
                // range が8192の倍数で無い場合は8192の倍数の個所に設定して読み込み＆復号を行う。
                // resは指定された場所からの値を返す
                
                int seekPos = (rStartLength / BLOCK_LENGTH) * BLOCK_LENGTH;	// ファイル読み込み開始位置
                //NSLog(@"seekPos=%d",seekPos) ;
                //int readPos = rStartLength % BLOCK_LENGTH;					// ブロック中の送信開始位置
                int endPos  = rEndLength+1;									// 送信終了位置
                currentPosi = rStartLength;
                
                int offset = currentPosi - seekPos ;
                
                unsigned char buf[9000];
                fseek(out, seekPos, SEEK_SET);
                bool isTail = false;
                
                
                int sendbuff;
                int res = 0;
                /*
                 socklen_t optlen;
                 // Get buffer size
                 optlen = sizeof(sendbuff);
                 res = getsockopt(serverSock, SOL_SOCKET, SO_SNDBUF, &sendbuff, &optlen);
                 NSLog(@"send buf = %d",sendbuff) ;
                 //sendbuff = 1048576 ; // 1MB
                 */
                
                sendbuff = 8192 ; // 
                res = setsockopt(serverSock, SOL_SOCKET, SO_SNDBUF, &sendbuff, sizeof( int ));
                
                /*
                 res = getsockopt(serverSock, SOL_SOCKET, SO_SNDBUF, &sendbuff, &optlen);
                 //NSLog(@"set send buf = %d",sendbuff) ;
                 */
                
                BOOL firstRead = YES ;
                BOOL rangeEnd = NO ;
                int tailPosi = (sendFileSize / BLOCK_LENGTH) * BLOCK_LENGTH ;
                for(;;){
                    int workLen = BLOCK_LENGTH;
                    
                    //NSLog(@"currentPosi=%d %d",currentPosi,SO_SNDBUF) ;
                    
                    // ここがデータの読み込み。 とにかく8192
                    int cnt = fread(buf, sizeof(unsigned char), workLen, out);
                    
                    // ファイルが読めなかったら終了
                    if(cnt <= 0){
                        break;
                    }
                    
                    currentPosi += cnt;
                    if(firstRead){
                        currentPosi -= offset ;
                    }
                    //NSLog(@"currentPosi=%d", currentPosi);
                    //NSLog(@"rStartLength=%llu rEndLength=%llu", rStartLength, rEndLength);
                    
                    NSData* readBuf = [[NSData alloc] initWithBytes:buf length:BLOCK_LENGTH];
                    if(readBuf == nil){
                        //NSLog(@"readBuf is nil") ;
                    }
                    
                    if(currentPosi>=endPos){
                        rangeEnd = YES ;
                        // 送信サイズをendPosまでに限定する
                        //NSLog(@"At end adjust %d - %d",cnt,currentPosi-endPos) ;
                        cnt -= (currentPosi-endPos);
                        if(currentPosi > tailPosi){
                            isTail = true;
                            //NSLog(@"tail") ;
                        }
                    }
                    
                    if(!isTail){
                        if((((int)(currentPosi / BLOCK_LENGTH)) % 4) == 1){
                            NSData* writeBuf ;
                            if(pPrivate == nil){
                                writeBuf = readBuf ;  // remove due to export laws
                            } else {
                                writeBuf = [self decrypt:pPrivate readbuf:readBuf];  // remove due to export laws
                            }
                            
                            if(firstRead){
                                unsigned char *pWriteBuf = (unsigned char *)[writeBuf bytes] ;
                                Boolean success = [self sendData:pWriteBuf + offset length:cnt - offset];
                                // しばしばEPIPEが発生するのでエラーは無視する
                                if(!success){
                                    break ;
                                }
                            } else {
                                Boolean success = [self sendData:writeBuf];
                                // しばしばEPIPEが発生するのでエラーは無視する
                                if(!success){
                                    break ;
                                }
                            }
                        } else {
                            const unsigned char* pReadBuf = (const unsigned char*)[readBuf bytes];
                            NSMutableData* writeBuf = [[NSMutableData alloc] initWithLength:cnt];
                            if(writeBuf == nil){
                                //NSLog(@"writeBuf is nil") ;
                            }

                            unsigned char* pWriteBuf = [writeBuf mutableBytes];
                            for(int i = 0 ; i < cnt ; i++){
                                *(pWriteBuf+i) = *(pReadBuf+i);
                                if(pPrivate != nil){
                                    *(pWriteBuf+i) ^= (pStaticKey[i%256] ^ (i >> 5)); // remove due to export laws
                                }
                            }
                            if(firstRead){
                                Boolean success = [self sendData:pWriteBuf + offset length:cnt - offset];
                                // しばしばEPIPEが発生するのでエラーは無視する
                                if(!success){
                                    break ;
                                }
                            } else {
                                Boolean success = [self sendData:pWriteBuf length:cnt];
                                // しばしばEPIPEが発生するのでエラーは無視する
                                if(!success){
                                    break ;
                                }
                            }
                        }
                        
                        if(rangeEnd){
                            break ;
                        }
                    } else {
                        //NSLog(@"Tail operation") ;
                        const unsigned char* pReadBuf = (const unsigned char*)[readBuf bytes];
                        NSMutableData* writeBuf = [[NSMutableData alloc]  initWithLength:cnt];
                        unsigned char* pWriteBuf = [writeBuf mutableBytes];
                        for(int i = 0 ; i < cnt ; i++){
                            *(pWriteBuf+i) = *(pReadBuf+i);
                            if(pPrivate != nil){
                                *(pWriteBuf+i) ^= 0xc5; // remove due to export laws
                            }
                        }
                        [self sendData:pWriteBuf length:cnt];
                        // しばしばEPIPEが発生するのでエラーは無視する
                        break;
                    }
                    firstRead = NO ;
                }
                //NSLog(@"Send All");
                fclose(out);
                out = NULL;
                break;
            }
            else{
                NSLog(@"404 Error");
                //ファイルがないので 404 エラー
                [self sendString:@"HTTP/1.0 404 Not Found\r\n"];
                [self sendString:@"Content-Type: text/html; charset=iso-8859-1;\r\n"];
                [self sendString:@"\r\n"];
                
                [self sendString:@"<html><head><title>404 Not Found</title></head>\n"];
                [self sendString:@"<body><h1>Not Found</h1>\n"];
                [self sendString:@"<p>The requested URL "];
                [self sendString:filereq];
                [self sendString:@" is not found on this server.</p>"];
                [self sendString:@"</body></html>"];
            }
        }
    }
}

- (void)sendString:(NSString *)string
{
    write(serverSock, [string UTF8String], [string length]);
}


#define RETRY_COUNT 1
- (Boolean)sendData:(const unsigned char *)string length:(int)length
{
    for(;;)
    {
        fd_set fdset; 
        int re; 
        struct timeval timeout;
        FD_ZERO( &fdset ); 
        FD_SET( serverSock , &fdset );
        
        /* timeoutは０秒。つまりselectはすぐ戻ってく る */ 
        timeout.tv_sec = 0; 
        timeout.tv_usec = 0;
        
        /* writeできるかチェック */ 
        re = select( serverSock+1 , NULL , &fdset , NULL , &timeout );
        if(re == 1){
            /*
             int stat = write(serverSock, string, length);
             if(stat != length){
             //NSLog(@"write error stat=%d errno=%d", stat, errno);
             return false;
             }
             else{
             return true;
             }
             */
			// エラーだったらリトライしてみる
			for(int i=0; i<RETRY_COUNT; i++){
				int stat = write(serverSock, string, length);
				if(stat == length){
					return true;
				}
				// NSLog(@"write error stat=%d errno=%d retry=%d", stat, errno,i);
			}
			return false;
            
        }
		else{
            //NSLog(@"write wait");
            usleep(20000);
        }
    }
    return false;
}

- (Boolean)sendData:(NSData*)data
{
	const unsigned char* pReadBuf = (const unsigned char*)[data bytes];
	int dataLength = [data length];
	return [self sendData:pReadBuf length:dataLength];
}


@end
