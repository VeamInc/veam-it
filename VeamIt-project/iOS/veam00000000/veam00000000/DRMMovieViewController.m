
//
//  DRMMovieViewController.m
//  VEAM
//
//  Created by veam on 11/12/04.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//

#import "DRMMovieViewController.h"
#import "AppDelegate.h"
//#import "Facebook.h"
#import "VeamUtil.h"
#import "PostVideoCommentViewController.h"

#define STATUS_BAR_HEIGHT 20
#define ANNOTATION_BOX1_HEIGHT     36
#define ANNOTATION_BOX2_HEIGHT     50

#define VEAM_PENDING_OPERATION_LIKE     1
#define VEAM_PENDING_OPERATION_COMMENT  2


@implementation DRMMovieViewController

@synthesize strPathName;
@synthesize strPathName2;
@synthesize contentId ;
@synthesize contentId2 ;
@synthesize movieKey ;
@synthesize movieKey2 ;
@synthesize annotationCount ;
@synthesize videoTitleName ;
@synthesize zoomFileName ;
@synthesize zoomFileName2 ;
@synthesize linkUrl ;
@synthesize video ;


//@synthesize _btnRect, _btnTarget, _btnSelector, _btnText, _btnImage;

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    //NSLog(@"installMovieNotificationObservers") ;
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:_player];
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterFullScreen:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification 
                                               object:_player];
    
	// DRM対応 再生準備完了通知Notificationハンドラの設定
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishPreload:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateChanged)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];

}

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{    
    //NSLog(@"removeMovieNotificationHandlers") ;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:
     MPMoviePlayerPlaybackDidFinishNotification object:_player];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:
     MPMoviePlayerWillEnterFullscreenNotification object:_player];
    
	// DRM対応 再生準備完了通知Notificationハンドラの破棄(念のため)
    [[NSNotificationCenter defaultCenter]removeObserver:self name:
     MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    
}

/* Apply user movie preference settings (these are set from the Settings: iPhone Settings->Movie Player)
 for scaling mode, control style, background color, repeat mode, application audio session, background
 image and AirPlay mode. 
 */
-(void)applyUserSettingsToMoviePlayer
{
    //NSLog(@"_player.scalingMode = MPMovieScalingModeAspectFit;") ;
	_player.scalingMode = MPMovieScalingModeAspectFit;
	//_player.controlStyle = MPMovieControlStyleFullscreen;
	//_player.controlStyle = MPMovieControlStyleEmbedded ;
    _player.controlStyle = MPMovieControlStyleNone;
	_player.backgroundView.backgroundColor = [UIColor blackColor];
}

- (DRMMPMoviePlayerControllerCustom *)makeMoviePlayer {
    
    //動画ファイル名URLの生成
    NSURL* url=[NSURL URLWithString:strPathName];
	//NSLog(@"%@", strPathName);
    
	// ムービープレイヤーを生成する
	DRMMPMoviePlayerControllerCustom* player = [[DRMMPMoviePlayerControllerCustom alloc] initWithContentURL:url];
    
	[self applyUserSettingsToMoviePlayer];
	
	return player;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    NSLog(@"Player::didReceiveMemoryWarning") ;
}

#pragma mark - View lifecycle

//ボタンクリック時に呼ばれる
- (IBAction)clickButton:(UIButton*)sender
{
    //画面キャプチャー開始
    //NSLog(@"画面キャプチャー開始");
    [_player pause] ;
    _player.controlStyle = MPMovieControlStyleNone;
    
    UIImage *img = [_player thumbnailImageAtTime:[_player currentPlaybackTime] timeOption:MPMovieTimeOptionExact] ;
    
    SEL sel = @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(img, self, sel, nil); //完了通知が必要ない場合
    
    _player.controlStyle = MPMovieControlStyleFullscreen;	
}

// 保存完了を通知するメソッド
/*
- (void) savingImageIsFinished:(UIImage *)_image didFinishSavingWithError:(NSError *)_error contextInfo:(void *)_contextInfo{
    Facebook *fb = [Facebook alloc] ;
	if([fb check]){ 
		// 投稿する本文
		[fb sendCapture];
        [_player stop] ;
	} 
}
*/

- (void)timerFired:(NSTimer*)timer
{
    //NSLog(@"timerFired") ;
    
    NSTimeInterval currentTime = _player.currentPlaybackTime ;
    NSTimeInterval duration = [_player duration] ;
    if(!isDragging){
        if(duration > 0){
            CGFloat percentage = currentTime / duration ;
            CGRect frame = sliderImageView.frame ;
            //CGFloat x = currentSliderBackFrame.origin.x + (currentSliderBackFrame.size.width - sliderPointWidth) * percentage ;
            CGFloat x = currentSliderBackFrame.origin.x + (currentSliderBackFrame.size.width - sliderPointWidth) * percentage ;
            frame.origin.x = x ;
            frame.origin.y = currentSliderBackFrame.origin.y - 4 ;
            //NSLog(@"point x=%f y=%f",frame.origin.x,frame.origin.y) ;

            [sliderImageView setFrame:frame] ;
            NSInteger second = (int)currentTime ;
            NSInteger minute = second / 60 ;
            second = second % 60 ;
            NSString *timeString = [NSString stringWithFormat:@"%d:%02d",minute,second] ;
            if(timeString != nil){
                [currentTimeLabel setText:timeString] ;
            } else {
                //NSLog(@"timeString is nil") ;
            }
        }
    }
    
    if(annotationCount >= 1){
        NSString *annotationString = [movieAnnotations1 getAnnotationString:currentTime] ;
        if(annotationString != nil){
            //NSLog(@"%@",annotationString) ;
            NSString *annotation = [NSString stringWithFormat:@" %@ ",annotationString] ;
            if(annotation != nil){
                [annotationLabel1 setText:annotation] ;
            }
            
            /*
            static BOOL zoomDone = NO ;
            if(!zoomDone){
                zoomDone = YES ;
                _player.view.transform = CGAffineTransformMake(2.0, 0, 0, 2.0, -100, -100) ;
            }
             */
            
        }
    }
    
    if(annotationCount >= 2){
        NSString *annotationString = [movieAnnotations2 getAnnotationString:currentTime] ;
        if(annotationString != nil){
            //NSLog(@"%@",annotationString) ;
            NSString *annotation = [NSString stringWithFormat:@" %@ ",annotationString] ;
            if(annotation != nil){
                CGRect frame = [annotationLabel2 frame] ;
                frame.size = CGSizeMake(0, ANNOTATION_BOX2_HEIGHT);
                [annotationLabel2 setFrame:frame];
                [annotationLabel2 setText:annotation] ;
                [annotationLabel2 sizeToFit];
                frame = [annotationLabel2 frame] ;
                frame.size.height = ANNOTATION_BOX2_HEIGHT ;
                [annotationLabel2 setFrame:frame];
            }
        }
    }
}

- (void)setCostomButtonFrame: (CGRect) rect
{
    _btnRect = rect;
}

