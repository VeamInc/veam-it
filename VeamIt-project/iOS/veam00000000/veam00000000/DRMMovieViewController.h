//
//  MovieViewController.h
//  VEAM
//
//  Created by veam on 11/12/04.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DRMMPMoviePlayerControllerCustom.h"
#import "WebServer.h"
#import "MovieAnnotations.h"
#import "VeamViewController.h"
#import "Three20/Three20.h"
#import "Video.h"
#import "VideoData.h"
#import "AppDelegate.h"

//MovieExの宣言
@interface DRMMovieViewController : VeamViewController<TTNavigatorDelegate,LoginPendingOperationDelegate> {
    DRMMPMoviePlayerControllerCustom* _player;
    UIButton*   _customButton;
    UIButton*   captureButton ;
    NSTimer*    _timer;
    CGRect      _btnRect;
    NSString*   _btnText;
    NSString*   _btnURI;
    UIImage*    _btnImage;
	NSString*   strPathName;
	NSString*   strPathName2;
    WebServer *wserver;
    BOOL destructionDone ;
    UILabel *annotationLabel1 ;
    UILabel *annotationLabel2 ;
    
    NSString *contentId ;
    NSString *contentId2 ;
    NSString *movieKey ;
    NSString *movieKey2 ;
    NSString *zoomFileName ;
    NSString *zoomFileName2 ;
    
    CGFloat deviceWidth ;
    CGFloat deviceHeight ;

    MovieAnnotations *movieAnnotations1 ;
    MovieAnnotations *movieAnnotations2 ;
    
    NSInteger annotationCount ;
    BOOL switching ;
    
    NSInteger currentAngle ;
    NSTimeInterval timeOffset ;
    
    UIImageView *zoomButtonImageView ;
    
    UIImageView *pauseImageView ;
    UIImageView *sliderImageView ;
    UIImageView *sliderBackImageView ;
    
    UIImageView *linkImageView ;
    UILabel *linkLabel ;
    UIImage *linkShortImage ;
    UIImage *linkLongImage ;
    CGFloat linkShortMargin ;
    CGFloat linkLongMargin ;

    
    CGRect sliderBackFrame  ;
    CGRect currentSliderBackFrame  ;
    CGRect sliderPointFrame ;
    CGRect durationFrame ;
    CGRect currentTimeFrame ;
    CGRect pauseFrame ;
    
    CGFloat sliderWidth ;
    UILabel *currentTimeLabel ;
    UILabel *durationLabel ;
    
    NSString *videoTitleName ;
    
    UILabel *titleLabel ;
    UIView *grayView ;
    UIView *bottomGrayView ;
    CGRect annotation1Frame ;
    CGRect annotation2Frame ;
    
    CGFloat firstX ;
    CGFloat firstY ;
    BOOL isDragging ;
    BOOL isShowingController ;
    
    CGFloat statusBarHeight ;
    
    CGFloat sliderPointWidth ;
    CGFloat sliderLimitLeft ;
    CGFloat sliderLimitRight ;
    
    UIView *controllerView ;
    
    UIInterfaceOrientation currentOrientation ;
    NSTimer *controllerTimer ;
    
    
    
    UIScrollView *scrollView ;
    CGRect scrollViewFrame ;
    CGSize scrollViewSize ;
    UIImageView *favoriteImageView ;
    UIImageView *likeImageView ;
    UIImageView *commentImageView ;
    UIImageView *heartImageView ;
    UIImageView *commentNumImageView ;
    UILabel *commentNumLabel ;
    UIImageView *expandImageView ;
    UIView *commentBackView ;
    TTStyledTextLabel *commentLabel ;
    UILabel *likesLabel ;
    TTNavigator *ttNavigator ;
    BOOL appearFlag ;
    BOOL isLikeSending ;
    BOOL isPostViewShown ;
    BOOL isLike ;
    BOOL isUpdating ;
    BOOL showAllComments ;
    BOOL forcePlay ;
    BOOL manuallyPaused ;
    VideoData *videoData ;
    NSInteger pendingOperation ;
    NSInteger pendingTag ;
    UIView *tapDetectorView ;



    
    

}
//表示位置設定
- (void)setCostomButtonFrame: (CGRect) rect;
//ボタンのテキスト設定
- (void)setCostomButtonText: (NSString*) str;
//ボタンの画像設定
- (void)setCostomButtonImage: (UIImage*) img;
//タップしたときに表示するURI
- (void)setCostomButtonURI: (NSString*) uri;

@property(nonatomic, retain) NSString* strPathName;
@property(nonatomic, retain) NSString* strPathName2;
@property(nonatomic, retain) NSString* contentId;
@property(nonatomic, retain) NSString* contentId2;
@property(nonatomic, retain) NSString* movieKey;
@property(nonatomic, retain) NSString* movieKey2;
@property(nonatomic, retain) NSString* videoTitleName;
@property(nonatomic, retain) NSString* zoomFileName;
@property(nonatomic, retain) NSString* zoomFileName2;
@property(nonatomic, retain) NSString* linkUrl;
@property(nonatomic, retain) Video* video;

@property(nonatomic, assign) NSInteger annotationCount ;


@end