//
//  CalendarViewController.m
//  veam31000015
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarLabel.h"
#import "VeamUtil.h"
#import "VeamCalendar.h"
#import "YoutubePlayViewController.h"
//#import "DownloadableVideo.h"
#import "AppDelegate.h"
#import "DRMMovieViewController.h"
#import "CalendarListViewController.h"
#import "WebViewController.h"
#import "ImageViewerViewController.h"
#import "SubscriptionPurchaseViewController.h"

#define ALERT_VIEW_TAG_VIDEO_DOWNLOAD     1
#define ALERT_VIEW_TAG_VIDEO_REMOVE       2


@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize inAppPurchaseManager ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#define VEAM_WEEKDAY_TEXT_BACK_VIEW_TOP_HEIGHT  28.0

#define VEAM_LIST_BACK_VIEW_TOP_HEIGHT  30
#define VEAM_LIST_BACK_VIEW_LIST_HEIGHT 45

#define VEAM_LIST_BACK_MARGIN           14
#define VEAM_MONTHLY_VIDEO_MARGIN       12

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    inAppPurchaseManager = nil ;
    
    imageDownloadsInProgressForThumbnail = [NSMutableDictionary dictionary] ;
    thumbnailImageViews = [[NSMutableArray alloc] init] ;

    UILabel *label ;
    
    workoutListViews = [[NSMutableArray alloc] init] ;
    
    isBought = [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight])] ;
    [scrollView setBackgroundColor:[UIColor clearColor]] ;
    [scrollView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:scrollView] ;
    
    CGFloat calendarBackViewHeight = 258 ;
    calendarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, [VeamUtil getTopBarHeight], [VeamUtil getScreenWidth], calendarBackViewHeight)] ;
    [calendarBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:calendarBackView] ;
    
    NSArray *weekDays = [NSArray arrayWithObjects:@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", nil] ;
    CGFloat offsetY = [VeamUtil getTopBarHeight] + 16 ;
    for(int x = 0 ; x < 7 ; x++){
        label = [[UILabel alloc] initWithFrame:CGRectMake(13+x*(VEAM_CALENDAR_LABEL_WIDTH+VEAM_CALENDAR_LABEL_GAP),offsetY,VEAM_CALENDAR_LABEL_WIDTH,10)] ;
        [label setText:[weekDays objectAtIndex:x]] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
        [label setTextAlignment:NSTextAlignmentCenter] ;
        switch (x) {
            case 0:
                [label setTextColor:[VeamUtil getColorFromArgbString:@"FFFF0085"]] ;
                break;
            case 6:
                [label setTextColor:[VeamUtil getColorFromArgbString:@"FF008CE1"]] ;
                break;
            default:
                [label setTextColor:[VeamUtil getColorFromArgbString:@"FF000000"]] ;
                break;
        }
        [scrollView addSubview:label] ;
    }

    margin = 16 ;

    CGFloat currentY = [VeamUtil getTopBarHeight]+calendarBackViewHeight+VEAM_LIST_BACK_MARGIN ;
    weekdayTextBackView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], VEAM_WEEKDAY_TEXT_BACK_VIEW_TOP_HEIGHT)] ;
    [weekdayTextBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:weekdayTextBackView] ;

    weekdayStringlabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 7, [VeamUtil getScreenWidth] - margin * 2, 15)] ;
    [weekdayStringlabel setBackgroundColor:[UIColor clearColor]] ;
    [weekdayStringlabel setText:@"Sunday"] ;
    [weekdayStringlabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [weekdayStringlabel setTextColor:[VeamUtil getNewVideosTextColor]] ;
    [weekdayTextBackView addSubview:weekdayStringlabel] ;

    weekdayTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 9, [VeamUtil getScreenWidth] - margin * 2, 15)] ;
    [weekdayTitlelabel setBackgroundColor:[UIColor clearColor]] ;
    [weekdayTitlelabel setText:@"Title"] ;
    [weekdayTitlelabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
    [weekdayTitlelabel setTextColor:[VeamUtil getBaseTextColor]] ;
    [weekdayTextBackView addSubview:weekdayTitlelabel] ;

    UIColor *weekdayColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_CALENDAR_WEEKDAY_BACK_COLOR default:@"FFAAAAAA"]] ;
    weekdayColorView = [[UIView alloc] initWithFrame:CGRectMake(0, VEAM_WEEKDAY_TEXT_BACK_VIEW_TOP_HEIGHT, [VeamUtil getScreenWidth], 1)] ;
    [weekdayColorView setBackgroundColor:weekdayColor] ;
    [weekdayTextBackView addSubview:weekdayColorView] ;
    
    weekdayDescriptionMargin = 5 ;
    weekdayDescriptionlabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, weekdayDescriptionMargin, [VeamUtil getScreenWidth], 1)] ;
    [weekdayDescriptionlabel setBackgroundColor:[UIColor clearColor]] ;
    [weekdayDescriptionlabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
    [weekdayDescriptionlabel setTextColor:[VeamUtil getBaseTextColor]] ;
    //[VeamUtil registerTapAction:weekdayDescriptionlabel target:self selector:@selector(onWeekdayDescriptionTap)] ;
    [weekdayColorView addSubview:weekdayDescriptionlabel] ;
    
    [weekdayTextBackView setAlpha:0.0] ;
    
    currentY += [weekdayTextBackView frame].size.height ;

    
    
    
    
    
    
    listBackView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, [VeamUtil getScreenWidth], VEAM_LIST_BACK_VIEW_TOP_HEIGHT)] ;
    [listBackView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [scrollView addSubview:listBackView] ;
    label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 12, [VeamUtil getScreenWidth] - margin * 2, 15)] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
    [label setText:@"Workout of the day"] ;
    [listBackView addSubview:label] ;
    currentY += [listBackView frame].size.height ;

    
    
    
    NSDateComponents *components = [VeamUtil getCurrentDateComponents] ;
    NSInteger currentYear = components.year ;
    NSInteger currentMonth = components.month ;
    year = currentYear ;
    month = currentMonth ;
    
    NSArray *monthlyContents = [calendarData getMonthlyContents] ;
    NSInteger monthlyContentsCount = [monthlyContents count] ;
    if(monthlyContentsCount > 0){
        currentY += VEAM_MONTHLY_VIDEO_MARGIN ;
        [self setMonthlyContents:currentY] ;
    }
    
    
    
    
    
    
    
    
    purchaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [purchaseView setBackgroundColor:[VeamUtil getColorFromArgbString:@"44000000"]] ;
    [self.view addSubview:purchaseView] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [purchaseView addSubview:indicator] ;
    
    [purchaseView setAlpha:0.0] ;

    thankyouView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [thankyouView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77FFFFFF"]] ;
    UIImage *image = [UIImage imageNamed:@"thankyou.png"] ;
    CGFloat imageWidth = image.size.width / 2 ;
    CGFloat imageHeight = image.size.height / 2 ;
    UIImageView *thankyouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, ([VeamUtil getScreenHeight]-imageHeight-[VeamUtil getStatusBarHeight])/2, imageWidth, imageHeight)] ;
    [thankyouImageView setImage:image] ;
    [thankyouView addSubview:thankyouImageView] ;
    [thankyouView setAlpha:0.0] ;
    [self.view addSubview:thankyouView] ;
    
    goodjobView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight])] ;
    [goodjobView setBackgroundColor:[VeamUtil getColorFromArgbString:@"77FFFFFF"]] ;
    image = [UIImage imageNamed:@"goodjob.png"] ;
    imageWidth = image.size.width / 2 ;
    imageHeight = image.size.height / 2 ;
    goodjobImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([VeamUtil getScreenWidth]-imageWidth)/2, ([VeamUtil getScreenHeight]-imageHeight-[VeamUtil getStatusBarHeight])/2, imageWidth, imageHeight)] ;
    [goodjobImageView setImage:image] ;
    [goodjobView addSubview:goodjobImageView] ;
    [goodjobView setAlpha:0.0] ;
    [self.view addSubview:goodjobView] ;
    
    

    [self addTopBar:YES showSettingsButton:YES] ;
    
    UIImage *listButtonImage = [UIImage imageNamed:@"list_button.png"] ;
    imageWidth = listButtonImage.size.width / 2 * 0.9 ;
    imageHeight = listButtonImage.size.height / 2 * 0.9 ;
    UIImageView *listButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, ([VeamUtil getTopBarHeight] - imageHeight)/2, imageWidth, imageHeight)] ;
    [listButtonImageView setImage:listButtonImage] ;
    [VeamUtil registerTapAction:listButtonImageView target:self selector:@selector(onListButtonTap)] ;
    [topBarView addSubview: listButtonImageView] ;
    
    /*
    UIImage *infoButtonImage = [UIImage imageNamed:@"top_info.png"] ;
    imageWidth = infoButtonImage.size.width / 2 ;
    imageHeight = infoButtonImage.size.height / 2 ;
    UIImageView *infoButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(252-imageWidth, ([VeamUtil getTopBarHeight] - imageHeight)/2, imageWidth, imageHeight)] ;
    [infoButtonImageView setImage:infoButtonImage] ;
    [VeamUtil registerTapAction:infoButtonImageView target:self selector:@selector(onInfoButtonTap)] ;
    [topBarView addSubview: infoButtonImageView] ;
     */
    
    
    
    [VeamUtil setCalendarYear:currentYear month:currentMonth] ;
    [self setCalendarYear:currentYear month:currentMonth needUpdate:YES] ;
    
    [self setViewName:[NSString stringWithFormat:@"Calendar/%04d%02d/",year,month]] ;
    
}