- (void)setCostomButtonText: (NSString*) str
{
    _btnText = str;
}

- (void)setCostomButtonURI: (NSString*) uri
{
    _btnURI = uri;
}

- (void)setCostomButtonImage: (UIImage*) img
{
    _btnImage = img;
}

-(CGRect)getMovieFrameForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect frame ;
    if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
        CGFloat movieHeight = deviceHeight * 9 / 16 ;
        frame = CGRectMake(0, (deviceWidth - movieHeight)/2, deviceHeight, movieHeight) ;
    } else {
        CGFloat movieHeight = deviceWidth * 9 / 16 ;
        frame = CGRectMake(0, 100 + (deviceHeight-480)/4 - statusBarHeight+[VeamUtil getViewTopOffset], deviceWidth, movieHeight) ;
    }
    
    return frame ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"viewDidLoad") ;
    
    [self setViewName:[NSString stringWithFormat:@"DownloadedVideoPlay/%@/%@/",contentId,videoTitleName]] ;
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
     */
    
    //CGRect frame ;
    UITapGestureRecognizer *singleTapGesture ;
    
    scrollViewFrame = CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]+[VeamUtil getViewTopOffset]) ;
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;
    scrollViewSize = CGSizeMake([VeamUtil getScreenWidth], [VeamUtil getScreenHeight]+1) ;
    [scrollView setContentSize:scrollViewSize] ;
    
    destructionDone = NO ;
    switching = NO ;
    timeOffset = 0 ;
    currentAngle = 1 ;
    isShowingController = YES ;
    controllerTimer = nil ;
    currentOrientation = UIInterfaceOrientationPortrait ;
    statusBarHeight = [VeamUtil getStatusBarHeight] ;
    
    if(annotationCount >= 1){
        //NSLog(@"set annotation 1 %@",contentId) ;
        movieAnnotations1 = [[MovieAnnotations alloc] initWithObjectId:contentId streamNo:1] ;
    }
    if(annotationCount >= 2){
        //NSLog(@"set annotation 2 %@",contentId) ;
        movieAnnotations2 = [[MovieAnnotations alloc] initWithObjectId:contentId streamNo:2] ;
    }
    
    deviceWidth = [VeamUtil getScreenWidth] ;
    deviceHeight = [VeamUtil getScreenHeight] ;
    
    CGFloat offsetY = (deviceHeight-480)/4 ;

	// デバイスのスクリーンサイズ(縦長)を取得する。
	//CGRect mainFrameBounds;
	CGRect movieFrame;
	
    movieFrame = [self getMovieFrameForOrientation:UIInterfaceOrientationPortrait] ;
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, movieFrame.origin.y + movieFrame.size.height + 12)] ;
    //[grayView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1]] ;
    //[grayView setBackgroundColor:[UIColor clearColor]] ;
    [grayView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:grayView] ;
    
	// DRM対応 Webサーバー開始
    wserver = [WebServer alloc];
    [wserver startServer];
    
    //ムービープレイヤーの生成
    //NSLog(@"_player = [self makeMoviePlayer];") ;
	_player = [self makeMoviePlayer];
