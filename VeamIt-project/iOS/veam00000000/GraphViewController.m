//
//  GraphViewController.m
//  Stats
//
//  Created by veam on 2014/09/20.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "GraphViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ReportManager.h"
#import "UIColor+RGB.h"

/*
  page number

  0 # of app downloads     (Itunes connect)
  1 # of In-app purchase   (Itunes connect)
  2 # of posts to Forum    (Veam server)
  3 # of comments on Forum (Veam server)
  4 # of Screen views per screen   (Google Analytics)
  5 %of Returning users (Google Analytics)
 
 */

#define GRAPH_CONSTRAINT_MAX (55)

@interface GraphViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dateSelectButtons;


@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *toolTips;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *toolTipLabels;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray* buttonYConstraint;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabels;


@property (weak, nonatomic) IBOutlet UIView *lineGraphView;

@property (strong, nonatomic) CAShapeLayer *graphShapeLayer;

@property NSInteger currentDate;

- (IBAction)dateSelectButtonTouchUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlyButton;
- (IBAction)dailyButtonTouchUpInside:(id)sender;
- (IBAction)weeklyButtonTouchUpInside:(id)sender;
- (IBAction)monthlyButtonTouchUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *totalInfoLabel;
@property kPanelMode currentPanelMode;

@property (weak, nonatomic) IBOutlet UIImageView *triLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *triRightImageView;
@end

@implementation GraphViewController

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

    self.view.layer.cornerRadius = 5;
    self.view.clipsToBounds = true;

    self.lineGraphView.layer.cornerRadius = 5;
    self.lineGraphView.clipsToBounds = true;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

