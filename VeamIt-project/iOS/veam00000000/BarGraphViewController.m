//
//  BarGraphViewController.m
//  Stats
//
//  Created by veam on 2014/09/29.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "BarGraphViewController.h"
#import "ReportManager.h"

#define BAR_GRAPH_CONSTRAINT_MAX (60)

@interface BarGraphElememt : NSObject

@property NSArray* screenNameArray;
@property NSArray* graphDataArray;
@property CGFloat graphMax;

@end

@implementation BarGraphElememt
@end

@interface BarGraphViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dateSelectButtons;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numberOfViewsLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *screenNameLabels;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *barGraphWidthConstraints;

@property NSInteger currentDate;

- (IBAction)dateSelectButtonTouchUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlyButton;

- (IBAction)dailyButtonTouchUpInside:(id)sender;
- (IBAction)weeklyButtonTouchUpInside:(id)sender;
- (IBAction)monthlyButtonTouchUpInside:(id)sender;

@property kPanelMode currentPanelMode;

@property NSArray* elementArray;

@end

@implementation BarGraphViewController

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
    // Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setScreenViewsDailyData];
    [self selectButton:6 animation:NO];
    [self setPanel:kPanelModeDaily];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reportManagerUpdate)
                                                 name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                               object:nil];

    [self updateView];
}

