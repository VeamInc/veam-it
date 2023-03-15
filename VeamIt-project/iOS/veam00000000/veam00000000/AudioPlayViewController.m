//
//  AudioPlayViewController.m
//  veam31000016
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "AudioPlayViewController.h"

#import "VeamUtil.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"
#import "AudioData.h"
#import "AppDelegate.h"
#import "PostCommentViewController.h"
#import "PostAudioCommentViewController.h"
#import "PieChartsView.h"

#define VEAM_PENDING_OPERATION_CAMERA   1
#define VEAM_PENDING_OPERATION_LIKE     2
#define VEAM_PENDING_OPERATION_COMMENT  3


@interface AudioPlayViewController ()

@end

@implementation AudioPlayViewController

@synthesize audio ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setViewName:[NSString stringWithFormat:@"AudioPlay/%@/%@/",[audio audioId],[audio title]]] ;
    
    imageDownloadsInProgress = [NSMutableDictionary dictionary] ;
    
    isBrowsing = NO ;
    showAllComments = NO ;
    previousDownloadProgress = 0 ;
    
    //self.titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[audio createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
    //NSLog(@"title : %@",self.titleName) ;


    CGFloat deviceWidth = [VeamUtil getScreenWidth] ;
    CGFloat deviceHeight = [VeamUtil getScreenHeight] ;
    
    CGFloat margin = 10 ;
    
    BOOL hasDescription = NO ;
    NSString *description = [audio description] ;
    if((description != nil) && ![description isEqualToString:@""]){
        hasDescription = YES ;
    }

    
    BOOL isLongDevice = NO ;
    if([VeamUtil getScreenHeight] > 480){
        isLongDevice = YES ;
    }
    
    CGFloat offsetY ;
    if(hasDescription){
        offsetY = [VeamUtil getTopBarHeight] ;
    } else {
        offsetY = 76 ;
        if(isLongDevice){
            offsetY += 44 ;
        }
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight]-[VeamUtil getStatusBarHeight]-[VeamUtil getTabBarHeight])] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;
    
    
    CGFloat iconSize = 40 ;
    CGFloat iconMargin = 10 ;
    
    CGFloat thumbnailHeight = [VeamUtil getScreenWidth] * 9 / 16 ;
    CGFloat backHeight = thumbnailHeight * 1.1 + iconMargin * 2 + iconSize ;
    
    /*
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    CGRect frame = indicator.frame ;
    frame.origin.x = (deviceWidth - frame.size.width) / 2 ;
    frame.origin.y = offsetY + (backHeight - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [scrollView addSubview:indicator] ;
     */
    
    
    /*
    favoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(deviceWidth-margin-iconSize, [VeamUtil getTopBarHeight]+margin, iconSize, iconSize)] ;
    if([VeamUtil isFavoriteAudio:[audio audioId]]){
        [favoriteImageView setImage:[UIImage imageNamed:@"add_on.png"]] ;
    } else {
        [favoriteImageView setImage:[UIImage imageNamed:@"add_off.png"]] ;
    }
    [VeamUtil registerTapAction:favoriteImageView target:self selector:@selector(addButtonTap)] ;
    [scrollView addSubview:favoriteImageView] ;
     */
    
    
    CGFloat audioImageSize = 160 ;
    CGFloat audioY = (deviceHeight-audioImageSize)/2-15-[VeamUtil getViewTopOffset] ;
    if(!isLongDevice){
        audioY -= 30 ;
    }
    audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake((deviceWidth-audioImageSize)/2, audioY, audioImageSize, audioImageSize)] ;
    NSString *largeImageUrl = [audio imageUrl] ;
    if(![VeamUtil isEmpty:largeImageUrl]){
        UIImage *image = [VeamUtil getCachedImage:largeImageUrl downloadIfNot:NO] ;
        if(image == nil){
            [self startImageDownload:largeImageUrl indexPath:[NSIndexPath indexPathForRow:1 inSection:0]] ;
        } else {
            [audioImageView setImage:image] ;
        }
    } else {
        [audioImageView setImage:[UIImage imageNamed:@"audio_thumbnail.png"]] ;
    }
    [scrollView addSubview:audioImageView] ;
    
    CGRect pieFrame = audioImageView.frame ;
    pieFrame.origin.x -= 1 ;
    pieFrame.size.width += 2 ;
    pieFrame.origin.y -= 1 ;
    pieFrame.size.height += 2 ;
    pieView = [[PieChartsView alloc] initWithFrame:pieFrame] ;
    [pieView setPercentage:0] ;
    [scrollView addSubview:pieView] ;

    centerPlayImageView = [[UIImageView alloc] initWithFrame:audioImageView.frame] ;
    [centerPlayImageView setImage:[UIImage imageNamed:@"audio_play.png"]] ;
    [VeamUtil registerTapAction:centerPlayImageView target:self selector:@selector(startMusic)] ;
    [scrollView addSubview:centerPlayImageView] ;
    if(![audio hasCachedDataFile]){
        [centerPlayImageView setHidden:YES] ;
    }

    centerReplayImageView = [[UIImageView alloc] initWithFrame:audioImageView.frame] ;
    [centerReplayImageView setImage:[UIImage imageNamed:@"audio_replay.png"]] ;
    [VeamUtil registerTapAction:centerReplayImageView target:self selector:@selector(startMusic)] ;
    [scrollView addSubview:centerReplayImageView] ;
    [centerReplayImageView setHidden:YES] ;
    
    
    offsetY = audioImageView.frame.origin.y + audioImageView.frame.size.height ;
    
    CGRect audioImageFrame = audioImageView.frame ;
    
    downloadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
    CGRect frame = downloadIndicator.frame ;
    frame.origin.x = audioImageFrame.origin.x + (audioImageFrame.size.width - frame.size.width) / 2 ;
    frame.origin.y = audioImageFrame.origin.y + (audioImageFrame.size.height - frame.size.height) / 2 ;
    [downloadIndicator setFrame:frame] ;
    [scrollView addSubview:downloadIndicator] ;
    [downloadIndicator setHidden:YES] ;

    CGFloat progressLabelY = frame.origin.y + frame.size.height + 5 ;
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, progressLabelY, deviceWidth, 20)] ;
    [progressLabel setText:@"0%"] ;
    [progressLabel setTextColor:[UIColor whiteColor]] ;
    [progressLabel setBackgroundColor:[UIColor clearColor]] ;
    [progressLabel setTextAlignment:NSTextAlignmentCenter] ;
    [progressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]] ;
    [scrollView addSubview:progressLabel] ;
    [progressLabel setHidden:YES] ;
    
    if(![VeamUtil isEmpty:audio.linkUrl]){
        linkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(audioImageFrame.origin.x+122, audioImageFrame.origin.y+103, 60, 60)] ;
        [linkImageView setImage:[VeamUtil imageNamed:@"audio_link_button.png"]] ;
        [VeamUtil registerTapAction:linkImageView target:self selector:@selector(onLinkButtonTap:)] ;
        [scrollView addSubview:linkImageView] ;
    }
    
    

    
    offsetY += 10 ;
    CGFloat titleLabelHeight = 30 ;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, offsetY, deviceWidth-20, titleLabelHeight)] ;
    [titleLabel setText:[audio title]] ;
    [titleLabel setFont:[UIFont fontWithName:@"Times New Roman" size:22]] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [titleLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [scrollView addSubview:titleLabel] ;
    offsetY += titleLabelHeight ;
    
    
    offsetY += 10 ;
    // play button 37x35
    CGFloat playButtonWidth = 37 ;
    CGFloat playButtonHeight = 35 ;
    playButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake((deviceWidth-playButtonWidth)/2, offsetY, playButtonWidth, playButtonHeight)] ;
    [playButtonImageView setImage:[UIImage imageNamed:@"p_pause.png"]] ;
    [VeamUtil registerTapAction:playButtonImageView target:self selector:@selector(playButtonTapped:)] ;
    [scrollView addSubview:playButtonImageView] ;
    [playButtonImageView setHidden:YES] ;
    offsetY += playButtonHeight ;
    
    
    
    
    
    offsetY += 10 ;
    // スライダーのバック(プレーヤーのフレームの下から40のところ)
    UIImage *image = [UIImage imageNamed:@"p_slider_back.png"] ;
    sliderBackFrame.size.width = image.size.width / 2 ;
    sliderBackFrame.size.height = image.size.height / 2 ;
    sliderBackFrame.origin.x = (deviceWidth - sliderBackFrame.size.width) / 2 ;
    sliderBackFrame.origin.y = offsetY ;
    UIImageView *sliderBackImageView = [[UIImageView alloc]initWithFrame:sliderBackFrame] ;
    [sliderBackImageView setImage:image] ;
    [scrollView addSubview:sliderBackImageView] ;
    
    // タイム表示
    CGRect currentTimeFrame ;
    currentTimeFrame.origin.x = 0 ;
    currentTimeFrame.origin.y = sliderBackFrame.origin.y + 1 ;
    currentTimeFrame.size.width = sliderBackFrame.origin.x ;
    currentTimeFrame.size.height = 14 ;
    currentTimeLabel = [[UILabel alloc]initWithFrame:currentTimeFrame] ;
    [currentTimeLabel setText:@"0:00"] ;
    [currentTimeLabel setFont:[UIFont fontWithName:@"Times New Roman" size:14]] ;
    [currentTimeLabel setBackgroundColor:[UIColor clearColor]] ;
    [currentTimeLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [currentTimeLabel setTextAlignment:NSTextAlignmentRight] ;
    [scrollView addSubview:currentTimeLabel] ;
    
    // デュレーション表示
    CGRect durationFrame ;
    durationFrame.origin.x = sliderBackFrame.origin.x + sliderBackFrame.size.width ;
    durationFrame.origin.y = sliderBackFrame.origin.y + 1 ;
    durationFrame.size.width = deviceWidth - durationFrame.origin.x ;
    durationFrame.size.height = 14 ;
    UILabel *durationLabel = [[UILabel alloc]initWithFrame:durationFrame] ;
    [durationLabel setText:[self getTimeString:[[audio duration] integerValue]]] ;
    //[durationLabel setFont:[UIFont systemFontOfSize:12]] ;
    [durationLabel setFont:[UIFont fontWithName:@"Times New Roman" size:14]] ;
    [durationLabel setBackgroundColor:[UIColor clearColor]] ;
    [durationLabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [durationLabel setTextAlignment:NSTextAlignmentLeft] ;
    [scrollView addSubview:durationLabel] ;
    
    // スライダー
    CGRect sliderPointFrame ;
    image = [UIImage imageNamed:@"p_slider_point.png"] ;
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
    sliderLimitLeft = sliderBackFrame.origin.x + sliderPointWidth / 2 ;
    sliderLimitRight = sliderBackFrame.origin.x + sliderBackFrame.size.width - sliderPointWidth / 2 ;
    //NSLog(@"left=%f right=%f",sliderLimitLeft,sliderLimitRight) ;
    
    [scrollView addSubview:sliderImageView] ;
    

    
    

    
    likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconMargin, deviceHeight-iconSize-margin-[VeamUtil getStatusBarHeight], iconSize, iconSize)] ;
    [likeImageView setImage:[VeamUtil imageNamed:@"forum_like_button_off.png"]] ;
    [VeamUtil registerTapAction:likeImageView target:self selector:@selector(onLikeButtonTap:)] ;
    [scrollView addSubview:likeImageView] ;
    
    commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconMargin*2+iconSize, deviceHeight-iconSize-margin-[VeamUtil getStatusBarHeight], iconSize, iconSize)] ;
    [commentImageView setImage:[VeamUtil imageNamed:@"forum_comment_button.png"]] ;
    [VeamUtil registerTapAction:commentImageView target:self selector:@selector(onCommentButtonTap:)] ;
    [scrollView addSubview:commentImageView] ;
    
    
    
    
    image = [VeamUtil imageNamed:@"program_like.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    CGFloat infoY = deviceHeight-imageHeight-13-[VeamUtil getStatusBarHeight] ;
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
    

    
    offsetY = deviceHeight-[VeamUtil getStatusBarHeight]  ;
    /*
    UIView *bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, 58)] ;
    [bottomBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:bottomBackView] ;
    
    offsetY += 10 ;
    
    offsetY += titleLabel.frame.size.height + 5 ;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(margin, offsetY, deviceWidth-margin, 20)] ;
    [label setText:[VeamUtil getDurationString:[audio duration]]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setTextColor:[VeamUtil getBaseTextColor]] ;
    [scrollView addSubview:label] ;

    CGRect bottomBackFrame = bottomBackView.frame ;
    bottomBackFrame.size.height = label.frame.origin.y + label.frame.size.height - bottomBackFrame.origin.y ;
    [bottomBackView setFrame:bottomBackFrame] ;


    
    
    
    offsetY = bottomBackFrame.origin.y + bottomBackFrame.size.height ;
    UIView *descriptionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, 1)] ;
    [descriptionBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:descriptionBackView] ;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, [VeamUtil getScreenWidth]-margin*2, 1)] ;
    //[separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:@"22000000"]] ;
    [separatorView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
    [descriptionBackView addSubview:separatorView] ;
    
    frame = CGRectMake(margin, margin, deviceWidth-margin*2, 1) ;
    TTStyledTextLabel *descriptionlabel = [[TTStyledTextLabel alloc] initWithFrame:frame] ;
    
    NSString *linkPattern = @"(https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+)";
    NSString *linkReplacement = @"<a href=\"$1\" class=\"descLink:\">$1</a>";
    
    NSRegularExpression *linkRegexp = [NSRegularExpression
                                       regularExpressionWithPattern:linkPattern
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil
                                       ];
    
    NSString *linkedString = [linkRegexp
                              stringByReplacingMatchesInString:description
                              options:NSMatchingReportProgress
                              range:NSMakeRange(0, description.length)
                              withTemplate:linkReplacement
                              ];
    
    // NSLog(@"linkedString : %@",linkedString) ;
    
    
    [descriptionlabel setText:[TTStyledText textFromXHTML:linkedString lineBreaks:YES URLs:NO]] ;
    [descriptionlabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
    //[descriptionlabel setTextColor:[VeamUtil getColorFromArgbString:@"FF252525"]] ;
    [descriptionlabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [descriptionlabel setBackgroundColor:[UIColor clearColor]] ;
    [descriptionlabel sizeToFit] ;
    [descriptionBackView addSubview:descriptionlabel] ;
    
    //NSLog(@"descriptionlabel.frame.size.height=%f",descriptionlabel.frame.size.height) ;
    frame = descriptionBackView.frame ;
    frame.size.height = descriptionlabel.frame.size.height + margin * 2 ;
    [descriptionBackView setFrame:frame] ;
    
    offsetY += descriptionBackView.frame.size.height ;
     */
    
    commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY , deviceWidth, 36)] ;
    [commentBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:commentBackView] ;

    UIImageView *commentMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 16)] ;
    [commentMarkImageView setImage:[VeamUtil imageNamed:@"forum_comment.png"]] ;
    [commentBackView addSubview:commentMarkImageView] ;

    [self setScrollContentSize:offsetY + frame.size.height] ;
    
    appearFlag = NO ;
    [self addTopBar:YES showSettingsButton:NO] ;
    
    ttNavigator = [TTNavigator navigator] ;
    ttNavigator.delegate = self ;
    
    //[self performSelectorInBackground:@selector(reloadData) withObject:nil] ;
    
}