//	_player.view.transform = CGAffineTransformMakeRotation(90*M_PI/180);
	[[_player view] setFrame:movieFrame];
	[_player view].backgroundColor = [UIColor blackColor];
    [scrollView addSubview:_player.view];
    
    
    bottomGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, movieFrame.origin.y + movieFrame.size.height + 12 + 15, deviceWidth, deviceHeight)] ;
    [bottomGrayView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:bottomGrayView] ;

    
    controllerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)] ;
    [controllerView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:controllerView] ;
    
    if(strPathName2 != nil){
        UIImage *zoomImage = [VeamUtil imageNamed:zoomFileName] ;
        zoomButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(movieFrame.origin.x + 5, movieFrame.origin.y + 5 , zoomImage.size.width/2, zoomImage.size.height/2)] ;
        [zoomButtonImageView setImage:zoomImage] ;
        [zoomButtonImageView setUserInteractionEnabled:YES] ;
        singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomButtonTapped:)];
        singleTapGesture.numberOfTouchesRequired = 1 ;
        [zoomButtonImageView addGestureRecognizer:singleTapGesture] ;
        [scrollView addSubview:zoomButtonImageView] ;
    }

    /*
    if(annotationCount >= 1){
        annotation1Frame = CGRectMake(10, movieFrame.origin.y+movieFrame.size.height-ANNOTATION_BOX1_HEIGHT/2, deviceWidth-20, ANNOTATION_BOX1_HEIGHT) ;
        annotationLabel1 = [[UILabel alloc]initWithFrame:annotation1Frame] ;
        annotationLabel1.text = @"" ;
        [annotationLabel1 setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]] ;
        [annotationLabel1 setTextColor:[UIColor whiteColor]] ;
        [annotationLabel1 setAdjustsFontSizeToFitWidth:YES] ;
        [annotationLabel1 setMinimumFontSize:7] ;
        [annotationLabel1 setFont:[UIFont systemFontOfSize:17]] ;
        [[annotationLabel1 layer] setCornerRadius:5.0];
        [annotationLabel1 setClipsToBounds:YES];
        [scrollView addSubview:annotationLabel1] ;
    }
    
    if(annotationCount >= 2){
        annotation2Frame = CGRectMake(annotation1Frame.origin.x, annotation1Frame.origin.y - ANNOTATION_BOX2_HEIGHT - 5, ANNOTATION_BOX2_HEIGHT, ANNOTATION_BOX2_HEIGHT) ;
        annotationLabel2 = [[UILabel alloc]initWithFrame:annotation2Frame] ;
        annotationLabel2.text = @"" ;
        [annotationLabel2 setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]] ;
        [annotationLabel2 setTextColor:[UIColor whiteColor]] ;
        [annotationLabel2 setFont:[UIFont boldSystemFontOfSize:30]] ;
        [annotationLabel2 setAdjustsFontSizeToFitWidth:NO] ;
        [annotationLabel2 setLineBreakMode:UILineBreakModeWordWrap];
        [annotationLabel2 setNumberOfLines:1];
        [[annotationLabel2 layer] setCornerRadius:5.0];
        [annotationLabel2 setClipsToBounds:YES];
        [scrollView addSubview:annotationLabel2] ;
    }
     */
    
    
	// スライダーを動かすためのタイマー
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                              target:self
                                            selector:@selector(timerFired:)
                                            userInfo:nil repeats:YES];
	//ムービー完了の通知
	[self installMovieNotificationObservers];
    
	//  DRM対応 即再生ではなく、再生準備完了通知を待つように修正
    //ムービーの再生
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6){ // iOS6ではオートスタートしない
        [_player prepareToPlay];
    }
    
    // スライダーのバック(プレーヤーのフレームの下から40のところ)
    UIImage *image = [VeamUtil imageNamed:@"p_slider_back.png"] ;
    sliderBackFrame.size.width = image.size.width / 2 ;
    sliderBackFrame.size.height = image.size.height / 2 ;
    sliderBackFrame.origin.x = (deviceWidth - sliderBackFrame.size.width) / 2 ;
    sliderBackFrame.origin.y = movieFrame.origin.y + movieFrame.size.height + 44 ;
    sliderBackImageView = [[UIImageView alloc]initWithFrame:sliderBackFrame] ;
    currentSliderBackFrame = sliderBackFrame ;
    [sliderBackImageView setImage:image] ;
    [controllerView addSubview:sliderBackImageView] ;
    
    // タイム表示
    currentTimeFrame.origin.x = 0 ;
    currentTimeFrame.origin.y = sliderBackFrame.origin.y + 1 ;
    currentTimeFrame.size.width = sliderBackFrame.origin.x ;
    currentTimeFrame.size.height = 14 ;
    currentTimeLabel = [[UILabel alloc]initWithFrame:currentTimeFrame] ;
    [currentTimeLabel setText:@"0:00"] ;
    //[currentTimeLabel setFont:[UIFont systemFontOfSize:12]] ;
    [currentTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
    [currentTimeLabel setBackgroundColor:[UIColor clearColor]] ;
    [currentTimeLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [currentTimeLabel setTextAlignment:NSTextAlignmentRight] ;
    [controllerView addSubview:currentTimeLabel] ;
    
    // デュレーション表示
    durationFrame.origin.x = sliderBackFrame.origin.x + sliderBackFrame.size.width + 1;
    durationFrame.origin.y = sliderBackFrame.origin.y + 1 ;
    durationFrame.size.width = deviceWidth - durationFrame.origin.x ;
    durationFrame.size.height = 14 ;
    durationLabel = [[UILabel alloc]initWithFrame:durationFrame] ;
    [durationLabel setText:@"0:00"] ;
    //[durationLabel setFont:[UIFont systemFontOfSize:12]] ;
    [durationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
    [durationLabel setBackgroundColor:[UIColor clearColor]] ;
    [durationLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [durationLabel setTextAlignment:NSTextAlignmentLeft] ;
    [controllerView addSubview:durationLabel] ;
    
    // スライダー
    image = [VeamUtil imageNamed:@"p_slider_point.png"] ;
    sliderPointFrame.size.width = image.size.width / 2 ;
    sliderPointFrame.size.height = image.size.height / 2 ;
    sliderPointFrame.origin.x = sliderBackFrame.origin.x ;
    sliderPointFrame.origin.y = sliderBackFrame.origin.y - 4 ;
    sliderImageView = [[UIImageView alloc]initWithFrame:sliderPointFrame] ;
    [sliderImageView setImage:image] ;
    [sliderImageView setUserInteractionEnabled:YES] ;
    UIPanGestureRecognizer *sliderDragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderDragged:)];
    [sliderImageView addGestureRecognizer:sliderDragGesture] ;
    
    sliderPointWidth = image.size.width / 2 ;
    sliderLimitLeft = currentSliderBackFrame.origin.x + sliderPointWidth / 2 ;
    sliderLimitRight = currentSliderBackFrame.origin.x + currentSliderBackFrame.size.width - sliderPointWidth / 2 ;
    //NSLog(@"left=%f right=%f",sliderLimitLeft,sliderLimitRight) ;
    
    [controllerView addSubview:sliderImageView] ;
    
    CGFloat titleY = [VeamUtil getTopBarHeight]+[VeamUtil getViewTopOffset] ;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleY, deviceWidth, movieFrame.origin.y-titleY)] ;
    [titleLabel setText:videoTitleName] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [scrollView addSubview:titleLabel] ;
    
   
    // 再生ボタン(プレーヤーのフレームの下から40のところ)
    image = [VeamUtil imageNamed:@"p_pause.png"] ;
    pauseFrame.size.width = image.size.width / 2 ;
    pauseFrame.size.height = image.size.height / 2 ;
    pauseFrame.origin.x = (deviceWidth - pauseFrame.size.width) / 2 ;
    pauseFrame.origin.y = movieFrame.origin.y + movieFrame.size.height + 84 ;
    pauseImageView = [[UIImageView alloc]initWithFrame:pauseFrame] ;
    [pauseImageView setImage:image] ;
    [pauseImageView setUserInteractionEnabled:YES] ;
    singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseButtonTapped:)];
    singleTapGesture.numberOfTouchesRequired = 1 ;
    [pauseImageView addGestureRecognizer:singleTapGesture] ;
    [controllerView addSubview:pauseImageView] ;
    
    // 10秒戻るボタン
    image = [VeamUtil imageNamed:@"p_prev.png"] ;
    //NSLog(@"button size %f %f  y %f %f",pauseFrame.size.height,image.size.height/2,pauseFrame.origin.y,pauseFrame.origin.y + (pauseFrame.size.height-image.size.height/2)/2) ;
    UIImageView *prevImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pauseFrame.origin.x-image.size.width/2, pauseFrame.origin.y + (pauseFrame.size.height-image.size.height/2)/2, image.size.width/2, image.size.height/2)] ;
    [prevImageView setImage:image] ;
    [prevImageView setUserInteractionEnabled:YES] ;
    singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prevButtonTapped:)];
    singleTapGesture.numberOfTouchesRequired = 1 ;
    [prevImageView addGestureRecognizer:singleTapGesture] ;
    [scrollView addSubview:prevImageView] ;
    
    // 10秒進むボタン
    image = [VeamUtil imageNamed:@"p_next.png"] ;
    UIImageView *nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pauseFrame.origin.x+pauseFrame.size.width, pauseFrame.origin.y + (pauseFrame.size.height-image.size.height/2)/2, image.size.width/2, image.size.height/2)] ;
    [nextImageView setImage:image] ;
    [nextImageView setUserInteractionEnabled:YES] ;
    singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonTapped:)];
    singleTapGesture.numberOfTouchesRequired = 1 ;
    [nextImageView addGestureRecognizer:singleTapGesture] ;
    [scrollView addSubview:nextImageView] ;
    
    

    // Info view
    CGFloat iconSize = 40 ;
    CGFloat iconMargin = 10 ;
    CGFloat margin = 10 + [VeamUtil getStatusBarHeight] - [VeamUtil getViewTopOffset];

    likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconMargin, deviceHeight-iconSize-margin, iconSize, iconSize)] ;
    [likeImageView setImage:[VeamUtil imageNamed:@"forum_like_button_off.png"]] ;
    [VeamUtil registerTapAction:likeImageView target:self selector:@selector(onLikeButtonTap:)] ;
    [scrollView addSubview:likeImageView] ;
    
    commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconMargin*2+iconSize, deviceHeight-iconSize-margin, iconSize, iconSize)] ;
    [commentImageView setImage:[VeamUtil imageNamed:@"forum_comment_button.png"]] ;
    [VeamUtil registerTapAction:commentImageView target:self selector:@selector(onCommentButtonTap:)] ;
    [scrollView addSubview:commentImageView] ;
    
    
    
    
    image = [VeamUtil imageNamed:@"program_like.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    CGFloat infoY = deviceHeight-imageHeight-13-[VeamUtil getStatusBarHeight] + [VeamUtil getViewTopOffset] ;
    heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(deviceWidth, infoY, imageWidth, imageHeight)] ;
    [heartImageView setImage:image] ;
    [scrollView addSubview:heartImageView] ;
    
    likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(deviceWidth, infoY, 22, imageHeight)] ;
    [likesLabel setText:@"-"] ;
    [likesLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]] ;
    [likesLabel setBackgroundColor:[UIColor clearColor]] ;
    [likesLabel setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [scrollView addSubview:likesLabel] ;
    
    image = [VeamUtil imageNamed:@"program_comment.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    commentNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(deviceWidth, infoY, imageWidth, imageHeight)] ;
    [commentNumImageView setImage:image] ;
    [scrollView addSubview:commentNumImageView] ;
    
    commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(deviceWidth, infoY, 22, imageHeight)] ;
    [commentNumLabel setText:@"-"] ;
    [commentNumLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]] ;
    [commentNumLabel setBackgroundColor:[UIColor clearColor]] ;
    [commentNumLabel setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [scrollView addSubview:commentNumLabel] ;
    
    image = [VeamUtil imageNamed:@"expand_comment.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    expandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(deviceWidth, infoY, imageWidth, imageHeight)] ;
    [expandImageView setImage:image] ;
    [VeamUtil registerTapAction:expandImageView target:self selector:@selector(expandCommentTapped)] ;
    [scrollView addSubview:expandImageView] ;
    
    [self adjustInfoLayout] ;
    
    offsetY = deviceHeight-[VeamUtil getStatusBarHeight]+[VeamUtil getViewTopOffset] ;
    
    commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, 36)] ;
    [commentBackView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView addSubview:commentBackView] ;
    
    UIImageView *commentMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 16)] ;
    [commentMarkImageView setImage:[VeamUtil imageNamed:@"forum_comment.png"]] ;
    [commentBackView addSubview:commentMarkImageView] ;
    
    [self setScrollContentSize:offsetY] ;
    
    appearFlag = NO ;
    preventVeamIcon = YES ;
    [self addTopBar:YES showSettingsButton:NO] ;
    
    ttNavigator = [TTNavigator navigator] ;
    ttNavigator.delegate = self ;
    

    
    
    
    tapDetectorView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, 1, 1)] ;
    [tapDetectorView setBackgroundColor:[UIColor clearColor]] ;
    //[VeamUtil registerTapAction:tapDetectorView target:self selector:@selector(didTapPlayer)] ;
    [self.view addSubview:tapDetectorView] ;
    
}