- (NSInteger)getDuration:(Mixed *)mixed
{
    NSString *durationString = @"0" ;
    if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ||
       [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO]){
        Video *video = [calendarData getVideoForId:mixed.contentId] ;
        if(video != nil){
            durationString = video.duration ;
        }
    } else if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ||
             [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO]){
        Audio *audio = [calendarData getAudioForId:mixed.contentId] ;
        if(audio != nil){
            durationString = audio.duration ;
        }
    }
    
    return [durationString integerValue] ;
}

- (void)setMonthlyContents:(CGFloat)y
{
    
    if(monthlyVideoView != nil){
        [monthlyVideoView removeFromSuperview] ;
        monthlyVideoView = nil ;
    }
    
    thumbnailImageViews = [[NSMutableArray alloc] init] ;
    NSArray *monthlyContents = [calendarData getMonthlyContents] ;
    NSInteger monthlyContentsCount = [monthlyContents count] ;
    CGFloat monthlyVideoTitleHeight = 30 ;
    CGFloat oneVideoHeght = 90 ;
    if(monthlyContentsCount > 0){
        
        NSString *monthlyContentsTitle = [self getMonthlyContentsTitle] ;
        CGFloat monthlyVideoViewHeight = monthlyVideoTitleHeight + monthlyContentsCount * oneVideoHeght ;
        monthlyVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], monthlyVideoViewHeight)] ;
        [monthlyVideoView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        [scrollView addSubview:monthlyVideoView] ;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 12, [VeamUtil getScreenWidth] - margin * 2, 15)] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]] ;
        [label setText:monthlyContentsTitle] ;
        [monthlyVideoView addSubview:label] ;
        
        for(int index = 0 ; index < monthlyContentsCount ; index++){
            UIView *oneVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, monthlyVideoTitleHeight+oneVideoHeght*index, [VeamUtil getScreenWidth], oneVideoHeght)] ;
            [oneVideoView setBackgroundColor:[UIColor clearColor]] ;
            [oneVideoView setTag:index] ;
            [monthlyVideoView addSubview:oneVideoView] ;
            
            UIView *upperLineView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, [VeamUtil getScreenWidth] - 20, 1)] ;
            [upperLineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
            [oneVideoView addSubview:upperLineView] ;
            
            Mixed *mixed = [monthlyContents objectAtIndex:index] ;
            NSString *imageUrl = [mixed thumbnailUrl] ;
            NSString *videoTitle = [mixed title] ;
            
            UIImage *arrowImage = [UIImage imageNamed:@"setting_arrow.png"] ;
            CGFloat imageWidth = arrowImage.size.width / 2 ;
            CGFloat imageHeight = arrowImage.size.height / 2 ;
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-24, 40, imageWidth, imageHeight)] ;
            [arrowImageView setImage:arrowImage] ;
            [oneVideoView addSubview:arrowImageView] ;
            
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 92, 69)] ;
            [oneVideoView addSubview:thumbnailImageView] ;
            [thumbnailImageViews addObject:thumbnailImageView] ;
            
            NSInteger durationInt = [self getDuration:mixed] ;
            NSString *durationString = [NSString stringWithFormat:@"%02d:%02d",durationInt/60,durationInt%60] ;
            UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+92+12, 60, 180, 24)] ;
            [durationLabel setBackgroundColor:[UIColor clearColor]] ;
            [durationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
            [durationLabel setText:durationString] ;
            [oneVideoView addSubview:durationLabel] ;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+92+12, 10, 180, 1)] ;
            [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
            [titleLabel setBackgroundColor:[UIColor clearColor]] ;
            [titleLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
            [titleLabel setNumberOfLines:0];
            CGRect frame = [titleLabel frame] ;
            CGFloat orgWidth = frame.size.width ;
            [titleLabel setText:@"Title"] ;
            [titleLabel sizeToFit] ;
            frame = [titleLabel frame] ;
            CGFloat lineHeight = frame.size.height ;
            frame.size.width = orgWidth ;
            [titleLabel setFrame:frame] ;
            [titleLabel setText:videoTitle] ;
            [titleLabel sizeToFit] ;
            frame = [titleLabel frame] ;
            if(frame.size.height > lineHeight){
                frame.size.height = lineHeight*2 ;
                [titleLabel setFrame:frame] ;
                [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail] ;
                [titleLabel setNumberOfLines:2] ;
            } else {
                frame.origin.y += 12 ;
                [titleLabel setFrame:frame] ;
            }
            CGRect durationFrame = [durationLabel frame] ;
            durationFrame.origin.y = frame.origin.y + frame.size.height ;
            [durationLabel setFrame:durationFrame] ;
            
            [oneVideoView addSubview:titleLabel] ;
            
            [VeamUtil registerTapAction:oneVideoView target:self selector:@selector(onDownloadableVideoTap:)] ;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0] ;
            [self startImageDownload:imageUrl forIndexPath:indexPath imageIndex:1] ;
        }
    }
}