//    DLog(@"%f %f", self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height);
    [self clearData];

    [self selectButton:6 animation:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reportManagerUpdate)
                                                 name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                               object:nil];
    NSString* pageTitle;
    switch(self.pageNumber){
        case 0:
            pageTitle = @"# of app downloads";
            self.triLeftImageView.hidden = YES;
            self.triRightImageView.hidden = NO;
            break;
        case 1:
            pageTitle = @"# of In-app purchase";
            self.triLeftImageView.hidden = NO;
            self.triRightImageView.hidden = NO;
            break;
        case 2:
            pageTitle = @"# of posts to Forum";
            self.triLeftImageView.hidden = NO;
            self.triRightImageView.hidden = NO;
            break;
        case 3:
            pageTitle = @"# of comments on Forum";
            self.triLeftImageView.hidden = NO;
            self.triRightImageView.hidden = NO;
            break;
        case 4:
            pageTitle = @"# of Screen views per screen";
            self.triLeftImageView.hidden = NO;
            self.triRightImageView.hidden = NO;
            break;
        case 5:
            pageTitle = @"%of Returning users";
            self.triLeftImageView.hidden = NO;
            self.triRightImageView.hidden = YES;
            break;
        case 6:
            pageTitle = @"";
            break;
    }
    self.pageTitleLabel.text = pageTitle;
    
    [self setPanel:kPanelModeDaily];
    
    self.graphShapeLayer = [[CAShapeLayer alloc] initWithLayer:self.view.layer];
    self.graphShapeLayer.lineWidth = 1.0;

    UIColor* lineColor = [UIColor colorWithRGB:255 red:11 green:191 blue:171];
    self.graphShapeLayer.strokeColor = lineColor.CGColor;
    self.graphShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.graphShapeLayer.lineJoin = kCALineJoinRound;
    [self.lineGraphView.layer addSublayer:self.graphShapeLayer];

    [self updateView:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                                  object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews
{
}

-(void)updateView:(BOOL)animation
{
    [self setTotalData];

    CGFloat coefficient = GRAPH_CONSTRAINT_MAX/_graphMax;

    for(NSInteger i=0; i<7; i++){
        CGFloat data0 = _graphData[i] * coefficient;
        ((NSLayoutConstraint*)self.buttonYConstraint[i]).constant = data0;
        ((UILabel*)self.toolTipLabels[i]).text =  [NSString stringWithFormat:@"%.0f", _graphData[i]];
    }
    
    if(animation == YES){
        [UIView animateWithDuration:ANIMATION_TIME
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [self drawChart];
                         }];
    }
    else{
        [self.view layoutIfNeeded];
        [self drawChart];
    }
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
                                 ((UIView*)self.toolTips[i]).alpha = 0.0;
                                 ((UILabel*)self.dateLabels[i]).alpha = 0.0;
                             }
                         }
                         completion:^(BOOL finished){
                             for(NSInteger i=0; i<7; i++){
                                 ((UIButton*)self.dateSelectButtons[i]).selected = NO;
                                 ((UIView*)self.toolTips[i]).hidden = YES;
                                 ((UILabel*)self.dateLabels[i]).hidden = YES;
                             }
                             ((UIButton*)self.dateSelectButtons[selectNumber]).selected = YES;
                             ((UIView*)self.toolTips[selectNumber]).hidden = NO;
                             ((UILabel*)self.dateLabels[selectNumber]).hidden = NO;
                             
                             [UIView animateWithDuration:ANIMATION_TIME
                                              animations:^{
                                                  ((UIView*)self.toolTips[selectNumber]).alpha = 1.0;
                                                  ((UILabel*)self.dateLabels[selectNumber]).alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }
    else{
        for(NSInteger i=0; i<7; i++){
            ((UIButton*)self.dateSelectButtons[i]).selected = NO;
            ((UIView*)self.toolTips[i]).hidden = YES;
            ((UILabel*)self.dateLabels[i]).hidden = YES;
        }
        ((UIButton*)self.dateSelectButtons[selectNumber]).selected = YES;
        ((UIView*)self.toolTips[selectNumber]).hidden = NO;
        ((UILabel*)self.dateLabels[selectNumber]).hidden = NO;
    }

}

- (void)drawChart
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:((UIButton*)self.dateSelectButtons[0]).center];
    [path addLineToPoint:((UIButton*)self.dateSelectButtons[1]).center];
    [path moveToPoint:((UIButton*)self.dateSelectButtons[1]).center];
    [path addLineToPoint:((UIButton*)self.dateSelectButtons[2]).center];
    [path moveToPoint:((UIButton*)self.dateSelectButtons[2]).center];
    [path addLineToPoint:((UIButton*)self.dateSelectButtons[3]).center];
    [path moveToPoint:((UIButton*)self.dateSelectButtons[3]).center];
    [path addLineToPoint:((UIButton*)self.dateSelectButtons[4]).center];
    [path moveToPoint:((UIButton*)self.dateSelectButtons[4]).center];
    [path addLineToPoint:((UIButton*)self.dateSelectButtons[5]).center];
    [path moveToPoint:((UIButton*)self.dateSelectButtons[5]).center];
    [path addLineToPoint:((UIButton*)self.dateSelectButtons[6]).center];
    
    self.graphShapeLayer.path = path.CGPath;

    [self startAnimation];
}

- (void) startAnimation
{
    [self.graphShapeLayer removeAllAnimations];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = ANIMATION_TIME;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.graphShapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

-(void) reportManagerUpdate
{
    [self setPanel:self.currentPanelMode];
    [self updateView:YES];
}

-(void)setPanel:(kPanelMode)panelMode
{
    self.currentPanelMode = panelMode;
    switch(panelMode){
        case kPanelModeDaily:
            [self setDailyData];
            self.dailyButton.selected = YES;
            self.weeklyButton.selected = NO;
            self.monthlyButton.selected = NO;
            break;
        case kPanelModeWeekly:
            [self setWeeklyData];
            self.dailyButton.selected = NO;
            self.weeklyButton.selected = YES;
            self.monthlyButton.selected = NO;
            break;
        case kPanelModeMonthly:
            [self setMonthlyData];
            self.dailyButton.selected = NO;
            self.weeklyButton.selected = NO;
            self.monthlyButton.selected = YES;
            break;
    }
}

-(void)setAppDailyData
{
    [self clearData];

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.appDailyUnits == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.appDailyUnits count]; i++){
        Unit* unit = reportManager.appDailyUnits[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setAppWeeklyData
{
    [self clearData];

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.appWeeklyUnits == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.appWeeklyUnits count]; i++){
        Unit* unit = reportManager.appWeeklyUnits[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setAppMonthlyData
{
    [self clearData];

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.appMonthlyUnits == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.appMonthlyUnits count]; i++){
        Unit* unit = reportManager.appMonthlyUnits[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}


-(void)setIapDailyData
{
    [self clearData];

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapDailyUnits == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.iapDailyUnits count]; i++){
        Unit* unit = reportManager.iapDailyUnits[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);

        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setIapWeeklyData
{
    [self clearData];

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapWeeklyUnits == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.iapWeeklyUnits count]; i++){
        Unit* unit = reportManager.iapWeeklyUnits[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setIapMonthlyData
{
    [self clearData];

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapMonthlyUnits == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.iapMonthlyUnits count]; i++){
        Unit* unit = reportManager.iapMonthlyUnits[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}



-(void)setUsersDailyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.usersDaily == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.usersDaily count]; i++){
        Users* users = reportManager.usersDaily[i];
        DLog(@"%@", users.beginDate);
        DLog(@"%f", users.newUsers);
        DLog(@"%f", users.returningUsers);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:users.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = users.returningUsers;
        if(_graphMax<users.returningUsers){
            _graphMax = users.returningUsers;
        }
    }
}

-(void)setUsersWeeklyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.usersWeekly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.usersWeekly count]; i++){
        Users* users = reportManager.usersWeekly[i];
        DLog(@"%@", users.beginDate);
        DLog(@"%f", users.newUsers);
        DLog(@"%f", users.returningUsers);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:users.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = users.returningUsers;
        if(_graphMax<users.returningUsers){
            _graphMax = users.returningUsers;
        }
    }
}

