//
//  AudioPlayViewController.h
//  veam31000016
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "Audio.h"
#import "AudioData.h"
#import "Three20/Three20.h"
#import "AppDelegate.h"
#import "PieChartsView.h"
#import "AudioDataDownloader.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "ImageDownloader.h"
//#import <AVFoundation/AVAudioSession.h>



@interface AudioPlayViewController : VeamViewController<UIWebViewDelegate,TTNavigatorDelegate,LoginPendingOperationDelegate,AudioDataDownloaderDelegate,AVAudioPlayerDelegate,ImageDownloaderDelegate>
{
    UIWebView *webView ;
    Audio *audio ;
    BOOL appearFlag ;
    NSString *title;
    NSString *duration ;
    UIActivityIndicatorView *indicator ;
    TTNavigator *ttNavigator ;
    UIScrollView *scrollView ;
    BOOL isBrowsing ;
    UIImageView *favoriteImageView ;
    UIImageView *likeImageView ;
    UIImageView *linkImageView ;
    UIImageView *commentImageView ;
    
    BOOL isLike ;
    BOOL isUpdating ;
    BOOL showAllComments ;
    BOOL isLikeSending ;
    BOOL isPostViewShown ;

    UIView *commentBackView ;
    TTStyledTextLabel *commentLabel ;
    UILabel *likesLabel ;
    
    UIActivityIndicatorView *downloadIndicator ;
    
    UILabel *progressLabel ;
    
    AudioData *audioData ;
    
    NSInteger pendingOperation ;
    NSInteger pendingTag ;
    
    UIImageView *heartImageView ;
    UIImageView *commentNumImageView ;
    UILabel *commentNumLabel ;
    UIImageView *expandImageView ;
    
    PieChartsView *pieView ;
    
    AudioDataDownloader *audioDataDownloader ;
    
    NSInteger previousDownloadProgress ;
    
    
    AVAudioPlayer *musicPlayer ;
    
    UIImageView *centerPlayImageView ;
    UIImageView *centerReplayImageView ;
    UIImageView *playButtonImageView ;
    
    NSTimer *progressTimer ;
    
    CGFloat firstX ;
    CGFloat firstY ;
    BOOL isDragging ;
    CGFloat sliderPointWidth ;
    CGFloat sliderLimitLeft ;
    CGFloat sliderLimitRight ;
    UIImageView *sliderImageView ;
    CGRect sliderBackFrame ;
    UILabel *currentTimeLabel ;

    NSMutableDictionary *imageDownloadsInProgress ;
    UIImageView *audioImageView ;

}

@property (nonatomic, retain) Audio *audio ;

@end