- (void)adjustListBackView
{
    CGRect frame = [weekdayTextBackView frame] ;
    frame.origin.y = calendarBackView.frame.origin.y + calendarBackView.frame.size.height + VEAM_LIST_BACK_MARGIN ;
    [weekdayTextBackView setFrame:frame] ;

    frame = [listBackView frame] ;
    frame.origin.y = calendarBackView.frame.origin.y + calendarBackView.frame.size.height + weekdayTextBackView.frame.size.height + VEAM_LIST_BACK_MARGIN ;
    [listBackView setFrame:frame] ;
    if(monthlyVideoView != nil){
        [self adjustMonthlyVideoView] ;
    }
}

- (void)adjustMonthlyVideoView
{
    CGRect frame = [monthlyVideoView frame] ;
    frame.origin.y = listBackView.frame.origin.y + listBackView.frame.size.height + VEAM_MONTHLY_VIDEO_MARGIN ;
    [monthlyVideoView setFrame:frame] ;
    
    CGRect monthlyVideoViewFrame = monthlyVideoView.frame ;
    CGFloat contentHeight = monthlyVideoViewFrame.origin.y + monthlyVideoViewFrame.size.height + 49.0 + 50.0 ;
    if(contentHeight <= scrollView.frame.size.height){
        contentHeight = scrollView.frame.size.height + 1 ;
    }
    //NSLog(@"content height : %f",contentHeight) ;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, contentHeight)] ;
    
}