- (void)expandCommentTapped
{
    CGFloat contentHeight = scrollView.contentSize.height ;
    CGFloat deviceHeight = [VeamUtil getScreenHeight] ;
    CGFloat destinationY = deviceHeight ;
    if(contentHeight < (deviceHeight * 2)){
        destinationY = contentHeight - deviceHeight ;
    }
    
    [scrollView setContentOffset:CGPointMake(0, destinationY) animated:YES] ;
}


- (void)adjustInfoLayout
{

    /*
    [[youtubeCell titleLabel] setLineBreakMode:NSLineBreakByWordWrapping] ;
    [[youtubeCell titleLabel] setNumberOfLines:0];
     */

    
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
    
    infoX -= 5 ; // margin
    
    frame = heartImageView.frame ;
    infoX -= frame.size.width ;
    frame.origin.x = infoX ;
    [heartImageView setFrame:frame] ;


    
    



}


- (void)setScrollContentSize:(CGFloat)height
{
    CGFloat contentHeight = height ;
    if(contentHeight <= scrollView.frame.size.height){
        contentHeight = scrollView.frame.size.height + 1 ;
    }
    [scrollView setContentSize:CGSizeMake([VeamUtil getScreenWidth], contentHeight)] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"viewDidAppear") ;
    [super viewDidAppear:animated] ;
    
    if(![audio hasCachedDataFile]){
        if(audioDataDownloader == nil){
            [downloadIndicator startAnimating] ;
            [downloadIndicator setHidden:NO] ;
            [progressLabel setHidden:NO] ;
            audioDataDownloader = [[AudioDataDownloader alloc] initWithAudio:audio delegate:self] ;
        }
    }
    
    [self performSelectorInBackground:@selector(reloadData) withObject:nil] ;
    
    //[VeamUtil trackPageView:0 pageName:[self getPageName]] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"viewDidDisappear") ;
    if(audioDataDownloader != nil){
        [audioDataDownloader onCancel] ;
        [audioDataDownloader setDelegate:nil] ;
        audioDataDownloader = nil ;
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"shouldStartLoadWithRequest") ;
    return YES ;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"webViewDidStartLoad") ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"didFailLoadWithError") ;
}

