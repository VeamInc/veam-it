//
//  AudioDataDownloader.m
//  veam31000014
//
//  Created by veam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioDataDownloader.h"
#import "AppDelegate.h"
#import "VeamUtil.h"

@implementation AudioDataDownloader

@synthesize delegate;

#define kProgressViewKey @"ProgressViewKey"
#define kAlertViewKey @"AlertViewKey"

-(void)onCancel
{
    //NSLog(@"PreviewDownlaoder::onCancel") ;
    
    if(downloadConnection != nil){
        [downloadConnection cancel] ;
        downloadConnection = nil ;
    }
    
    if(downloadFile != nil){
        [downloadFile closeFile] ;
        downloadFile = nil ;
    }
    
    if(delegate != nil){
        [self.delegate audioDataDownloadCancelled:[audio audioId]] ;
    }
}

-(AudioDataDownloader *)initWithAudio:(Audio *)targetAudio delegate:(id<AudioDataDownloaderDelegate>)targetDelegate
{
    
    self = [super init] ;
    
    delegate = targetDelegate ;
    audio = targetAudio ;
    
    progressValue = 0.0f;
    
    NSString *urlString = [audio dataUrl] ;
    if([VeamUtil isEmpty:urlString]){
        urlString = [VeamUtil getAudioUrl:audio.audioId] ;
    }
    NSString *dataSize = [audio dataSize] ;

    //NSLog(@"download start size=%@",dataSize) ;
    //NSLog(@"download start url=%@ size=%@",urlString,[audio dataSize]) ;
    //NSLog(@"encoded url=%@",[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]) ;


    NSURL *url = [NSURL URLWithString:[VeamUtil getSecureUrl:urlString]] ;
    downloadSize = [dataSize intValue] ;  // size of file
    NSString *workFileName = [self getPartFileName] ;
    NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:workFileName] ;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url] ;
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData] ;
    if([VeamUtil fileExists:workFileName]){
        // 途中のファイルが存在したらリジューム
        //---------------- setting range for download resume -----------------------
        NSInteger offset = [VeamUtil fileSizeOf:workFileName] ;
        NSString* range = @"bytes=";
        range = [range stringByAppendingString:[[NSNumber numberWithInt:offset] stringValue]];
        range = [range stringByAppendingString:@"-"];
        //NSLog(@"range: %@", range);
        [request setValue:range forHTTPHeaderField:@"Range"];
            
        downloadFile = [NSFileHandle fileHandleForUpdatingAtPath:workFilePath] ;
        [downloadFile seekToFileOffset:offset] ;
        downloadOffset = offset ;
    } else {
        // open download part file
        //[request setValue:@"bytes=0-" forHTTPHeaderField:@"Range"];
        NSFileManager *fileManager = [NSFileManager defaultManager] ;
        [fileManager createFileAtPath:workFilePath contents:[NSData data] attributes:nil] ;
        downloadFile = [NSFileHandle fileHandleForWritingAtPath:workFilePath] ;
        downloadOffset = 0 ;
    }
    // request
    downloadConnection = [
                          [NSURLConnection alloc]
                          initWithRequest : request
                          delegate : self
                          ];
    if (downloadConnection == nil) {
        //NSLog(@"downloadConnection == nil") ;
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
    
    return self ;
}

-(void)dealloc
{
    //NSLog(@"PreviewDownloader::dealloc") ;
    /*
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:@"veam31000014_PREVIEW_DOWNLOAD_CANCEL" object:nil] ;
     */
}


