//
//  VideoDownloader.m
//  veam31000000
//
//  Created by veam on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoDownloader.h"
#import "AppDelegate.h"
#import "VeamUtil.h"

@implementation VideoDownloader

@synthesize delegate;

#define kProgressViewKey @"ProgressViewKey"
#define kAlertViewKey @"AlertViewKey"
static float progressValue = 0.0f; 

-(void)notifyStart
{
    //NSLog(@"VideoDownloader::notifyStart") ;
    //[[AppDelegate sharedInstance] setVideoDownloading:YES] ;
}

-(void)notifyEnd
{
    //NSLog(@"VideoDownloader::notifyEnd") ;
    //[[AppDelegate sharedInstance] setVideoDownloading:NO] ;
}

-(void)onCancel
{
    //NSLog(@"VideoDownlaoder::onCancel") ;
    
    [mProgressAlertView dismissWithClickedButtonIndex:0 animated:NO] ;
    if(downloadConnection != nil){
        [downloadConnection cancel] ;
        downloadConnection = nil ;
    }
    
    if(downloadFile != nil){
        [downloadFile closeFile] ;
        downloadFile = nil ;
    }
    
    if(delegate != nil){
        [self.delegate videoDownloadCancelled:video indexPath:indexPath] ;
    }
    
    [self notifyEnd] ;

}

-(VideoDownloader *)initWithVideo:(Video *)targetVideo indexPath:(NSIndexPath *)targetIndexPath delegate:(id<VideoDownloaderDelegate>)targetDelegate
{
    
    self = [super init] ;
    
    delegate = targetDelegate ;
    indexPath = targetIndexPath ;
    video = targetVideo ;
    progress = 0.0 ;

    /*
    mProgressAlertView = [[UIAlertView alloc] initWithTitle: title
                                                    message: description
                                                   delegate: self
                                          cancelButtonTitle: cancel
                                          otherButtonTitles: nil];

    mProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 82.0f, 225.0f, 25)];
    [mProgressAlertView addSubview:mProgressView];
    [mProgressView setProgressViewStyle: UIProgressViewStyleBar];

    mProgressAlertView.delegate = self;
    [mProgressAlertView show];
     */

    progressValue = 0.0f;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(onCancel) name:[NSString stringWithFormat:@"veam%@_VIDEO_DOWNLOAD_CANCEL",[VeamUtil getAppId]] object:nil] ;
    
    [self urlCompleted:[video dataUrl] key:[video key] size:[video dataSize]] ;
    
    return self ;
}

-(void)dealloc
{
    //NSLog(@"VideoDownloader::dealloc") ;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:[NSString stringWithFormat:@"veam%@_VIDEO_DOWNLOAD_CANCEL",[VeamUtil getAppId]] object:nil] ;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

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
            [self.delegate videoDownloadCancelled:video indexPath:indexPath] ;
        }
        [self notifyEnd] ;
    }
}

-(void) urlCompleted:(NSString *)urlString key:(NSString *)key size:(NSString *)size
{
    if(urlString == nil){
        // alert dismiss and disp message
        NSLog(@"error") ;
        [VeamUtil dispError:NSLocalizedString(@"ServerError", @"")] ;
    } else {
        // download start
        [self notifyStart] ;
        
        //NSLog(@"download start url=%@ key=%@ size=%@",urlString,key,size) ;

        NSURL *url = [NSURL URLWithString:[VeamUtil getSecureUrl:urlString]] ;
        downloadSize = [size intValue] ;  // size of file
        NSString *workFileName ;
        workFileName = [NSString stringWithFormat:@"p%d.mp4.part",[[video videoId] intValue]] ;
        NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:workFileName] ;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url] ;
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData] ;
        if([VeamUtil fileExistsAtCachesDirectory:workFileName]){
            // 途中のファイルが存在したらリジューム
            //---------------- setting range for download resume -----------------------
            NSInteger offset = [VeamUtil fileSizeAtCachesDirectory:workFileName] ;
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


// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    /*
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
     NSInteger statusCode = [httpResponse statusCode];
     //NSLog(@"statusCode = %d",statusCode) ;
     */
    
	downloadTotalBytes = [response expectedContentLength];
	downloadedBytes = 0.0;
    
    //NSLog(@"downloadTotalBytes=%f",downloadTotalBytes) ;
}

- (float)getProgress
{
    return progress ;
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    //NSLog(@"didReceiveData length=%d",[data length]) ;
    
    [downloadFile writeData:data] ;
    
	// プログレスバー更新
	downloadedBytes += [data length];
    
    //NSLog(@"%f / %f ",downloadedBytes,downloadTotalBytes) ;
    progress = (downloadedBytes + downloadOffset) / (downloadTotalBytes + downloadOffset) ;
    if(delegate != nil){
        [delegate videoDownloadProgress:video progress:progress indexPath:indexPath] ;
    }

    
    
    //	[downloadProgress setProgress:(downloadedBytes/downloadTotalBytes)] ;
}


// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [downloadFile closeFile] ;
    downloadFile = nil ;
    downloadConnection = nil ;

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
    if(delegate != nil){
        [self.delegate videoDownloadCancelled:video indexPath:indexPath] ;
    }

}


//非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //NSLog(@"connectionDidFinishLoading url=%@",[[[connection originalRequest] URL] path] ) ;
    //NSLog(@"connectionDidFinishLoading") ;
    [mProgressAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self notifyEnd] ;
    
    [downloadFile closeFile] ;
    downloadFile = nil ;
    downloadConnection = nil ;
    
    //NSLog(@"download size = %d",downloadSize) ;
    
    NSString *workFileName = [NSString stringWithFormat:@"p%@.mp4.part",[video videoId]] ;
    if([VeamUtil fileSizeAtCachesDirectory:workFileName] != downloadSize){
        NSLog(@"unexpected download size") ;
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
                [self.delegate videoDownloadCancelled:video indexPath:indexPath] ;
            }
            return ;
    }
    
    NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:workFileName] ;
    NSString *targetFilePath = [VeamUtil getFilePathAtCachesDirectory:[NSString stringWithFormat:@"p%@.mp4",[video videoId]]] ;
    [VeamUtil moveFile:workFilePath toPath:targetFilePath] ;
    
    if(delegate != nil){
        //NSLog(@"call videoDownloadCompleted") ;
        [self.delegate videoDownloadCompleted:video indexPath:indexPath] ;
    }
}


@end