- (void)webViewDidFinishLoad:(UIWebView *)targetWebView
{
    //NSLog(@"webViewDidFinishLoad") ;
    [indicator setAlpha:0.0] ;
    [indicator stopAnimating] ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [targetWebView setAlpha:1.0] ;
    [UIView commitAnimations];
}

- (NSString *)getPageName
{
    return [NSString stringWithFormat:@"MessagePlay/%@",[audio audioId]] ;
}

- (void)trackEvent:(NSString *)buttonName
{
    //[VeamUtil trackEvent:0 pageName:[self getPageName] buttonName:buttonName] ;
}

- (void)dealloc
{
    if(!isBrowsing){
        if (webView.loading) {
            [webView stopLoading];
        }
        [webView removeFromSuperview] ;
        [webView setDelegate:nil] ;
        webView = nil ;
    }
    
    if(ttNavigator != nil){
        [ttNavigator setDelegate:nil] ;
        ttNavigator = nil ;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"AudioPlayViewController::shouldAutorotateToInterfaceOrientation") ;
    //NSString* className = NSStringFromClass([self class]);
    //NSLog(@"class=%@",className) ;
    
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight) ;
}


/*
- (void)addButtonTap
{
    NSString *audioId = [audio audioId] ;
    if([VeamUtil isFavoriteAudio:audioId]){
        [VeamUtil deleteFavoriteAudio:audioId] ;
        [favoriteImageView setImage:[UIImage imageNamed:@"add_off.png"]] ;
    } else {
        [VeamUtil addFavoriteAudio:audioId] ;
        [favoriteImageView setImage:[UIImage imageNamed:@"add_on.png"]] ;
    }
}
*/

