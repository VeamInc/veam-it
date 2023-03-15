//
//  CalendarViewController.h
//  veam31000015
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"
#import "VeamCalendar.h"
#import "CalendarLabel.h"
#import "InAppPurchaseManager.h"
#import "ImageDownloader.h"
#import "PreviewDownloader.h"
#import "CalendarData.h"
#import "Video.h"



@interface CalendarViewController : VeamViewController<VeamCalendarDelegate,InAppPurchaseManagerDelegate,ImageDownloaderDelegate>
{
    UIScrollView *scrollView ;
    VeamCalendar *veamCalendar ;
    CalendarLabel *selectedLabel ;
    UIView *listBackView ;
    NSMutableArray *workoutListViews ;
    BOOL isBought ;
    NSMutableArray *titleLabels ;
    UIActivityIndicatorView *indicator ;
    UIView *purchaseView ;
    UIView *monthlyVideoView ;
    NSMutableArray *thumbnailImageViews ;
    
    NSMutableDictionary *imageDownloadsInProgressForThumbnail ;  // the set of ImageDownloader objects for each picture
    PreviewDownloader *previewDownloader ;
    
    NSInteger year ;
    NSInteger month ;
    
    UIView *calendarBackView ;
    
    UIView *thankyouView ;
    UIView *goodjobView ;
    UIImageView *goodjobImageView ;
    
    UIView *weekdayTextBackView ;
    UIView *weekdayColorView ;
    UILabel *weekdayStringlabel ;
    UILabel *weekdayTitlelabel ;
    UILabel *weekdayDescriptionlabel ;
    CGFloat weekdayDescriptionMargin ;
    CGFloat margin ;
    
    
    CalendarData *calendarData ;
    
    Video *currentVideo ;
    
    
}

@property (nonatomic,retain) InAppPurchaseManager *inAppPurchaseManager;

- (void)calendarDidLoad ;
- (void)updateCalendar ;


@end