-(void) viewDidLayoutSubviews
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateView
{
    if(self.elementArray == nil){
        return ;
    }
    
    BarGraphElememt* element = self.elementArray[self.currentDate];
    
    CGFloat coefficient = 0;
    if(element.graphMax>0){
        coefficient = BAR_GRAPH_CONSTRAINT_MAX/element.graphMax;
    }

    for(NSInteger i=0; i<RANKING_MAX; i++){
        NSString* graphDataString;
        CGFloat graphData = 0;
        if([element.graphDataArray count]>i){
            // screenViewsの結果が存在する場合
            NSNumber* graphDataNumber = element.graphDataArray[i];
            graphData = [graphDataNumber floatValue];
            graphDataString = [NSString stringWithFormat:@"%@", [ReportManager roundingNumber:graphData]];
        }
        else{
            // screenViewsの結果が存在しない場合には空文字にする
            graphDataString = @"";
        }
        ((UILabel*)self.numberOfViewsLabels[i]).text = graphDataString;
        
        CGFloat data0 = graphData * coefficient;
        ((NSLayoutConstraint*)self.barGraphWidthConstraints[i]).constant = data0;

        NSString* screenName;
        if([element.screenNameArray count]>i){
            // screenViewsの結果が存在する場合
            screenName = [element.screenNameArray objectAtIndex:i];
            DLog(@"%@", screenName);
        }
        else{
            // screenViewsの結果が存在しない場合には空文字にする
            DLog(@"%@", screenName);
            screenName = @"";
        }
        
        ReportManager* reportManager = [ReportManager sharedManager];

        if([screenName hasPrefix:reportManager.screenNamePrefix] == YES){
            screenName = [screenName substringFromIndex:reportManager.screenNamePrefix.length];
            NSRange found = [screenName rangeOfString:@"/"];
            DLog(@"%lu %lu", (unsigned long)found.length, (unsigned long)found.location);
            screenName = [screenName substringFromIndex:found.location];
        }
        
        ((UILabel*)self.screenNameLabels[i]).text = screenName;
    }
    
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (IBAction)dateSelectButtonTouchUpInside:(id)sender {
    UIButton* button = sender;
    if(button.tag != self.currentDate){
        [self selectButton:button.tag animation:YES];
    }
}

-(void)selectButton:(NSInteger)selectNumber animation:(BOOL)animation
{
    self.currentDate = selectNumber;
    
    if(animation == YES){
        [UIView animateWithDuration:ANIMATION_TIME
                         animations:^{
                             for(NSInteger i=0; i<7; i++){
                                 ((UILabel*)self.dateLabels[i]).alpha = 0.0;
                             }
                         }
                         completion:^(BOOL finished){
                             for(NSInteger i=0; i<7; i++){
                                 ((UIButton*)self.dateSelectButtons[i]).selected = NO;
                                 ((UILabel*)self.dateLabels[i]).hidden = YES;
                             }
                             ((UIButton*)self.dateSelectButtons[selectNumber]).selected = YES;
                             ((UILabel*)self.dateLabels[selectNumber]).hidden = NO;
                             
                             [UIView animateWithDuration:ANIMATION_TIME
                                              animations:^{
                                                  ((UILabel*)self.dateLabels[selectNumber]).alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  [self updateView];
                                              }];
                         }];
    }
    else{
        for(NSInteger i=0; i<7; i++){
            ((UIButton*)self.dateSelectButtons[i]).selected = NO;
            ((UILabel*)self.dateLabels[i]).hidden = YES;
        }
        
        ((UIButton*)self.dateSelectButtons[selectNumber]).selected = YES;
        ((UILabel*)self.dateLabels[selectNumber]).hidden = NO;
        
        [self updateView];
    }

}

-(void) reportManagerUpdate
{
    [self setPanel:self.currentPanelMode];
    [self updateView];
}

-(void)setPanel:(kPanelMode)panelMode
{
    self.currentPanelMode = panelMode;
    switch(panelMode){
        case kPanelModeDaily:
            [self setScreenViewsDailyData];
            self.dailyButton.selected = YES;
            self.weeklyButton.selected = NO;
            self.monthlyButton.selected = NO;
            break;
        case kPanelModeWeekly:
            [self setScreenViewsWeeklyData];
            self.dailyButton.selected = NO;
            self.weeklyButton.selected = YES;
            self.monthlyButton.selected = NO;
            break;
        case kPanelModeMonthly:
            [self setScreenViewsMonthlyData];
            self.dailyButton.selected = NO;
            self.weeklyButton.selected = NO;
            self.monthlyButton.selected = YES;
            break;
    }
}

- (IBAction)dailyButtonTouchUpInside:(id)sender {
    [self setPanel:kPanelModeDaily];
    [self updateView];
}

- (IBAction)weeklyButtonTouchUpInside:(id)sender {
    [self setPanel:kPanelModeWeekly];
    [self updateView];
}

- (IBAction)monthlyButtonTouchUpInside:(id)sender {
    [self setPanel:kPanelModeMonthly];
    [self updateView];
}






-(void)setScreenViewsDailyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.screenViewsDaily == nil){
        return ;
    }
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray* elementArray = [NSMutableArray array];
    
    for(NSInteger i=0; i<[reportManager.screenViewsDaily count]; i++){
        
        NSDictionary* daily = reportManager.screenViewsDaily[i];
        NSString* beginDate = [daily objectForKey:@"beginDate"];
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:beginDate];
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        
        NSArray* ranking = [daily objectForKey:@"ranking"];
        BarGraphElememt* element = [[BarGraphElememt alloc]init];
        NSMutableArray* screenNameArray = [NSMutableArray array];
        NSMutableArray* graphDataArray = [NSMutableArray array];
        
        for(NSInteger j=0; j<[ranking count]; j++){
            if(j>=RANKING_MAX){
                continue;
            }
            NSDictionary* work = ranking[j];
            NSString* screenName      = [work objectForKey:@"screenName"];
            NSString* operatingSystem = [work objectForKey:@"operatingSystem"];
            NSString* screenviews     = [work objectForKey:@"screenviews"];
            [screenNameArray addObject:screenName];
            
            CGFloat screenViewsValue = 0;
            if([screenviews isKindOfClass:[NSString class]]){
                screenViewsValue = (NSInteger)[screenviews floatValue];
            }
            NSNumber* graphData = [NSNumber numberWithFloat:screenViewsValue];
            [graphDataArray addObject:graphData];
            
            if(element.graphMax<screenViewsValue){
                element.graphMax = screenViewsValue;
            }
        }
        element.screenNameArray = screenNameArray;
        element.graphDataArray = graphDataArray;
        [elementArray addObject:element];
    }
    self.elementArray = elementArray;
}