- (void)setCalendarYear:(NSInteger)targetYear month:(NSInteger)targetMonth needUpdate:(BOOL)needUpdate
{
    calendarData = [[CalendarData alloc] initWithYear:targetYear month:targetMonth] ;
    year = targetYear ;
    month = targetMonth ;
    [self setViewName:[NSString stringWithFormat:@"Calendar/%04d%02d/",year,month]] ;
    NSString *titleString = [NSString stringWithFormat:@"%@ %d",[VeamUtil getShorthandForMonth:month format:VEAM_SHORTHAND_MONTH_FORMAT_MAX5],year] ;
    [topBarLabel setText:titleString] ;
    veamCalendar = [[VeamCalendar alloc]initWithCalendarData:calendarData year:year month:month delegate:self] ;
    [veamCalendar loadCalendar] ;
    
    if(needUpdate){
        [self performSelectorInBackground:@selector(updateCalendarData) withObject:nil] ;
    }
}

- (void)didCalendarUpdated
{
    //NSLog(@"didCalendarUpdated") ;
    [self setCalendarYear:year month:month needUpdate:NO] ;
}

- (void)updateCalendarData
{
    @autoreleasepool
    {
        CalendarData *workCalendarData = [[CalendarData alloc] initWithServerData:year month:month] ;
        if([workCalendarData isValid]){
            [self performSelectorOnMainThread:@selector(didCalendarUpdated) withObject:nil waitUntilDone:NO] ;
        }
    }
}

- (void)onInfoButtonTap
{
    //NSLog(@"onInfoButtonTap") ;
    SubscriptionPurchaseViewController *calendarPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
    [calendarPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
    [self.navigationController pushViewController:calendarPurchaseViewController animated:YES] ;
}

- (void)onListButtonTap
{
    //NSLog(@"onListButtonTap") ;
    
    NSDateComponents *components = [VeamUtil getCurrentDateComponents] ;
    NSInteger currentYear = components.year ;
    
    CalendarListViewController *calendarListViewController = [[CalendarListViewController alloc] init] ;
    [calendarListViewController setYear:currentYear] ;
    [calendarListViewController setCalendarViewController:self] ;
    [calendarListViewController setTitleName:[NSString stringWithFormat:@"%d",currentYear]] ;

    [self.navigationController pushViewController:calendarListViewController animated:YES] ;
}

- (void)playDownloadableVideo:(Video *)downloadableVideo
{
    [VeamUtil playVideo:downloadableVideo title:[self getMonthlyContentsTitle]] ;
    
    /*
    [[AppDelegate sharedInstance] setMovieKey:[downloadableVideo videoKey]] ;
    DRMMovieViewController* movieViewController = [[DRMMovieViewController alloc] init];
    [movieViewController setVideoTitleName:[downloadableVideo title]] ;
    movieViewController.strPathName = getHttpUrl([downloadableVideo downloadableVideoId]) ;
    [movieViewController setContentId:[downloadableVideo downloadableVideoId]] ;
    [movieViewController setTitleName:@"Exclusive Video"] ;
    [self.navigationController pushViewController:movieViewController animated:YES] ;
     */
}

- (void)onDownloadableVideoTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    if(![self checkPurchase]){
        return ;
    }
    
    NSInteger index = singleTapGesture.view.tag ;
 
    NSArray *monthlyContents = [calendarData getMonthlyContents] ;
    if([monthlyContents count] > 0){
        Mixed *mixed = [monthlyContents objectAtIndex:index] ;
        //NSLog(@"%@ tapped",[mixed title]) ;
        [self doAction:mixed] ;

        /* TODO
        if([VeamUtil downloadableVideoExists:downloadableVideo]){
            // play movie
            //NSLog(@"play movie") ;
            [self playDownloadableVideo:downloadableVideo] ;
        } else {
            // start downloading
            previewDownloader = [[PreviewDownloader alloc]
                                 initWithDownloadableVideo:downloadableVideo
                                 dialogTitle:@"Hang on just a sec,\nVideo downloading."
                                 dialogDescription:@"Hit cancel to skip"
                                 dialogCancelText:@"Cancel"
                                 ] ;
            
            previewDownloader.delegate = self ;
        }
         */
    }
}

- (void)doAction:(Mixed *)mixed
{
    if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_VIDEO] ||
       [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO]){
        //NSLog(@"video") ;
        Video *video = [calendarData getVideoForId:mixed.contentId] ;
        if(video != nil){
            if([VeamUtil videoExists:video]){
                //NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[video createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
                [VeamUtil playVideo:video title:[self getMonthlyContentsTitle]] ;
            } else {
                // confirm download
                currentVideo = video ;
                //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"download_this_video",nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] ;
                [alert setTag:ALERT_VIEW_TAG_VIDEO_DOWNLOAD] ;
                [alert show];
            }
        }
    } else if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_FIXED_AUDIO] ||
              [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO]){
        //NSLog(@"audio") ;
        Audio *audio = [calendarData getAudioForId:mixed.contentId] ;
        if(audio != nil){
            //NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[audio createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
            [VeamUtil playAudio:audio title:[self getMonthlyContentsTitle]] ;
        }
    }
}

- (NSString *)getMonthlyContentsTitle
{
    NSString *monthlyContentsTitle = [calendarData getValueForKey:@"monthly_contents_title"] ;
    if([VeamUtil isEmpty:monthlyContentsTitle]){
        monthlyContentsTitle = @"Monthly" ;
    }
    return monthlyContentsTitle ;
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if([alertView tag] == ALERT_VIEW_TAG_VIDEO_DOWNLOAD){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
            {
                // OK
                // start downloading
                //NSLog(@"video url = %@",[currentVideo dataUrl]) ;
                Video *downloadableVideo = [[Video alloc] init] ;
                [downloadableVideo setVideoId:[currentVideo videoId]] ;
                [downloadableVideo setDataUrl:[currentVideo dataUrl]] ;
                [downloadableVideo setDataSize:[currentVideo dataSize]] ;
                
                previewDownloader = [[PreviewDownloader alloc]
                                     initWithDownloadableVideo:downloadableVideo
                                     dialogTitle:NSLocalizedString(@"PreviewDownloadTitie", nil)
                                     dialogDescription:NSLocalizedString(@"PreviewDownloadDescription",nil)
                                     dialogCancelText:@"Cancel"
                                     ] ;
                
                previewDownloader.delegate = self ;
            }
                break;
        }
    }
}