- (void)updateView
{
    //NSLog(@"updateView") ;
    if(audioData != nil){
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
        
        [likesLabel setText:[NSString stringWithFormat:@"%d",[audioData numberOfLikes]]] ;
        [commentNumLabel setText:[NSString stringWithFormat:@"%d",[audioData getNumberOfComments]]] ;
        
        [self setScrollContentSize:commentBackFrame.origin.y+commentBackFrame.size.height] ;
        
        if([audioData isLike]){
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
        ////NSLog(@"update audio data start") ;
        isUpdating = YES ;
        NSString *urlString = [NSString stringWithFormat:@"%@&au=%@&sid=%d",[VeamUtil getApiUrl:@"audio/getinfo"],[audio audioId],[VeamUtil getSocialUserId]] ;
        NSURL *url = [NSURL URLWithString:urlString] ;
        //NSLog(@"audiodata url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            AudioData *workAudioData = [[AudioData alloc] init] ;
            [workAudioData parseWithData:data] ;
            audioData = workAudioData ;
            isLike = [audioData isLike] ;
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        isUpdating = NO ;
        //NSLog(@"update audio data end") ;
    }
    if(audioData != nil){
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO] ;
    }
}

/*
- (void)downloadData
{
    @autoreleasepool
    {
        //NSLog(@"download audio data start") ;
    }
}
*/



