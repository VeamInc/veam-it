//
//  CommUtil.m
//  TestWebapi2
//
//  Created by veam on 2014/02/02.
//  Copyright (c) 2014年 veam All rights reserved.
//

#import "CommUtil.h"
#import "SVProgressHUD.h"
#import "VeamUtil.h" 

@implementation CommUtil

+(void)requestFile:(NSString*)urlString Target:(id)target Selector:(SEL)callback
{
    // ステータスバーにインジケータを表示する
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Hang on a sec!\n\nSwipe to view App Stats\nfrom various angles" maskType:SVProgressHUDMaskTypeBlack];

    NSURL *url = [NSURL URLWithString:[VeamUtil getSecureUrl:urlString]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:HTTP_API_TIMEOUT];
    [urlRequest setValue:HTTP_API_USER_AGENT forHTTPHeaderField:@"User-Agent"];

    
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         // ステータスバーのインジケータを非表示にする
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [SVProgressHUD dismiss];

         NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
         
         if(res.statusCode == 200){
             
             if (data) {
                 [target performSelector:callback withObject:data];
             }
             else{
                 // dataが不正
                 [target performSelector:callback withObject:nil];
             }
         }
         else{
             // request エラー
             [target performSelector:callback withObject:nil];
         }
     }];
    return ;
}


@end