- (void)setScrollContentSize:(CGFloat)height
{
    CGFloat contentHeight = height ;
    if(contentHeight <= scrollView.frame.size.height){
        contentHeight = scrollView.frame.size.height + 1 ;
    }
    scrollViewSize = CGSizeMake([VeamUtil getScreenWidth], contentHeight) ;
    [scrollView setContentSize:scrollViewSize] ;
    if(bottomGrayView != nil){
        CGRect frame = bottomGrayView.frame ;
        frame.size.height = contentHeight - frame.origin.y ;
        [bottomGrayView setFrame:frame] ;
    }
}

- (void)adjustInfoLayout
{
    //NSLog(@"adjustInfoLayout") ;
    CGFloat infoX = [VeamUtil getScreenWidth] - 7 ;
    CGFloat height = 0 ;
    
    CGRect frame = expandImageView.frame ;
    height = frame.size.height ;
    infoX -= frame.size.width ;
    frame.origin.x = infoX ;
    [expandImageView setFrame:frame] ;
    //NSLog(@"expand x : %f",infoX) ;
    
    
    infoX -= 3 ; // margin
    
    [commentNumLabel sizeToFit] ;
    frame = commentNumLabel.frame ;
    infoX -= frame.size.width ;
    frame.origin.x = infoX ;
    frame.size.height = height ;
    [commentNumLabel setFrame:frame] ;
    
    infoX -= 5 ; // margin
    
    frame = commentNumImageView.frame ;
    infoX -= frame.size.width ;
    frame.origin.x = infoX ;
    [commentNumImageView setFrame:frame] ;
    
    infoX -= 10 ; // margin
    
    [likesLabel sizeToFit] ;
    frame = likesLabel.frame ;
    infoX -= frame.size.width ;
    frame.origin.x = infoX ;
    frame.size.height = height ;
    [likesLabel setFrame:frame] ;
    
    //NSLog(@"likelabel x=%f height=%f",infoX,height) ;
    
    infoX -= 5 ; // margin
    
    frame = heartImageView.frame ;
    infoX -= frame.size.width ;
    frame.origin.x = infoX ;
    [heartImageView setFrame:frame] ;
    
}


-(void) pauseButtonTapped:(UITapGestureRecognizer *)sender
{
    //NSLog(@"pauseButtonTapped") ;
    if([_player playbackState] == MPMoviePlaybackStatePlaying){
        manuallyPaused = YES ;
        [_player pause] ;
    } else {
        [_player play] ;
    }
}

-(void) nextButtonTapped:(UITapGestureRecognizer *)sender
{
    //NSLog(@"nextButtonTapped") ;
    MPMoviePlaybackState state = [_player playbackState] ;
    if((state == MPMoviePlaybackStatePlaying) || (state == MPMoviePlaybackStatePaused)){
        NSTimeInterval currentTime = [_player currentPlaybackTime] ;
        currentTime += 10 ;
        if(currentTime > [_player duration]){
            currentTime = [_player duration] ;
        }
        [_player setCurrentPlaybackTime:currentTime] ;
    }
}

-(void) prevButtonTapped:(UITapGestureRecognizer *)sender
{
    //NSLog(@"prevButtonTapped") ;
    MPMoviePlaybackState state = [_player playbackState] ;
    if((state == MPMoviePlaybackStatePlaying) || (state == MPMoviePlaybackStatePaused)){
        NSTimeInterval currentTime = [_player currentPlaybackTime] ;
        currentTime -= 10 ;
        if(currentTime < 0){
            currentTime = 0 ;
        }
        [_player setCurrentPlaybackTime:currentTime] ;
    }
}



-(void) zoomButtonTapped:(UITapGestureRecognizer *)sender
{
    //NSLog(@"zoomButtonTapped") ;
    
    if([_player playbackState] != MPMoviePlaybackStateStopped){
        switching = YES ;
        timeOffset = _player.currentPlaybackTime ;
        //NSLog(@"current = %f",timeOffset) ;
        [_player stop] ;
    }
}

-(void) backButtonTapped:(UITapGestureRecognizer *)sender
{
    //NSLog(@"backButtonTapped") ;
    
    if([_player playbackState] != MPMoviePlaybackStateStopped){
        [_player stop] ;
    }
}

/*
-(void) linkButtonTapped:(UITapGestureRecognizer *)sender
{
    //NSLog(@"linkButtonTapped") ;
    
    [VeamUtil setLinkUrl:linkUrl] ;
    
    if([_player playbackState] != MPMoviePlaybackStateStopped){
        [_player stop] ;
    }
}
*/