- (TTStyledTextLabel *)getCommentLabel
{
    TTStyledTextLabel *label = nil ;
    if(audioData != nil){
        NSArray *comments = [audioData comments] ;
        NSInteger count = [comments count] ;
        NSString *htmlString = @"" ;
        
        NSInteger limit = VEAM_DEFAULT_COMMENT_COUNT ;
        if(showAllComments){
            limit = 999999 ;
        }
        
        for(int commentIndex = 0 ; (commentIndex < count) && (commentIndex < limit) ; commentIndex++){
            AudioComment *comment = [comments objectAtIndex:commentIndex] ;
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
    } else {
        isBrowsing = YES ;
        WebViewController *webViewController = [[WebViewController alloc] init] ;
        [webViewController setUrl:[url absoluteString]] ;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    [self updateView] ;
    
    return NO ;
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
    
    if(audioData != nil){
        // 押されたらとりあえず変更する
        UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
        if([audioData isLike]){
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
            [self performSelectorInBackground:@selector(likeCurrentAudio) withObject:nil] ;
        } else {
            [VeamUtil dispNotConnectedError] ;
        }
    }
}

- (void)onLinkButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    //NSLog(@"Link Button Tap") ;
    if(![VeamUtil isEmpty:audio.linkUrl]){
        WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        [webViewController setTitleName:self.titleName] ;
        [webViewController setTitle:self.title] ;
        [webViewController setUrl:[VeamUtil getSecureUrl:audio.linkUrl]] ;
        [webViewController setShowBackButton:YES] ;
        [self.navigationController pushViewController:webViewController animated:YES] ;
    }
}

- (void)onCommentButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"tag=%d",tag) ;
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
        PostAudioCommentViewController *postAudioCommentViewController = [[PostAudioCommentViewController alloc] initWithNibName:@"PostAudioCommentViewController" bundle:nil] ;
        [postAudioCommentViewController setAudioId:[audio audioId]] ;
        [postAudioCommentViewController setTitleName:NSLocalizedString(@"comment",nil)] ;
        [self.navigationController pushViewController:postAudioCommentViewController animated:YES] ;
        isPostViewShown = YES ;
    }
}