#pragma mark -
#pragma mark UIAlertViewDelegate
/*
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    CGRect frame = alertView.frame;
    frame.origin.y -= 15;
    frame.size.height += 60;
    alertView.frame = frame;
    
    for (UIView* view in alertView.subviews) {
        // if ([view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
        frame = view.frame;
        if (frame.origin.y > 80) {
            frame.origin.y += 25;
            view.frame = frame;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // cancelled
    if(buttonIndex == 0){
        //NSLog(@"cancelButtonDown") ;
        if(downloadConnection != nil){
            [downloadConnection cancel] ;
            downloadConnection = nil ;
        }
        
        if(downloadFile != nil){
            [downloadFile closeFile] ;
            downloadFile = nil ;
        }
        
        if(delegate != nil){
            [self.delegate previewDownloadCancelled:mContentId] ;
        }
        [self notifyEnd] ;
    }
}

-(void) urlCompleted:(NSString *)urlString key:(NSString *)key size:(NSString *)size
{
    if(urlString == nil){
        // alert dismiss and disp message
        NSLog(@"error") ;
        [mProgressAlertView dismissWithClickedButtonIndex:0 animated:YES];
        [VeamUtil dispError:NSLocalizedString(@"ServerError", @"")] ;
    } else {
        // download start
        [self notifyStart] ;

        //NSLog(@"download start url=%@ key=%@ size=%@",urlString,key,size) ;

        NSURL *url = [NSURL URLWithString:urlString] ;
        downloadSize = [size intValue] ;  // size of file
        NSString *workFileName ;
        workFileName = [NSString stringWithFormat:@"p%d.mp4.part",[mContentId intValue]] ;
        NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:workFileName] ;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url] ;
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData] ;
        if([VeamUtil fileExists:workFileName]){
            // 途中のファイルが存在したらリジューム
            //---------------- setting range for download resume -----------------------
            NSInteger offset = [VeamUtil fileSizeOf:workFileName] ;
            NSString* range = @"bytes=";
            range = [range stringByAppendingString:[[NSNumber numberWithInt:offset] stringValue]];
            range = [range stringByAppendingString:@"-"];
            //NSLog(@"range: %@", range);
            [request setValue:range forHTTPHeaderField:@"Range"];
            
            downloadFile = [NSFileHandle fileHandleForUpdatingAtPath:workFilePath] ;
            [downloadFile seekToFileOffset:offset] ;
            downloadOffset = offset ;
        } else {
            // open download part file 
            //[request setValue:@"bytes=0-" forHTTPHeaderField:@"Range"];
            NSFileManager *fileManager = [NSFileManager defaultManager] ;
            [fileManager createFileAtPath:workFilePath contents:[NSData data] attributes:nil] ;
            downloadFile = [NSFileHandle fileHandleForWritingAtPath:workFilePath] ;
            downloadOffset = 0 ;
        }
        // request
        downloadConnection = [
                              [NSURLConnection alloc]
                              initWithRequest : request
                              delegate : self
                              ];
        if (downloadConnection == nil) {
            [mProgressAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [self notifyEnd] ;
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
    }
}
*/

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
     //NSInteger statusCode = [httpResponse statusCode];
     //NSLog(@"statusCode = %d",statusCode) ;
    
	downloadTotalBytes = [response expectedContentLength] ;
	downloadedBytes = 0.0;
    
    //NSLog(@"downloadTotalBytes=%f",downloadTotalBytes) ;
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData length=%d",[data length]) ;
    
    [downloadFile writeData:data] ;
    
	// プログレスバー更新
	downloadedBytes += [data length];
    
    //NSLog(@"%f / %f ",downloadedBytes,downloadTotalBytes) ;
    //mProgressView.progress = (downloadedBytes + downloadOffset) / (downloadTotalBytes + downloadOffset) ;
    if(delegate != nil){
        [delegate audioDataDownloadProgress:(downloadedBytes + downloadOffset) / (downloadTotalBytes + downloadOffset)] ;
    }

    //	[downloadProgress setProgress:(downloadedBytes/downloadTotalBytes)] ;
}


// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@",[error localizedDescription]) ;

    [downloadFile closeFile] ;
    downloadFile = nil ;
    downloadConnection = nil ;

    /*
    [mProgressAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self notifyEnd] ;
     */
    UIAlertView *alert = [
                          [UIAlertView alloc]
                          initWithTitle : @"ConnectionError"
                          message : @"ConnectionError"
                          delegate : nil
                          cancelButtonTitle : @"OK"
                          otherButtonTitles : nil
                          ];
    [alert show];
    if(delegate != nil){
        [self.delegate audioDataDownloadCancelled:[audio audioId]] ;
    }

}


- (NSString *)getTargetFileName
{
    return [NSString stringWithFormat:@"aud%@.dat",[audio audioId]] ;
}

- (NSString *)getPartFileName
{
    return [NSString stringWithFormat:@"%@.part",[self getTargetFileName]] ;
}


//非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //NSLog(@"connectionDidFinishLoading url=%@",[[[connection originalRequest] URL] path] ) ;
    //NSLog(@"connectionDidFinishLoading") ;
    /*
    [mProgressAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self notifyEnd] ;
     */
    
    [downloadFile closeFile] ;
    downloadFile = nil ;
    downloadConnection = nil ;
    
    //NSLog(@"download size = %d",downloadSize) ;
    
    NSString *workFileName = [self getPartFileName] ;
    if([VeamUtil fileSizeOf:workFileName] != downloadSize){
        //NSLog(@"unexpected download size") ;
        // ダウンロードサイズが違うのでファイルを削除してリトライ
        NSFileManager *fileManager = [NSFileManager defaultManager] ;
       [fileManager removeItemAtPath:[VeamUtil getFilePathAtCachesDirectory:workFileName] error:nil] ;
        // エラーになった
        UIAlertView *alert = [
                                [UIAlertView alloc]
                                initWithTitle : @"ConnectionError"
                                  message : @"ConnectionError"
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil
                                  ];
            [alert show];
            if(delegate != nil){
                [self.delegate audioDataDownloadCancelled:[audio audioId]] ;
            }
            return ;
    }
    
    NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:workFileName] ;
    NSString *targetFilePath = [VeamUtil getFilePathAtCachesDirectory:[self getTargetFileName]] ;
    [VeamUtil moveFile:workFilePath toPath:targetFilePath] ;
    
    if(delegate != nil){
        //NSLog(@"call previewDownloadCompleted") ;
        [self.delegate audioDataDownloadCompleted:[audio audioId]] ;
    }
}


@end