// override
- (void)onBackButtonTap
{
    if([_player playbackState] != MPMoviePlaybackStateStopped){
        [_player stop] ;
    }
}



/*
- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"viewDidAppear") ;
    [super viewDidAppear:animated] ;
    //[VEAMUtil trackPageView:0 pageName:[NSString stringWithFormat:@"Playback/%@/%@/%@",titleName,contentId,contentId2]] ;
    //[[AppDelegate sharedInstance] hideTabBar] ;
}
*/

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"DRMMovieViewController::viewDidAppear") ;
    [super viewDidAppear:animated] ;
    forcePlay = NO ;
    [self performSelectorInBackground:@selector(reloadData) withObject:nil] ;
    
    /*
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents] ;
    [self becomeFirstResponder];
     */
}



//ムービー完了時に呼ばれる
- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    //NSLog(@"moviePlayBackDidFinish") ;
    
    if(switching){
        [wserver stopServer];
        wserver = nil ;
        
        NSURL *url ;
        if(currentAngle == 1){
            url=[NSURL URLWithString:strPathName2];
            [[AppDelegate sharedInstance] setMovieKey:movieKey2] ;
            currentAngle = 2 ;
            [zoomButtonImageView setImage:[VeamUtil imageNamed:zoomFileName2]] ;
        } else {
            url=[NSURL URLWithString:strPathName];
            [[AppDelegate sharedInstance] setMovieKey:movieKey] ;
            currentAngle = 1 ;
            [zoomButtonImageView setImage:[VeamUtil imageNamed:zoomFileName]] ;
        }
        
        wserver = [WebServer alloc];
        [wserver startServer];
        [_player setContentURL:url] ;
        [_player prepareToPlay];
        switching = NO ;
        return ;
    }
    
    //[[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if([_player playbackState] != MPMoviePlaybackStateStopped){
        [_player stop] ;
    }
    [wserver stopServer];
    wserver = nil ;
    // _player = nil ;
    
    NSDictionary* userInfo=[notification userInfo];
    int reason=[[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue];
    
    if (reason==MPMovieFinishReasonPlaybackError) {
    }


    [VeamUtil showTabBarController:-1] ;
    //[self.navigationController popViewControllerAnimated:YES] ;
    /*
    if(self.detailItem == nil){
        [[AppDelegate sharedInstance] switchToMainNavigationController] ;
        //[self.navigationController popViewControllerAnimated:NO] ;
    } else {
        contentViewController = [[FeaturedContentViewController alloc] initWithNibName:@"FeaturedContentViewController" bundle:nil] ;
        contentViewController.detailItem = self.detailItem ;    
        [self.navigationController pushViewController:contentViewController animated:YES];
    }
     */
    
    /*
     //ムービー完了原因の取得
     NSDictionary* userInfo=[notification userInfo];
     int reason=[[userInfo objectForKey:
     @"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue];
     if (reason==MPMovieFinishReasonPlaybackEnded) {
     //NSLog(@"再生終了");
     // DRM対応 Webサーバー停止
     [wserver stopServer];
     
     // ビューを復帰する
     [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
     [self.navigationController popViewControllerAnimated:YES];    
     }
     else if (reason==MPMovieFinishReasonPlaybackError) {
     //NSLog(@"エラー");
     }
     else if (reason==MPMovieFinishReasonUserExited) {
     //NSLog(@"フルスクリーン用UIのDoneボタンで終了");
     // DRM対応 Webサーバー停止
     [wserver stopServer];
     
     // ビューを復帰する
     [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
     [self.navigationController popViewControllerAnimated:YES];    
     }
     */
}