- (void)doPendingOperation
{
    if(pendingOperation == VEAM_PENDING_OPERATION_CAMERA){
        pendingOperation = 0 ;
        [self performSelectorOnMainThread:@selector(operateCameraButton) withObject:nil waitUntilDone:NO] ;
        //[self operateCameraButton] ;
    } else if(pendingOperation == VEAM_PENDING_OPERATION_LIKE){
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


- (void)likeCurrentAudio
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
        NSString *audioId = [audio audioId] ;
        
        NSURL *url = [VeamUtil getApiUrl:@"audio/like"] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d_%d_%@",likeValue,socialUserid,audioId]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&au=%@&sid=%d&l=%d&s=%@",[url absoluteString],audioId,socialUserid,likeValue,signature] ;
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
            //NSLog(@"count=%d",[results count]) ;
            if([results count] >= 1){
                if([[results objectAtIndex:0] isEqualToString:@"OK"]){
                    if([VeamUtil isSubscriptionFree] && (likeValue == 1)){
                        //[VeamUtil kickKiip:@"AudioLike"] ;
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
            NSLog(@"error=%@",error_str) ;
        }
        //NSLog(@"likeCurrentPicture end") ;
        [self performSelectorInBackground:@selector(reloadData) withObject:nil] ;
        //[self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
        isLikeSending = NO ;
    }
}


-(void) audioDataDownloadProgress:(CGFloat)percentage
{
    //NSLog(@"download progress %f",percentage) ;
    //[pieView setPercentage:percentage*100] ;
    
    NSInteger progress = percentage*100 ;
    if(previousDownloadProgress != progress){
        previousDownloadProgress = progress ;
        [progressLabel setText:[NSString stringWithFormat:@"%d%%",progress]] ;
    }
}

-(void) audioDataDownloadCompleted:(NSString *)audioId
{
    //NSLog(@"download completed %@",audioId) ;
    [progressLabel setHidden:YES] ;
    [downloadIndicator setHidden:YES] ;
    [downloadIndicator stopAnimating] ;
    [audioDataDownloader setDelegate:nil] ;
    audioDataDownloader = nil ;
    [centerPlayImageView setHidden:NO] ;
}

-(void) audioDataDownloadCancelled:(NSString *)audioId
{
    //NSLog(@"download cancelled %@",audioId) ;
    [progressLabel setHidden:YES] ;
    [downloadIndicator setHidden:YES] ;
    [downloadIndicator stopAnimating] ;
    [audioDataDownloader setDelegate:nil] ;
    audioDataDownloader = nil ;
}

- (void)startMusic
{
    [centerPlayImageView setHidden:YES] ;
    [centerReplayImageView setHidden:YES] ;
    [playButtonImageView setHidden:NO] ;
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[audio getDataFilePath]] error:nil] ;
    musicPlayer.delegate = self ;
    [musicPlayer play];
    [self startProgressTimer] ;
}