-(void) previewDownloadCompleted:(Video *)downloadableVideo
{
    //NSString *titleName = [VeamUtil getDateString:[NSNumber numberWithInteger:[[currentVideo createdAt] integerValue]] format:VEAM_DATE_STRING_MONTH_DAY_YEAR] ;
    [VeamUtil playVideo:currentVideo title:[self getMonthlyContentsTitle]] ;
}

-(void) previewDownloadCancelled:(Video *)downloadableVideo
{
    
}




- (void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"startImageDownload:%@",url) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
             case 2:
             imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
             break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if(imageDownloader == nil){
        //NSLog(@"new imageDownloader") ;
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.imageIndex = imageIndex ;
        imageDownloader.delegate = self ;
        imageDownloader.pictureUrl = url ;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload] ;
    }
}


- (void)startPurchase
{
    [indicator startAnimating] ;
    [purchaseView setAlpha:1.0] ;
    [VeamUtil setIsPurchasing:YES] ;
}

- (void)endPurchase
{
    [purchaseView setAlpha:0.0] ;
    [indicator stopAnimating] ;
    [VeamUtil setIsPurchasing:NO] ;
    inAppPurchaseManager.delegate = nil ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAllCalendarLabel
{
    NSArray *subviews = [scrollView subviews] ;
    NSInteger count = [subviews count] ;
    for(int index = 0 ; index < count ; index++){
        
        NSString* className = NSStringFromClass([[subviews objectAtIndex:index] class]);
        //NSLog(@"class=%@",className) ;
        if([className isEqualToString:@"CalendarLabel"]){
            CalendarLabel *calendarLabel = [subviews objectAtIndex:index] ;
            [calendarLabel removeFromSuperview] ;
        }
    }
}

- (void)calendarDidLoad
{
    
    [self removeAllCalendarLabel] ;
    
    CalendarLabel *label ;
    CalendarLabel *initialLabel ;
    NSInteger carendarMonth = [veamCalendar month] ;
    CGFloat offsetY = 32 + [VeamUtil getTopBarHeight] ;
    NSInteger numberOfRows = [veamCalendar numberOfRows] ;
    for(int y = 0 ; y < numberOfRows ; y++){
        for(int x = 0 ; x < 7 ; x++){
            label = [veamCalendar getCalendarLabel:x y:y] ;
            if(((label.month == carendarMonth) && (label.day == 1)) || ([label getState] == VEAM_CALENDAR_STATE_TODAY)){
                //NSLog(@"set selected label") ;
                initialLabel = label ;
            }
            [label setFrame:
             CGRectMake(
                        13+x*(VEAM_CALENDAR_LABEL_WIDTH+VEAM_CALENDAR_LABEL_GAP),
                        offsetY+y*(VEAM_CALENDAR_LABEL_WIDTH+VEAM_CALENDAR_LABEL_GAP),
                        VEAM_CALENDAR_LABEL_WIDTH,
                        VEAM_CALENDAR_LABEL_WIDTH)] ;
            [scrollView addSubview:label] ;
            [VeamUtil registerTapAction:label target:self selector:@selector(onDayTap:)] ;
        }
    }
    
    
    CGFloat monthlyVideoY = 0 ;
    if(monthlyVideoView != nil){
        monthlyVideoY = monthlyVideoView.frame.origin.y ;
    }
    [self setMonthlyContents:monthlyVideoY] ;
    
    
    CGRect frame = [calendarBackView frame] ;
    frame.size.height = numberOfRows * (VEAM_CALENDAR_LABEL_WIDTH + VEAM_CALENDAR_LABEL_GAP) + 43 ;
    [calendarBackView setFrame:frame] ;
    [self adjustListBackView] ;
    
    [self setSelectedLabel:initialLabel] ;
    
    

}

/*
- (void)onWeekdayDescriptionTap
{
    WeekdayText *weekdayText = [selectedLabel getWeekdayText] ;
    NSString *action = [weekdayText action] ;
    //NSLog(@"onWeekdayDescriptionTap : %@",action) ;
    if([action isEqualToString:VEAM_WEEKDAY_ACTION_LINK]){
        WebViewController *webViewController = [[WebViewController alloc] init] ;
        [webViewController setUrl:[weekdayText linkUrl]] ;
        [webViewController setTitleName:[weekdayText description]] ;
        [webViewController setShowBackButton:YES] ;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if([action isEqualToString:VEAM_WEEKDAY_ACTION_TAB_RECIPE]){
        [VeamUtil setTabBarControllerIndex:3] ;
    }
}
 */

- (void)setSelectedLabel:(CalendarLabel *)targetLabel
{
    if(selectedLabel != nil){
        [selectedLabel setSelected:NO] ;
    }
    selectedLabel = targetLabel ;
    [selectedLabel setSelected:YES] ;
    
    WeekdayText *weekdayText = [targetLabel getWeekdayText] ;

    NSString *weekdayString = [VeamUtil getShorthandForWeekday:[[weekdayText weekday] integerValue] format:VEAM_SHORTHAND_WEEKDAY_FORMAT_FULL] ;
    //NSLog(@"setSelectedLabel %@ %@ %@",weekdayString,[weekdayText title],[weekdayText description]) ;
    CGRect frame ;
    
    //NSLog(@"1") ;
    if(weekdayText != nil){
        [weekdayStringlabel setText:weekdayString] ;
        [weekdayTitlelabel setText:[weekdayText title]] ;
        [weekdayDescriptionlabel setText:[weekdayText description]] ;
        [weekdayDescriptionlabel setNumberOfLines:0] ;
        
        [weekdayStringlabel sizeToFit] ;
        frame = weekdayTitlelabel.frame ;
        frame.origin.x = weekdayStringlabel.frame.origin.x + weekdayStringlabel.frame.size.width + 4 ;
        frame.size.width = [VeamUtil getScreenWidth] - frame.origin.x ;
        [weekdayTitlelabel setFrame:frame] ;
        
        frame = weekdayDescriptionlabel.frame ;
        frame.size.width = [VeamUtil getScreenWidth] - margin * 2 ;
        [weekdayDescriptionlabel setFrame:frame] ;
        [weekdayDescriptionlabel sizeToFit] ;
        frame = weekdayColorView.frame ;
        frame.size.height = weekdayDescriptionlabel.frame.size.height + weekdayDescriptionMargin * 2 ;
        [weekdayColorView setFrame:frame] ;
        
        frame = weekdayTextBackView.frame ;
        frame.size.height = VEAM_WEEKDAY_TEXT_BACK_VIEW_TOP_HEIGHT + weekdayColorView.frame.size.height ;
        [weekdayTextBackView setFrame:frame] ;
        [weekdayTextBackView setAlpha:1.0] ;
    } else {
        frame = weekdayTextBackView.frame ;
        frame.size.height = 1 ;
        [weekdayTextBackView setFrame:frame] ;
        [weekdayTextBackView setAlpha:0.0] ;
    }
    
    //NSLog(@"2") ;
    
    NSInteger numberOfWorkouts = 1 ;
    if(isBought){
        numberOfWorkouts = [selectedLabel getNumberOfWorkouts] ;
    }
    CGFloat listBackViewHeight = VEAM_LIST_BACK_VIEW_TOP_HEIGHT + VEAM_LIST_BACK_VIEW_LIST_HEIGHT * numberOfWorkouts ;
    frame = [listBackView frame] ;
    frame.size.height = listBackViewHeight ;
    [listBackView setFrame:frame] ;
    
    CGRect monthlyVideoViewFrame = [monthlyVideoView frame] ;
    monthlyVideoViewFrame.origin.y = frame.origin.y + frame.size.height + 12 ;
    [monthlyVideoView setFrame:monthlyVideoViewFrame] ;
    
    //NSLog(@"3") ;
    
    //CGFloat contentHeight = monthlyVideoViewFrame.origin.y + monthlyVideoViewFrame.size.height + [VeamUtil getTabBarHeight] + 50.0 ;
    CGFloat contentHeight = monthlyVideoViewFrame.origin.y + monthlyVideoViewFrame.size.height + 49.0 + 50.0 ;
    ////NSLog(@"content height : %f",contentHeight) ;
    if(contentHeight <= scrollView.frame.size.height){
        contentHeight = scrollView.frame.size.height + 1 ;
    }
    //NSLog(@"content height : %f",contentHeight) ;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, contentHeight)] ;
    
    NSInteger numberOfPreviousWorkouts = [workoutListViews count] ;
    for(int index = 0 ; index < numberOfPreviousWorkouts ; index++){
        UIView *listView = [workoutListViews objectAtIndex:index] ;
        [listView removeFromSuperview] ;
    }
    [workoutListViews removeAllObjects] ;
    
    UIView *listView ;
    CGFloat y ;
    UIImage *image ;
    UIImageView *checkBoxImageView ;
    CGFloat checkBoxX = 12 ;
    Mixed *mixed ;
    UIColor *titleColor ;
    UIImage *arrowImage = [UIImage imageNamed:@"setting_arrow.png"] ;
    titleLabels = [[NSMutableArray alloc] init] ;
    for(int index = 0 ; index < numberOfWorkouts ; index++){
        UIView *upperLineView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, [VeamUtil getScreenWidth] - 20, 1)] ;
        y = VEAM_LIST_BACK_VIEW_TOP_HEIGHT + VEAM_LIST_BACK_VIEW_LIST_HEIGHT * index ;
        listView = [[UIView alloc] initWithFrame:CGRectMake(0, y, [VeamUtil getScreenWidth], VEAM_LIST_BACK_VIEW_LIST_HEIGHT)] ;
        [listView setBackgroundColor:[UIColor clearColor]] ;
        [upperLineView setBackgroundColor:[VeamUtil getSeparatorColor]] ;
        [listView addSubview:upperLineView] ;
        
        CalendarWorkout *workout ;
        if(isBought){
            workout = [selectedLabel getWorkoutAt:index] ;
        } else {
            Mixed *dummyMixed = [[Mixed alloc] init] ;
            [dummyMixed setTitle:[VeamUtil getCalendarDefaultWorkoutTitle]] ;
            workout = [[CalendarWorkout alloc] init] ;
            [workout setMixed:dummyMixed] ;
            [workout setDone:NO] ;
        }
        
        if([workout done]){
            image = [UIImage imageNamed:@"check_box_on.png"] ;
            titleColor = [VeamUtil getColorFromArgbString:@"77000000"] ;
        } else {
            image = [UIImage imageNamed:@"check_box_off.png"] ;
            titleColor = [UIColor blackColor] ;
        }
        CGFloat imageWidth = image.size.width/2 ;
        CGFloat imageHeight = image.size.height/2 ;

        CGFloat checkBoxY = (VEAM_LIST_BACK_VIEW_LIST_HEIGHT - imageHeight) / 2 ;
        checkBoxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(checkBoxX, checkBoxY, imageWidth, imageHeight)] ;
        [checkBoxImageView setImage:image] ;
        [checkBoxImageView setTag:index] ;
        [VeamUtil registerTapAction:checkBoxImageView target:self selector:@selector(onCheckBoxTap:)] ;
        [listView addSubview:checkBoxImageView] ;
        
        CGFloat titleX = checkBoxImageView.frame.origin.x + checkBoxImageView.frame.size.width + 5 ;
        mixed = [workout mixed] ;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, [VeamUtil getScreenWidth] - titleX - 30, VEAM_LIST_BACK_VIEW_LIST_HEIGHT)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]] ;
        [titleLabel setText:[mixed title]] ;
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
        [titleLabel setTextColor:titleColor] ;
        [titleLabel setTag:index] ;
        [VeamUtil registerTapAction:titleLabel target:self selector:@selector(onVideoTap:)] ;
        [listView addSubview:titleLabel] ;
        [titleLabels addObject:titleLabel] ;
        
        imageWidth = arrowImage.size.width/2 ;
        imageHeight = arrowImage.size.height/2 ;
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([VeamUtil getScreenWidth]-24, (VEAM_LIST_BACK_VIEW_LIST_HEIGHT-imageHeight)/2, imageWidth, imageHeight)] ;
        [arrowImageView setImage:arrowImage] ;
        [listView addSubview:arrowImageView] ;
        

        [listBackView addSubview:listView] ;
        [workoutListViews addObject:listView] ;
    }
    [self adjustListBackView] ;
}