// DRM対応 再生準備完了通知
- (void)finishPreload:(NSNotification *)aNotification {
    
    //NSLog(@"finishPreload") ;
    
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:player];
    
	// 準備が完了したので再生する
    [player play];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/* Sent to the view controller after the user interface rotates. */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	/* Size movie view to fit parent view. */
	//[[_player view] setFrame:[self.view bounds]];
    
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"shouldAutorotate") ;
    return YES ;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"supportedInterfaceOrientations") ;
    return UIInterfaceOrientationMaskAllButUpsideDown ;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /* Return YES for supported orientations. */
    //NSLog(@"shouldAutorotateToInterfaceOrientation") ;
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);

    return NO;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //NSLog(@"willRotateToInterfaceOrientation") ;
    [self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation
{
    
    //NSLog(@"adjustViewsForOrientation") ;
    
    currentOrientation = orientation ;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [tapDetectorView setFrame:CGRectMake(0, 0, deviceHeight, deviceWidth)] ;
        [scrollView setFrame:CGRectMake(0, 0, deviceHeight, deviceWidth)] ;
        [scrollView setContentSize:CGSizeMake(deviceHeight, deviceWidth)] ;
        
        if(statusBarBackView != nil){
            [statusBarBackView setHidden:YES] ;
        }
        [backgroundImageView setHidden:YES] ;
        [titleLabel setHidden:YES] ;
        [grayView setHidden:YES] ;
        CGRect movieFrame = [self getMovieFrameForOrientation:orientation] ;
        [[_player view] setFrame:movieFrame ];
        
        // 95 from bottom
        CGRect frame ;
        frame.origin.x = 10 ;
        frame.origin.y = deviceWidth - 95 ;
        frame.size.width = deviceHeight - 10 - 60 ;
        frame.size.height = 42 ;
        [annotationLabel1 setFrame:frame] ;
        
        frame.origin.y -= 55 ;
        frame.size.width = 1 ;
        [annotationLabel2 setFrame:frame] ;
        
        frame = zoomButtonImageView.frame ;
        frame.origin.y = 30 ;
        [zoomButtonImageView setFrame:frame] ;
        
        frame.origin.x = deviceHeight - 46 ;
        frame.origin.y = movieFrame.origin.y + 10 ;
        frame.size.width = 30 ;
        frame.size.height = 120 ;
        
        [annotationLabel1 setFont:[UIFont systemFontOfSize:20]] ;
        
        CGFloat margin = 4.0 ;
        CGFloat controllerHeight = 44 ;
        CGFloat x = margin ;
        [controllerView setBackgroundColor:[UIColor blackColor]] ;
        [controllerView setFrame:CGRectMake(0, deviceWidth-controllerHeight-[VeamUtil getStatusBarHeight], deviceHeight, controllerHeight)] ;
        [pauseImageView setFrame:CGRectMake(x, margin, controllerHeight-margin, controllerHeight-margin)] ;
        x += controllerHeight - margin ;
        frame = [currentTimeLabel frame] ;
        frame.origin.x = x ;
        frame.origin.y = (controllerHeight - frame.size.height) / 2 ;
        [currentTimeLabel setFrame:frame] ;
        [currentTimeLabel setTextColor:[UIColor whiteColor]] ;
        x += frame.size.width + margin ;
        
        frame = [sliderBackImageView frame] ;
        frame.origin.x = x ;
        frame.origin.y = (controllerHeight - frame.size.height) / 2 ;
        frame.size.width = deviceHeight - x - durationFrame.size.width - margin ;
        [sliderBackImageView setFrame:frame] ;
        currentSliderBackFrame = frame ;
        x += frame.size.width + margin ;
        
        frame = [durationLabel frame] ;
        frame.origin.x = x ;
        frame.origin.y = (controllerHeight - frame.size.height) / 2 ;
        [durationLabel setFrame:frame] ;
        
        [currentTimeLabel setTextColor:[UIColor whiteColor]] ;
        [durationLabel setTextColor:[UIColor whiteColor]] ;
        
        sliderLimitLeft = currentSliderBackFrame.origin.x + sliderPointWidth / 2 ;
        sliderLimitRight = currentSliderBackFrame.origin.x + currentSliderBackFrame.size.width - sliderPointWidth / 2 ;
        
        if(linkImageView != nil){
            CGFloat imageWidth = linkLongImage.size.width / 2 ;
            CGFloat imageHeight = linkLongImage.size.height / 2 ;
            CGRect linkFrame = CGRectMake(movieFrame.origin.x+movieFrame.size.width-imageWidth, movieFrame.origin.y+movieFrame.size.height-imageHeight-linkLongMargin-controllerHeight, imageWidth, imageHeight) ;
            [linkImageView setFrame:linkFrame] ;
            [linkLabel setFrame:CGRectMake(37.5, 0, imageWidth-37.5, imageHeight)] ;
            [linkImageView setImage:linkLongImage] ;
            [linkLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]] ;
        }
        

        
        [topBarView setAlpha:0.0] ;
        [topBarLabel setAlpha:0.0] ;
        [topBarBackImageView setAlpha:0.0] ;

        [self setControllerHidden:YES autoHidden:NO] ;
        
        //titleImageView.center = CGPointMake(235.0f, 42.0f);
        //subtitleImageView.center = CGPointMake(355.0f, 70.0f);
        //...
    } else if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [tapDetectorView setFrame:CGRectMake(-1, -1, 1, 1)] ;
        [scrollView setFrame:scrollViewFrame] ;
        [scrollView setContentSize:scrollViewSize] ;
        if(statusBarBackView != nil){
            [statusBarBackView setHidden:NO] ;
        }
        [backgroundImageView setHidden:NO] ;
        [titleLabel setHidden:NO] ;
        [grayView setHidden:NO] ;
        CGRect movieFrame = [self getMovieFrameForOrientation:orientation] ;
        [[_player view] setFrame:movieFrame ];
        
        
        if(linkImageView != nil){
            CGFloat imageWidth = linkShortImage.size.width / 2 ;
            CGFloat imageHeight = linkShortImage.size.height / 2 ;
            CGRect linkFrame = CGRectMake(movieFrame.origin.x+movieFrame.size.width-imageWidth, movieFrame.origin.y+movieFrame.size.height-imageHeight-linkShortMargin, imageWidth, imageHeight) ;
            [linkImageView setFrame:linkFrame] ;
            [linkLabel setFrame:CGRectMake(33, 0, imageWidth-33, imageHeight)] ;
            [linkImageView setImage:linkShortImage] ;
            [linkLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]] ;
        }

        // 95 from bottom
        [annotationLabel1 setFrame:annotation1Frame] ;
        [annotationLabel2 setFrame:annotation2Frame] ;
        
        CGRect frame = zoomButtonImageView.frame ;
        frame.origin.y = movieFrame.origin.y + 5 ;
        [zoomButtonImageView setFrame:frame] ;
        
        
        [annotationLabel1 setFont:[UIFont systemFontOfSize:17]] ;
        
        [controllerView setBackgroundColor:[UIColor clearColor]] ;
        [controllerView setFrame:CGRectMake(0,0, deviceWidth, deviceHeight)] ;
        [pauseImageView setFrame:pauseFrame] ;
        [currentTimeLabel setFrame:currentTimeFrame] ;
        [sliderBackImageView setFrame:sliderBackFrame] ;
        [durationLabel setFrame:durationFrame] ;
        
        [currentTimeLabel setTextColor:[VeamUtil getBaseTextColor]] ;
        [durationLabel setTextColor:[VeamUtil getBaseTextColor]] ;

        currentSliderBackFrame = sliderBackFrame ;
        sliderLimitLeft = currentSliderBackFrame.origin.x + sliderPointWidth / 2 ;
        sliderLimitRight = currentSliderBackFrame.origin.x + currentSliderBackFrame.size.width - sliderPointWidth / 2 ;
        
        [topBarView setAlpha:1.0] ;
        [topBarLabel setAlpha:1.0] ;
        [topBarBackImageView setAlpha:1.0] ;

        [self setControllerHidden:NO autoHidden:NO] ;
    }
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}


/* Notifies the view controller that its view is about to be become visible. */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSLog(@"viewWillappear") ;
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent] ;

	[self applyUserSettingsToMoviePlayer];
    isPostViewShown = NO ;
}

/* Remove the movie view from the view hierarchy. */
-(void)removeMovieViewFromViewHierarchy
{
	[_player.view removeFromSuperview];
}


/* Delete the movie player object, and remove the movie notification observers. */
-(void)deletePlayerAndNotificationObservers
{
    //NSLog(@"deletePlayerAndNotificationObservers") ;
    [self removeMovieNotificationHandlers];
    _player = nil;
}

/* Notifies the view controller that its view is about to be dismissed, 
 covered, or otherwise hidden from view. */