- (void)preventScreenLock
{
    //NSLog(@"setIdleTimerDisabled:YES") ;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
}

- (void)allowScreenLock
{
    //NSLog(@"setIdleTimerDisabled:NO") ;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

- (void)startProgressTimer
{
    [self stopProgressTimer] ;
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(progressCheck) userInfo:nil repeats:YES] ;
    [self performSelectorOnMainThread:@selector(preventScreenLock) withObject:nil waitUntilDone:NO] ;
}

- (void)stopProgressTimer
{
    if(progressTimer != nil){
        [progressTimer invalidate] ;
        progressTimer = nil ;
    }
    [self performSelectorOnMainThread:@selector(allowScreenLock) withObject:nil waitUntilDone:NO] ;
}

- (void)progressCheck
{
    //NSLog(@"progressCheck") ;
    if(musicPlayer != nil){
        float total = musicPlayer.duration ;
        float percentage = musicPlayer.currentTime / total ;
        [pieView setPercentage:percentage*100] ;
        
        if(!isDragging){
            CGRect frame = sliderImageView.frame ;
            CGFloat x = sliderBackFrame.origin.x + (sliderBackFrame.size.width - sliderPointWidth) * percentage ;
            frame.origin.x = x ;
            frame.origin.y = sliderBackFrame.origin.y - 4 ;
            [sliderImageView setFrame:frame] ;
        }
        NSString *timeString = [self getTimeString:(int)musicPlayer.currentTime] ;
        if(timeString != nil){
            [currentTimeLabel setText:timeString] ;
        } else {
            //NSLog(@"timeString is nil") ;
        }
    }
}

- (NSString *)getTimeString:(NSInteger)second
{
    NSInteger minute = second / 60 ;
    second = second % 60 ;
    NSString *timeString = [NSString stringWithFormat:@"%d:%02d",minute,second] ;
    return timeString ;
}

- (void)playButtonTapped:(id)sender
{
    if(musicPlayer != nil){
        if([musicPlayer isPlaying]){
            [musicPlayer pause] ;
            [playButtonImageView setImage:[UIImage imageNamed:@"p_play.png"]] ;
            [self stopProgressTimer] ;
        } else {
            [musicPlayer play] ;
            [playButtonImageView setImage:[UIImage imageNamed:@"p_pause.png"]] ;
            [self startProgressTimer] ;
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //NSLog(@"audioPlayerDidFinishPlaying") ;
    [self stopProgressTimer] ;
    [centerPlayImageView setHidden:YES] ;
    [centerReplayImageView setHidden:NO] ;
    [playButtonImageView setHidden:YES] ;
    [pieView setPercentage:0] ;
}

- (void)sliderDragged:(UIPanGestureRecognizer *)sender
{
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
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
            destinationTime = [musicPlayer duration] ;
        } else {
            CGFloat percentage = (destinationX - sliderLimitLeft) / (sliderLimitRight - sliderLimitLeft) ;
            destinationTime = [musicPlayer duration] * percentage ;
        }
        if(destinationTime >= [musicPlayer duration]){
            destinationTime = [musicPlayer duration] - 1.0 ;
        }
        //NSLog(@"junp to : %f",destinationTime) ;
        [musicPlayer setCurrentTime:destinationTime] ;
        
        isDragging = NO ;
    }
}

- (void)onBackButtonTap
{
    //NSLog(@"AudioPlayViewController::onBackButtonTap") ;
    [self stopProgressTimer] ;
    if(musicPlayer != nil){
        if([musicPlayer isPlaying]){
            [musicPlayer stop] ;
        }
        musicPlayer = nil ;
    }
    
    [VeamUtil showTabBarController:-1] ;
    
}


- (void)startImageDownload:(NSString *)url indexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"startImageDownload") ;
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.imageIndex = 0 ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload] ;
    }
}

- (BOOL)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"pictureImageDidLoad %d",[indexPath row]) ;
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        [audioImageView setImage:imageDownloader.pictureImage] ;
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
    
    return YES ;
}


@end