- (void)onCheckBoxTap:(UITapGestureRecognizer *)singleTapGesture
{
    //NSLog(@"checkbox tapped") ;
    
    if(![self checkPurchase]){
        return ;
    }

    /* can check any day
    if([selectedLabel getState] != VEAM_CALENDAR_STATE_TODAY){
        return ;
    }
     */
    
    UIImageView *imageView = (UIImageView *)singleTapGesture.view ;
    NSInteger index = [imageView tag] ;
    
    UILabel *titleLabel = [titleLabels objectAtIndex:index] ;
    
    BOOL done = [selectedLabel getWorkoutDone:index] ;
    done = !done ;
    
    UIImage *image ;
    if(done){
        image = [UIImage imageNamed:@"check_box_on.png"] ;
        [titleLabel setTextColor:[VeamUtil getColorFromArgbString:@"77000000"]] ;
        
        NSInteger numberOfGoodjobImages = [VeamUtil getNumberOfGoodJobImages] ;
        //NSLog(@"numberOfGoodjobImages=%d",numberOfGoodjobImages) ;
        NSInteger goodjobIndex = 0 ;
        if(numberOfGoodjobImages > 0){
            srand(time(nil)) ;
            goodjobIndex = rand() % numberOfGoodjobImages ;
        }
        NSString *goodjobFileName = [NSString stringWithFormat:@"goodjob%d.png",goodjobIndex] ;
        [goodjobImageView setImage:[VeamUtil imageNamed:goodjobFileName]] ;
        
        [goodjobView setAlpha:1.0] ;
        [UIView beginAnimations:nil context:NULL] ;
        [UIView setAnimationDuration:3.0] ;
        [goodjobView setAlpha:0.0] ;
        [UIView commitAnimations] ;

    } else {
        image = [UIImage imageNamed:@"check_box_off.png"] ;
        [titleLabel setTextColor:[UIColor blackColor]] ;
    }
    [imageView setImage:image] ;
    [selectedLabel setWorkoutDone:index done:done] ;
    [selectedLabel updateContents] ;
}