- (void)viewWillDisappear:(BOOL)animated
{
    
    //NSLog(@"player willDisappear") ;
    
    [super viewWillDisappear:animated];
    
    if(!isPostViewShown){
        //NSLog(@"destruction") ;
        if(!destructionDone){
            if([_player playbackState] != MPMoviePlaybackStateStopped){
                [_player stop] ;
            }
            
            /* Remove the movie view from the current view hierarchy. */
            [self removeMovieViewFromViewHierarchy];
            /* Delete the movie player object and remove the notification observers. */
            [self deletePlayerAndNotificationObservers];
            
            if(_timer != nil){
                [_timer invalidate] ;
                _timer = nil ;
            }
            
            if(controllerTimer != nil){
                [controllerTimer invalidate] ;
                controllerTimer = nil ;
            }
            
            destructionDone = YES ;
        }
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    /*
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
     */
}

-(void)moviePlayBackStateChanged
{
    //NSLog(@"state changed to %d",_player.playbackState) ;
    if(_player.playbackState == MPMoviePlaybackStatePlaying){
        manuallyPaused = NO ;
        if(timeOffset > 0){
            [_player setCurrentPlaybackTime:timeOffset] ;
            timeOffset = 0 ; 
        }
        UIImage *image = [VeamUtil imageNamed:@"p_pause.png"] ;
        [pauseImageView setImage:image] ;
        NSInteger second = (int)[_player duration] ;
        NSInteger minute = second / 60 ;
        second = second % 60 ;
        [durationLabel setText:[NSString stringWithFormat:@"%d:%02d",minute,second]] ;

    } else if(_player.playbackState == MPMoviePlaybackStatePaused){
        UIImage *image = [VeamUtil imageNamed:@"p_play.png"] ;
        [pauseImageView setImage:image] ;
        
        if(forcePlay && !manuallyPaused){
            [_player play] ;
        }
    }
}


- (void)sliderDragged:(UIPanGestureRecognizer *)sender
{
    [scrollView bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:scrollView];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        isDragging = YES ;
    }
    
    CGFloat destinationX = firstX+translatedPoint.x ;
    if((sliderLimitLeft < destinationX) && (destinationX < sliderLimitRight)){
        translatedPoint = CGPointMake(destinationX, firstY);
        [[sender view] setCenter:translatedPoint];
        
        //CGFloat percentage = (destinationX - sliderLimitLeft) / (sliderLimitRight - sliderLimitLeft) ;
        //NSInteger destinationTimeInt = [_player duration] * percentage ;
        //NSLog(@"destinationTime = %d",destinationTimeInt) ;
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        //NSLog(@"drag end") ;
        NSTimeInterval destinationTime ;
        if(destinationX <= sliderLimitLeft){
            destinationTime = 0.0 ;
        } else if(sliderLimitRight <= destinationX){
            destinationTime = [_player duration] ;
        } else {
            CGFloat percentage = (destinationX - sliderLimitLeft) / (sliderLimitRight - sliderLimitLeft) ;
            destinationTime = [_player duration] * percentage ;
        }
        [_player setCurrentPlaybackTime:destinationTime] ;
        
        isDragging = NO ;
    }
}

-(void)controllerTimerFired
{
    [self setControllerHidden:YES autoHidden:NO] ;
}

-(void)setControllerHidden:(BOOL)hidden autoHidden:(BOOL)autoHidden
{
    isShowingController = !hidden ;
    if(controllerTimer != nil){
        [controllerTimer invalidate] ;
        controllerTimer = nil ;
    }
    if(hidden){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [controllerView setAlpha:0.0] ;
        if(linkImageView != nil){
            [linkImageView setAlpha:0.0] ;
        }
        [UIView commitAnimations];
        
        CGRect frame = tapDetectorView.frame ;
        frame.size.height = deviceWidth ;
        [tapDetectorView setFrame:frame] ;
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [controllerView setAlpha:1.0] ;
        if(linkImageView != nil){
            [linkImageView setAlpha:1.0] ;
        }
        [UIView commitAnimations];
        if(autoHidden){
            controllerTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(controllerTimerFired) userInfo:nil repeats:NO] ;
        }
        
        CGRect frame = tapDetectorView.frame ;
        frame.size.height = deviceWidth - controllerView.frame.size.height ;
        [tapDetectorView setFrame:frame] ;
    }
}

-(void)didTapPlayer
{
    //NSLog(@"didTapPlayer") ;
    
    if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight) {
        //NSLog(@"player tapped") ;
        if(isShowingController){
            [self setControllerHidden:YES autoHidden:NO] ;
        } else {
            [self setControllerHidden:NO autoHidden:YES] ;
        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesBegan %d",[touches count]) ;

    if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight) {
        UITouch *touch = [touches anyObject];
        if(
           (touch.view != pauseImageView) &&
           (touch.view != sliderImageView) &&
           (touch.view != zoomButtonImageView) &&
           (touch.view != controllerView)
          ){
            //NSLog(@"player tapped") ;
            if(isShowingController){
                [self setControllerHidden:YES autoHidden:NO] ;
            } else {
                [self setControllerHidden:NO autoHidden:YES] ;
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesEnd") ;
    //UITouch *touch = [touches anyObject];
}




- (void)expandCommentTapped
{
    CGFloat contentHeight = scrollView.contentSize.height ;
    //CGFloat deviceHeight = [VeamUtil getScreenHeight] ;
    CGFloat destinationY = deviceHeight ;
    if(contentHeight < (deviceHeight * 2)){
        destinationY = contentHeight - deviceHeight ;
    }
    
    [scrollView setContentOffset:CGPointMake(0, destinationY) animated:YES] ;
}

- (void)onLikeButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onLikeButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    
    if(isLikeSending){
        return ;
    }
    
    if(video != nil){
        // 押されたらとりあえず変更する
        UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
        if([videoData isLike]){
            [imageView setImage:[VeamUtil imageNamed:@"forum_like_button_off.png"]] ;
        } else {
            [imageView setImage:[VeamUtil imageNamed:@"forum_like_button_on.png"]] ;
        }
        
        [self operateLikeButton:tag] ;
    }
}

- (void)operateLikeButton:(NSInteger)tag
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_LIKE ;
        pendingTag = tag ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        if([VeamUtil isConnected]){
            //NSLog(@"call likeCurrentPicture") ;
            [self performSelectorInBackground:@selector(likeCurrentVideo) withObject:nil] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    }
}

- (void)pauseIfNot
{
    if([_player playbackState] == MPMoviePlaybackStatePlaying){
        [_player pause] ;
    }
}

- (void)onCommentButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    [self pauseIfNot] ;
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onCommentButtonTap tag=%d",tag) ;
    [self operateCommentButton:tag] ;
}

- (void)doPendingCommentButton
{
    [self operateCommentButton:pendingTag] ;
}

- (void)operateCommentButton:(NSInteger)tag
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_COMMENT ;
        pendingTag = tag ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        [self performSelectorOnMainThread:@selector(showPostCommentView) withObject:nil waitUntilDone:NO] ;
    }
}

- (void)showPostCommentView
{
    isPostViewShown = YES ;
    PostVideoCommentViewController *postVideoCommentViewController = [[PostVideoCommentViewController alloc] init] ;
    [postVideoCommentViewController setVideoId:[video videoId]] ;
    [postVideoCommentViewController setTitleName:NSLocalizedString(@"comment",nil)] ;
    [self.navigationController pushViewController:postVideoCommentViewController animated:YES] ;
}

- (void)doPendingOperation
{
    if(pendingOperation == VEAM_PENDING_OPERATION_LIKE){
        pendingOperation = 0 ;
        [self operateLikeButton:pendingTag] ;
    } else if(pendingOperation == VEAM_PENDING_OPERATION_COMMENT){
        pendingOperation = 0 ;
        [self performSelectorOnMainThread:@selector(doPendingCommentButton) withObject:nil waitUntilDone:NO] ;
        //[self operateCommentButton:pendingTag] ;
    }
}

- (void)failedToLogin
{
}