-(void)setScreenViewsWeeklyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.screenViewsWeekly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray* elementArray = [NSMutableArray array];
    
    for(NSInteger i=0; i<[reportManager.screenViewsWeekly count]; i++){
        
        NSDictionary* weekly = reportManager.screenViewsWeekly[i];
        NSString* beginDate = [weekly objectForKey:@"beginDate"];
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:beginDate];
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        
        NSArray* ranking = [weekly objectForKey:@"ranking"];
        BarGraphElememt* element = [[BarGraphElememt alloc]init];
        NSMutableArray* screenNameArray = [NSMutableArray array];
        NSMutableArray* graphDataArray = [NSMutableArray array];
        
        for(NSInteger j=0; j<[ranking count]; j++){
            if(j>=RANKING_MAX){
                continue;
            }
            NSDictionary* work = ranking[j];
            NSString* screenName      = [work objectForKey:@"screenName"];
            NSString* operatingSystem = [work objectForKey:@"operatingSystem"];
            NSString* screenviews     = [work objectForKey:@"screenviews"];
            [screenNameArray addObject:screenName];
            
            CGFloat screenViewsValue = 0;
            if([screenviews isKindOfClass:[NSString class]]){
                screenViewsValue = [screenviews floatValue];
            }
            NSNumber* graphData = [NSNumber numberWithFloat:screenViewsValue];
            [graphDataArray addObject:graphData];
            
            if(element.graphMax<screenViewsValue){
                element.graphMax = screenViewsValue;
            }
        }
        element.screenNameArray = screenNameArray;
        element.graphDataArray = graphDataArray;
        [elementArray addObject:element];
    }
    self.elementArray = elementArray;
}

-(void)setScreenViewsMonthlyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.screenViewsMonthly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray* elementArray = [NSMutableArray array];
    
    for(NSInteger i=0; i<[reportManager.screenViewsMonthly count]; i++){
        
        NSDictionary* monthly = reportManager.screenViewsMonthly[i];
        NSString* beginDate = [monthly objectForKey:@"beginDate"];
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:beginDate];
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        
        NSArray* ranking = [monthly objectForKey:@"ranking"];
        BarGraphElememt* element = [[BarGraphElememt alloc]init];
        NSMutableArray* screenNameArray = [NSMutableArray array];
        NSMutableArray* graphDataArray = [NSMutableArray array];
        
        for(NSInteger j=0; j<[ranking count]; j++){
            if(j>=RANKING_MAX){
                continue;
            }
            NSDictionary* work = ranking[j];
            NSString* screenName      = [work objectForKey:@"screenName"];
            NSString* operatingSystem = [work objectForKey:@"operatingSystem"];
            NSString* screenviews     = [work objectForKey:@"screenviews"];
            [screenNameArray addObject:screenName];
            
            CGFloat screenViewsValue = 0;
            if([screenviews isKindOfClass:[NSString class]]){
                screenViewsValue = [screenviews floatValue];
            }
            NSNumber* graphData = [NSNumber numberWithFloat:screenViewsValue];
            [graphDataArray addObject:graphData];
            
            if(element.graphMax<screenViewsValue){
                element.graphMax = screenViewsValue;
            }
        }
        element.screenNameArray = screenNameArray;
        element.graphDataArray = graphDataArray;
        [elementArray addObject:element];
    }
    self.elementArray = elementArray;
 }


-(void)clearData
{
    for(NSInteger i=0; i<7; i++){
        ((UILabel*)self.dateLabels[i]).text = @"";
        self.elementArray = nil;
    }
}




@end