- (void)onVideoTap:(UITapGestureRecognizer *)singleTapGesture
{
    if(![self checkPurchase]){
        return ;
    }

    UILabel *label = (UILabel *)singleTapGesture.view ;
    NSInteger index = [label tag] ;
    //NSLog(@"tap %d",index) ;
    
    CalendarWorkout *workout = [selectedLabel getWorkoutAt:index] ;
    Mixed *mixed = [workout mixed] ;
    if([[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_YOUTUBE]){
        Youtube *youtube = [calendarData getYoutubeForId:mixed.contentId] ;
        if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_NORMAL]){
            YoutubePlayViewController *youtubePlayViewController = [[YoutubePlayViewController alloc] init] ;
            [youtubePlayViewController setYoutube:youtube] ;
            [youtubePlayViewController setTitleName:@"image:youtube.png"] ;
            [self.navigationController pushViewController:youtubePlayViewController animated:YES] ;
        } else if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_WEB]){
            WebViewController *webViewController = [[WebViewController alloc] init] ;
            [webViewController setUrl:[youtube linkUrl]] ;
            [webViewController setTitleName:[youtube title]] ;
            [webViewController setShowBackButton:YES] ;
            [self.navigationController pushViewController:webViewController animated:YES];
        } else if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_IMAGE]){
            ImageViewerViewController *imageViewerViewController = [[ImageViewerViewController alloc] init] ;
            [imageViewerViewController setUrl:[youtube linkUrl]] ;
            [imageViewerViewController setTitleName:[youtube title]] ;
            [self.navigationController pushViewController:imageViewerViewController animated:YES];
        } else if([[youtube kind] isEqualToString:VEAM_YOUTUBE_KIND_POPUP]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[youtube description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show] ;
        }
    }
}