- (void)likeCurrentVideo
{
    @autoreleasepool
    {
        isLikeSending = YES ;
        //NSLog(@"likeCurrentPicture") ;
        NSInteger likeValue = 1 ;
        if(isLike){
            likeValue = 0 ;
        }
        
        NSInteger socialUserid = [VeamUtil getSocialUserId] ;
        NSString *videoId = [video videoId] ;
        
        NSURL *url = [VeamUtil getApiUrl:@"video/like"] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d_%d_%@",likeValue,socialUserid,videoId]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&v=%@&sid=%d&l=%d&s=%@",[url absoluteString],videoId,socialUserid,likeValue,signature] ;
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"like url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSArray *results = [resultString componentsSeparatedByString:@"\n"];
            ////NSLog(@"count=%d",[results count]) ;
            if([results count] >= 1){
                if([[results objectAtIndex:0] isEqualToString:@"OK"]){
                    if([VeamUtil isSubscriptionFree] && (likeValue == 1)){
                        //[VeamUtil kickKiip:@"VideoLike"] ;
                    }
                    /*
                     [picture setIsLike:!isLike] ;
                     NSInteger numberOfLikes = [picture numberOfLikes] ;
                     if(isLike){
                     numberOfLikes-- ;
                     } else {
                     numberOfLikes++ ;
                     }
                     [picture setNumberOfLikes:numberOfLikes] ;
                     */
                }
            }
        } else {
            //NSLog(@"error=%@",error_str) ;
        }
        //NSLog(@"likeCurrentVideo end") ;
        [self performSelectorInBackground:@selector(reloadData) withObject:nil] ;
        isLikeSending = NO ;
    }
}

- (void)updateView
{
    //NSLog(@"updateView") ;
    if(videoData != nil){
        if(commentLabel != nil){
            [commentLabel removeFromSuperview] ;
            commentLabel = nil ;
        }
        
        commentLabel = [self getCommentLabel] ;
        [commentBackView addSubview:commentLabel] ;
        CGRect commentBackFrame = [commentBackView frame] ;
        CGFloat height = commentLabel.frame.size.height + 20 ;
        if(height < 36){
            height = 36 ;
        }
        commentBackFrame.size.height = height + 30 ;
        [commentBackView setFrame:commentBackFrame] ;
        
        //NSLog(@"number of likes = %d   number of comments = %d",[videoData numberOfLikes],[videoData getNumberOfComments]) ;
        [likesLabel setText:[NSString stringWithFormat:@"%d",[videoData numberOfLikes]]] ;
        [commentNumLabel setText:[NSString stringWithFormat:@"%d",[videoData getNumberOfComments]]] ;
        
        [self setScrollContentSize:commentBackFrame.origin.y+commentBackFrame.size.height] ;
        
        if([videoData isLike]){
            [likeImageView setImage:[VeamUtil imageNamed:@"forum_like_button_on.png"]] ;
        } else {
            [likeImageView setImage:[VeamUtil imageNamed:@"forum_like_button_off.png"]] ;
        }
        
        [self adjustInfoLayout] ;
    }
}

- (void)reloadData
{
    @autoreleasepool
    {
        //NSLog(@"update video data start") ;
        isUpdating = YES ;
        NSString *videoId = [video videoId] ;
        NSInteger socialUserId = [VeamUtil getSocialUserId] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d_%@",socialUserId,videoId]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&v=%@&sid=%d&s=%@",[VeamUtil getApiUrl:@"video/getinfo"],[video videoId],socialUserId,signature] ;
        NSURL *url = [NSURL URLWithString:urlString] ;
        //NSLog(@"programdata url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            VideoData *workVideoData = [[VideoData alloc] init] ;
            [workVideoData parseWithData:data] ;
            videoData = workVideoData ;
            isLike = [videoData isLike] ;
        } else {
            //NSLog(@"error=%@",error_str) ;
        }
        isUpdating = NO ;
        //NSLog(@"update video data end") ;
    }
    if(videoData != nil){
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO] ;
    }
}

- (TTStyledTextLabel *)getCommentLabel
{
    TTStyledTextLabel *label = nil ;
    if(videoData != nil){
        NSArray *comments = [videoData comments] ;
        NSInteger count = [comments count] ;
        NSString *htmlString = @"" ;
        
        NSInteger limit = VEAM_DEFAULT_COMMENT_COUNT ;
        if(showAllComments){
            limit = 999999 ;
        }
        
        for(int commentIndex = 0 ; (commentIndex < count) && (commentIndex < limit) ; commentIndex++){
            VideoComment *comment = [comments objectAtIndex:commentIndex] ;
            htmlString = [htmlString stringByAppendingFormat:@"<span class=\"commentUserName:\">%@</span> ",[comment ownerName]] ;
            htmlString = [htmlString stringByAppendingFormat:@"<span class=\"commentText:\">%@</span><br />",[comment comment]] ;
        }
        
        if(limit < count){
            //htmlString = [htmlString stringByAppendingFormat:@"<br /><span class=\"viewAllComments\">view all %d comments</span><br />",count] ;
            NSString *viewString = [NSString stringWithFormat:NSLocalizedString(@"view_all_comments",nil),count] ;
            htmlString = [htmlString stringByAppendingFormat:@"<br /><a href=\"%@://veam/\" class=\"viewAllComments:\">%@</a><br />",VEAM_VIEW_COMMENT_SCHEMA,viewString] ;
        } else if(count > 3){
            htmlString = [htmlString stringByAppendingFormat:@"<br /><a href=\"%@://veam/\" class=\"viewAllComments:\">%@</a><br />",VEAM_CLOSE_COMMENT_SCHEMA,NSLocalizedString(@"close_all_comments",nil)] ;
        }
        
        CGRect frame = CGRectMake(36, 10, 274, 1) ;
        label = [[TTStyledTextLabel alloc] initWithFrame:frame] ;
        label.text = [TTStyledText textFromXHTML:htmlString lineBreaks:NO URLs:YES];
        label.font = [UIFont systemFontOfSize:14] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label sizeToFit];
    }
    return label ;
}

- (BOOL)navigator: (TTBaseNavigator *)navigator shouldOpenURL:(NSURL *)url
{
    //NSLog(@"url=%@ scheme=%@ host=%@",[url absoluteString],[url scheme],[url host]) ;
    
    NSString *schema = [url scheme] ;
    if([schema isEqualToString:VEAM_VIEW_COMMENT_SCHEMA]){
        showAllComments = YES ;
    } else if([schema isEqualToString:VEAM_CLOSE_COMMENT_SCHEMA]){
        showAllComments = NO ;
        /*
    } else {
        isBrowsing = YES ;
        WebViewController *webViewController = [[WebViewController alloc] init] ;
        [webViewController setUrl:[url absoluteString]] ;
        [self.navigationController pushViewController:webViewController animated:YES];
         */
    }
    
    [self updateView] ;
    
    return NO ;
}


/*
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    //NSLog(@"DRMMovieViewController::applicationDidEnterBackground") ;
    //[mPlayer performSelector:@selector(play) withObject:nil afterDelay:0.01];
    forcePlay = YES ;
    if(_player != nil){
        if(_player.playbackState == MPMoviePlaybackStatePaused){
            if(!manuallyPaused){
                [_player play] ;
            }
        }
    }
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    //NSLog(@"DRMMovieViewController::applicationWillEnterForeground") ;
    forcePlay = NO ;
}
*/

@end