-(void)setUsersMonthlyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.usersMonthly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.usersMonthly count]; i++){
        Users* users = reportManager.usersMonthly[i];
        DLog(@"%@", users.beginDate);
        DLog(@"%f", users.newUsers);
        DLog(@"%f", users.returningUsers);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:users.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = users.returningUsers;
        if(_graphMax<users.returningUsers){
            _graphMax = users.returningUsers;
        }
    }
}



-(void)setPostsDailyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.postsDaily == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.postsDaily count]; i++){
        Unit* unit = reportManager.postsDaily[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setPostsWeeklyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.postsWeekly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.postsWeekly count]; i++){
        Unit* unit = reportManager.postsWeekly[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setPostsMonthlyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.postsMonthly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.postsMonthly count]; i++){
        Unit* unit = reportManager.postsMonthly[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}


-(void)setCommentsDailyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.commentsDaily == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.commentsDaily count]; i++){
        Unit* unit = reportManager.commentsDaily[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setCommentsWeeklyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.commentsWeekly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.commentsWeekly count]; i++){
        Unit* unit = reportManager.commentsWeekly[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}

-(void)setCommentsMonthlyData
{
    [self clearData];
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.commentsMonthly == nil){
        return ;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    for(NSInteger i=0; i<[reportManager.commentsMonthly count]; i++){
        Unit* unit = reportManager.commentsMonthly[i];
        DLog(@"%@", unit.beginDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *fromFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *dateStr = [dateFormatter stringFromDate:fromFormatDate];
        ((UILabel*)self.dateLabels[i]).text = dateStr;
        _graphData[i] = unit.units;
        if(_graphMax<unit.units){
            _graphMax = unit.units;
        }
    }
}


-(void)clearData
{
    for(NSInteger i=0; i<7; i++){
        ((UILabel*)self.dateLabels[i]).text = @"";
        _graphData[i] = 0;
        
    }
    _graphMax = 20;
}


-(void)setDailyData
{
    switch(self.pageNumber)
    {
        case 0:
            [self setAppDailyData];
            break;
        case 1:
            [self setIapDailyData];
            break;
        case 2:
            [self setPostsDailyData];
            break;
        case 3:
            [self setCommentsDailyData];
            break;
        case 4:
            [self clearData];
            break;
        case 5:
            [self setUsersDailyData];
            break;
        default:
            [self clearData];
            break;
    }
}

-(void)setWeeklyData
{
    switch(self.pageNumber)
    {
        case 0:
            [self setAppWeeklyData];
            break;
        case 1:
            [self setIapWeeklyData];
            break;
        case 2:
            [self setPostsWeeklyData];
            break;
        case 3:
            [self setCommentsWeeklyData];
            break;
        case 4:
            [self clearData];
            break;
        case 5:
            [self setUsersWeeklyData];
            break;
        default:
            [self clearData];
            break;
    }
}

-(void)setMonthlyData
{
    switch(self.pageNumber)
    {
        case 0:
            [self setAppMonthlyData];
            break;
        case 1:
            [self setIapMonthlyData];
            break;
        case 2:
            [self setPostsMonthlyData];
            break;
        case 3:
            [self setCommentsMonthlyData];
            break;
        case 4:
            [self clearData];
            break;
        case 5:
            [self setUsersMonthlyData];
            break;
        default:
            [self clearData];
            break;
    }
}

-(void)setAppTotalData
{
    ReportManager* reportManager = [ReportManager sharedManager];

    // dailyTotal
    
    if(reportManager.appDailyUnits == nil){
        return ;
    }
    
    CGFloat dailyTotal;
    Unit* unit = reportManager.appDailyUnits[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    dailyTotal = unit.units;

    // weekly total
    
    if(reportManager.appWeeklyUnits == nil){
        return ;
    }

    CGFloat weeklyTotal;
    unit = reportManager.appWeeklyUnits[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    weeklyTotal = unit.units;

    CGFloat monthlyTotal;
    unit = reportManager.appMonthlyUnits[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    monthlyTotal = unit.units;

    CGFloat allTotal;
    unit = reportManager.appTotalUnits;
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    allTotal = unit.units;
    
    
    NSString* totalInfo = [NSString stringWithFormat:@"Daily %@ / Weekly %@ / Monthly %@ / Total %@",
                           [ReportManager roundingNumber:dailyTotal],
                           [ReportManager roundingNumber:weeklyTotal],
                           [ReportManager roundingNumber:monthlyTotal],
                           [ReportManager roundingNumber:allTotal]
                           ];
    
    self.totalInfoLabel.text = totalInfo;
    
    
}

-(void)setIapTotalData
{
    ReportManager* reportManager = [ReportManager sharedManager];
    
    // dailyTotal
    
    if(reportManager.iapDailyUnits == nil){
        return ;
    }
    
    CGFloat dailyTotal;
    Unit* unit = reportManager.iapDailyUnits[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    dailyTotal = unit.units;
    
    // weekly total
    
    if(reportManager.iapWeeklyUnits == nil){
        return ;
    }
    
    CGFloat weeklyTotal;
    unit = reportManager.iapWeeklyUnits[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    weeklyTotal = unit.units;
    
    CGFloat monthlyTotal;
    unit = reportManager.iapMonthlyUnits[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    monthlyTotal = unit.units;
    
    CGFloat allTotal;
    unit = reportManager.iapTotalUnits;
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    allTotal = unit.units;
    
    
    NSString* totalInfo = [NSString stringWithFormat:@"Daily %@ / Weekly %@ / Monthly %@ / Total %@",
                           [ReportManager roundingNumber:dailyTotal],
                           [ReportManager roundingNumber:weeklyTotal],
                           [ReportManager roundingNumber:monthlyTotal],
                           [ReportManager roundingNumber:allTotal]
                           ];
    
    self.totalInfoLabel.text = totalInfo;
}

-(void)setPostsTotalData
{
    ReportManager* reportManager = [ReportManager sharedManager];
    
    // dailyTotal
    
    if(reportManager.postsDaily == nil){
        return ;
    }

    if(reportManager.postsWeekly == nil){
        return ;
    }

    if(reportManager.postsMonthly == nil){
        return ;
    }

    CGFloat dailyTotal;
    Unit* unit = reportManager.postsDaily[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    dailyTotal = unit.units;
    
    // weekly total
    
    
    CGFloat weeklyTotal;
    unit = reportManager.postsWeekly[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    weeklyTotal = unit.units;
    
    CGFloat monthlyTotal;
    unit = reportManager.postsMonthly[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    monthlyTotal = unit.units;

    CGFloat allTotal;
    unit = reportManager.postsTotalUnits;
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    allTotal = unit.units;

    NSString* totalInfo = [NSString stringWithFormat:@"Daily %@ / Weekly %@ / Monthly %@ / Total %@",
                           [ReportManager roundingNumber:dailyTotal],
                           [ReportManager roundingNumber:weeklyTotal],
                           [ReportManager roundingNumber:monthlyTotal],
                           [ReportManager roundingNumber:allTotal]
                           ];
    
    self.totalInfoLabel.text = totalInfo;
}

-(void)setCommentsTotalData
{
    ReportManager* reportManager = [ReportManager sharedManager];
    
    // dailyTotal
    
    if(reportManager.commentsDaily == nil){
        return ;
    }
    
    if(reportManager.commentsWeekly == nil){
        return ;
    }
    
    if(reportManager.commentsMonthly == nil){
        return ;
    }
    
    CGFloat dailyTotal;
    Unit* unit = reportManager.commentsDaily[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    dailyTotal = unit.units;
    
    // weekly total
    
    
    CGFloat weeklyTotal;
    unit = reportManager.commentsWeekly[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    weeklyTotal = unit.units;
    
    CGFloat monthlyTotal;
    unit = reportManager.commentsMonthly[MAX_PAGE_NUMBER-1];
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    monthlyTotal = unit.units;
    
    
    CGFloat allTotal;
    unit = reportManager.commentsTotalUnits;
    DLog(@"%@", unit.beginDate);
    DLog(@"%f", unit.units);
    
    allTotal = unit.units;
    
    NSString* totalInfo = [NSString stringWithFormat:@"Daily %@ / Weekly %@ / Monthly %@ / Total %@",
                           [ReportManager roundingNumber:dailyTotal],
                           [ReportManager roundingNumber:weeklyTotal],
                           [ReportManager roundingNumber:monthlyTotal],
                           [ReportManager roundingNumber:allTotal]
                           ];
    
    self.totalInfoLabel.text = totalInfo;
}

-(void)setUsersTotalData
{
    ReportManager* reportManager = [ReportManager sharedManager];
    
    // dailyTotal
    
    if(reportManager.usersDaily == nil){
        return ;
    }

    if(reportManager.usersWeekly == nil){
        return ;
    }

    if(reportManager.usersMonthly == nil){
        return ;
    }

    CGFloat dailyTotal;
    Users* users = reportManager.usersDaily[MAX_PAGE_NUMBER-1];
    DLog(@"%@", users.beginDate);
    DLog(@"%f", users.returningUsers);
    
    dailyTotal = users.returningUsers;
    
    // weekly total
    
    CGFloat weeklyTotal;
    users = reportManager.usersWeekly[MAX_PAGE_NUMBER-1];
    DLog(@"%@", users.beginDate);
    DLog(@"%f", users.returningUsers);
    
    weeklyTotal = users.returningUsers;
    
    CGFloat monthlyTotal;
    users = reportManager.usersMonthly[MAX_PAGE_NUMBER-1];
    DLog(@"%@", users.beginDate);
    DLog(@"%f", users.returningUsers);
    
    monthlyTotal = users.returningUsers;
    
    CGFloat allTotal;
    users = reportManager.usersTotal;
    DLog(@"%@", users.beginDate);
    DLog(@"%f", users.returningUsers);
    
    allTotal = users.returningUsers;
    
    NSString* totalInfo = [NSString stringWithFormat:@"Daily %@ / Weekly %@ / Monthly %@ / Total %@",
                           [ReportManager roundingNumber:dailyTotal],
                           [ReportManager roundingNumber:weeklyTotal],
                           [ReportManager roundingNumber:monthlyTotal],
                           [ReportManager roundingNumber:allTotal]
                           ];
    
    self.totalInfoLabel.text = totalInfo;
}

-(void)setTotalData
{

    switch(self.pageNumber){
        case 0:  // "# of app downloads";
            [self setAppTotalData];
            break;
        case 1:  //"# of In-app purchase";
            [self setIapTotalData];
            break;
        case 2:  //"# of posts to Forum";
            [self setPostsTotalData];
            break;
        case 3:  //"# of comments on Forum";
            [self setCommentsTotalData];
            break;
        case 4:  //"# of Screen views per screen";
            // screenviewsは集計しない
            break;
        case 5:  //"%of Returning users";
            [self setUsersTotalData];
            break;
    }

    
}


- (IBAction)dailyButtonTouchUpInside:(id)sender {
    [self setPanel:kPanelModeDaily];
    [self updateView:YES];
}

- (IBAction)weeklyButtonTouchUpInside:(id)sender {
    [self setPanel:kPanelModeWeekly];
    [self updateView:YES];
}

- (IBAction)monthlyButtonTouchUpInside:(id)sender {
    [self setPanel:kPanelModeMonthly];
    [self updateView:YES];
}
@end
