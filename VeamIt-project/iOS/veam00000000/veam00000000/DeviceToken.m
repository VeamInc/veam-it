//
//  DeviceToken.m
//  veam31000006
//
//  Created by veam on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceToken.h"
#import "VeamUtil.h"

@implementation DeviceToken 

@synthesize token;

-(void)sendToProvider
{
    NSURL *url = [VeamUtil getApiUrl:@"devicetoken/register"] ;
    
    NSInteger length = token.length ;
    NSMutableString* tokenString = [NSMutableString stringWithCapacity:length * 2];
    unsigned char *devTokenBytes = (unsigned char *)[token bytes];
    for(int i = 0; i < length ; i++){
        [tokenString appendFormat:@"%02x", devTokenBytes[i]  ];
    }
    
    NSString *envString = [VeamUtil getApsEnvironmentString] ; // "P" for production , "D" for development
    [VeamUtil setDeviceToken:tokenString environment:envString] ;
    //NSLog(@"setDeviceToken %@ %@",tokenString,envString) ;
    NSInteger socialUserId = [VeamUtil getSocialUserId] ;
    
    NSString *params = [NSString stringWithFormat:@"a=%@&t=%@&sid=%d&e=%@",[VeamUtil getAppId],tokenString,socialUserId,envString] ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    
    NSURLConnection *downloadConnection = [
                                           [NSURLConnection alloc]
                                           initWithRequest : request
                                           delegate : self
                                           ];
    
	if (downloadConnection == nil) {
		UIAlertView *alert = [
                              [UIAlertView alloc]
                              initWithTitle : @"ConnectionError"
                              message : @"ConnectionError"
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil
                              ];
		[alert show];
	}
    
    return ;

    
}



// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
     NSInteger statusCode = [httpResponse statusCode];
     //NSLog(@"statusCode = %d",statusCode) ;
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    //NSLog(@"didReceiveData") ;
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection error = %@",error) ;
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //NSLog(@"connectionDidFinishLoading") ;
}


@end