- (BOOL)checkPurchase
{
    if(!isBought){
        // purchase
        [self onInfoButtonTap] ;
        /*
        [self startPurchase] ;
        if(inAppPurchaseManager == nil){
            inAppPurchaseManager = [[InAppPurchaseManager alloc] init] ;
        }
        inAppPurchaseManager.delegate = self ;
        [inAppPurchaseManager purchaseProductWithID:VEAM_PRODUCT_ID_CALENDAR] ;
         */
        return NO ;
    }
    return YES ;
}

- (void)onDayTap:(UITapGestureRecognizer *)singleTapGesture
{
    if(![self checkPurchase]){
        return ;
    }
    
    CalendarLabel *label = (CalendarLabel *)singleTapGesture.view ;
    //NSLog(@"%d/%d/%d tapped",[label year],[label month],[label day]) ;
    if([label getState] != VEAM_CALENDAR_STATE_INACTIVE){
        [self setSelectedLabel:label] ;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(inAppPurchaseManager != nil){
        inAppPurchaseManager.delegate = nil;
    }
}


#pragma mark - InAppPurchase Delegate Methods
-(void) providePurchasedContent:(NSString *)productID
{
    //NSLog(@"providePurchasedContent %@",productID) ;
    [self endPurchase] ;
    isBought = YES ;
    [self updateCalendar] ;

    [thankyouView setAlpha:1.0] ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:3.0] ;
    [thankyouView setAlpha:0.0] ;
    [UIView commitAnimations] ;

}

- (void)updateCalendar
{
    isBought = [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;

    //NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    NSDate *currentDate = [NSDate date] ;
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate] ;
    NSInteger currentYear = components.year ;
    NSInteger currentMonth = components.month ;
    NSInteger currentDay = components.day ;
    
    for(int y = 0 ; y < 5 ; y++){
        for(int x = 0 ; x < 7 ; x++){
            CalendarLabel *label = [veamCalendar getCalendarLabel:x y:y] ;
            if([label getState] == VEAM_CALENDAR_STATE_TODAY){
                if(([label year] != currentYear) || ([label month] != currentMonth) || ([label day] != currentDay)){
                    [label setState:VEAM_CALENDAR_STATE_PAST] ;
                }
            } else {
                if(([label year] == currentYear) && ([label month] == currentMonth) && ([label day] == currentDay)){
                    [label setState:VEAM_CALENDAR_STATE_TODAY] ;
                }
            }
            [label updateContents] ;
        }
    }
    
    CGFloat monthlyVideoY = 0 ;
    if(monthlyVideoView != nil){
        monthlyVideoY = monthlyVideoView.frame.origin.y ;
    }
    [self setMonthlyContents:monthlyVideoY] ;
    
    [self setSelectedLabel:selectedLabel] ;
}

-(void) unSuccesfullPurchase:(NSString *)reason isCanceled:(BOOL)isCanceled
{
    //buyButton.enabled = YES;
    //NSLog(@"unSuccesfullPurchase Reason:%@",reason) ;
    [self endPurchase] ;
    if(!isCanceled){
        [VeamUtil dispError:@"Failed to make purchase"] ;
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    SKProduct *product= [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (product)
    {
        NSLog(@"Product title: %@" , product.localizedTitle);
        NSLog(@"Product description: %@" , product.localizedDescription);
        NSLog(@"Product price: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex
{
    //NSLog(@"imageDidLoad %d",[indexPath row]) ;
    
    NSMutableDictionary *imageDownloadsInProgress ;
    switch (imageIndex) {
        case 1:
            imageDownloadsInProgress = imageDownloadsInProgressForThumbnail ;
            break;
            /*
             case 2:
             imageDownloadsInProgress = imageDownloadsInProgressForPicture ;
             break;
             */
        default:
            break;
    }
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    [imageDownloadsInProgress removeObjectForKey:indexPath] ;
    if(imageDownloader != nil){
        //NSLog(@"imageDownloader found %fx%f",imageDownloader.pictureImage.size.width,imageDownloader.pictureImage.size.height) ;
        UIImageView *imageView = [thumbnailImageViews objectAtIndex:[indexPath row]] ;
        [imageView setImage:imageDownloader.pictureImage] ;
    } else {
        NSLog(@"imageDownloader is nil") ;
    }
}

/*
-(void) previewDownloadCompleted:(Video *)downloadableVideo
{
    //NSLog(@"download completed. play movie") ;
    //[self trackEvent:[NSString stringWithFormat:@"PreviewDownloadComplete-%@",contentId]] ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
    [self playDownloadableVideo:downloadableVideo] ;
}

-(void) previewDownloadCancelled:(Video *)downloadableVideo
{
    //NSLog(@"download cancelled.") ;
    //[self trackEvent:[NSString stringWithFormat:@"PreviewDownloadCancel-%@",contentId]] ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    if(([VeamUtil getCalendarYear] != year) || ([VeamUtil getCalendarMonth] != month)){
        [self setCalendarYear:[VeamUtil getCalendarYear] month:[VeamUtil getCalendarMonth] needUpdate:YES] ;
    }
    
    if(!isBought){
        isBought = [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;
        if(isBought){
            [self updateCalendar] ;
        }
    }
}


@end
