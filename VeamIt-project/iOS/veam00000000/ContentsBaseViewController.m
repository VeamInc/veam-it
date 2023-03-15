//
//  ContentsBaseViewController.m
//  Stats
//
//  Created by veam on 2014/08/27.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "ContentsBaseViewController.h"
#import "CircleBaseViewController.h"
#import "ReportManager.h"
#import "GraphCollectionViewCell.h"
#import "BarGraphCollectionViewCell.h"
#import "UIColor+RGB.h"

@interface ContentsBaseViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)pageControlValueChanged:(id)sender;

@property (weak, nonatomic) CircleBaseViewController *leftCircleBaseViewController;
@property (weak, nonatomic) CircleBaseViewController *centerCircleBaseViewController;
@property (weak, nonatomic) CircleBaseViewController *rightCircleBaseViewController;

@property (weak, nonatomic) IBOutlet UILabel *weeklyDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *weeklyPeriodLavel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPeriodLabel;

@end

@implementation ContentsBaseViewController

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

    self.pageControl.numberOfPages = MAX_PAGE_NUMBER;
    
    self.totalDataLabel.text = @"$0";
    self.weeklyDataLabel.text = @"$0";
    self.monthlyDataLabel.text = @"$0";
    self.totalPeriodLabel.text = @"";
    self.weeklyPeriodLavel.text = @"";
    self.monthlyPeriodLabel.text = @"";
    
    [self setIapTotalData];
    [self setIapMonthlyData];
    [self setIapWeeklyData];

    // 円グラフの生成
    self.leftCircleBaseViewController.lineColor = [UIColor colorWithRGB:255 red:238 green:123 blue:8];
    self.leftCircleBaseViewController.percent = 0;
    self.centerCircleBaseViewController.lineColor = [UIColor colorWithRGB:255 red:8 green:123 blue:238];
    self.centerCircleBaseViewController.percent = 0;
    self.rightCircleBaseViewController.lineColor = [UIColor colorWithRGB:255 red:246 green:16 blue:131];
    self.rightCircleBaseViewController.percent = 0;

    
    // ページ数文GraphViewControllerを生成
    for(NSInteger i=0; i<MAX_PAGE_NUMBER; i++){
        if(i == 4){
            BarGraphViewController* barGraphViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BarGraphViewController"];
            barGraphViewController.pageNumber = i;
            [self addChildViewController:barGraphViewController];
            [barGraphViewController didMoveToParentViewController:self];
        }
        else{
            GraphViewController* graphViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GraphViewController"];
            graphViewController.pageNumber = i;
            [self addChildViewController:graphViewController];
            [graphViewController didMoveToParentViewController:self];
        }
    }
 
    // ローカル通知の登録
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reportManagerUpdate)
                                                 name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // Observerの破棄
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                                  object:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LeftCircleBaseSegue"]) {
        self.leftCircleBaseViewController = [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"CenterCircleBaseSegue"]) {
        self.centerCircleBaseViewController = [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"RightCircleBaseSegue"]) {
        self.rightCircleBaseViewController = [segue destinationViewController];
    }
}

#pragma mark - UICollectionViewDataSource

// セクションの数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// セクション内のセルの数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX_PAGE_NUMBER;
}

// コレクションViewに描画されるセルを作成する
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell;

    switch(indexPath.row){
        case 0:
        {
            GraphCollectionViewCell *graphCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell0" forIndexPath:indexPath];
            GraphViewController* graphViewController = self.childViewControllers[3+indexPath.row];
            graphCell.graphViewController = graphViewController;
            graphViewController.view.frame = graphCell.bounds;
            [graphCell addSubview:graphViewController.view];
            cell = graphCell;
            break;
        }
        case 1:
        {
            GraphCollectionViewCell *graphCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell1" forIndexPath:indexPath];
            GraphViewController* graphViewController = self.childViewControllers[3+indexPath.row];
            graphCell.graphViewController = graphViewController;
            graphViewController.view.frame = graphCell.bounds;
            [graphCell addSubview:graphViewController.view];
            cell = graphCell;
            break;
        }
        case 2:
        {
            GraphCollectionViewCell *graphCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell2" forIndexPath:indexPath];
            GraphViewController* graphViewController = self.childViewControllers[3+indexPath.row];
            graphCell.graphViewController = graphViewController;
            graphViewController.view.frame = graphCell.bounds;
            [graphCell addSubview:graphViewController.view];
            cell = graphCell;
            break;
        }
        case 3:
        {
            GraphCollectionViewCell *graphCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell3" forIndexPath:indexPath];
            GraphViewController* graphViewController = self.childViewControllers[3+indexPath.row];
            graphCell.graphViewController = graphViewController;
            graphViewController.view.frame = graphCell.bounds;
            [graphCell addSubview:graphViewController.view];
            cell = graphCell;
            break;
        }
        case 4:
        {
            BarGraphCollectionViewCell *barGraphCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell4" forIndexPath:indexPath];
            BarGraphViewController* barGraphViewController = self.childViewControllers[3+indexPath.row];
            barGraphCell.barGraphViewController = barGraphViewController;
            barGraphViewController.view.frame = barGraphCell.bounds;
            [barGraphCell addSubview:barGraphViewController.view];
            cell = barGraphCell;
            break;
        }
        case 5:
        {
            GraphCollectionViewCell *graphCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell5" forIndexPath:indexPath];
            GraphViewController* graphViewController = self.childViewControllers[3+indexPath.row];
            graphCell.graphViewController = graphViewController;
            graphViewController.view.frame = graphCell.bounds;
            [graphCell addSubview:graphViewController.view];
            cell = graphCell;
            break;
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect rect = self.collectionView.frame;
    return CGSizeMake(rect.size.width-20, rect.size.height-5);
}

 #pragma mark - UICollectionViewDelegate
 
 // セルを選択した時の処理
 /*- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 }
 */

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// フリック操作によるスクロール終了
	[self endScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if(!decelerate) {
		// ドラッグ終了 かつ 加速無し
		[self endScroll];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	// setContentOffset: 等によるスクロール終了
	[self endScroll];
}

#pragma mark -
#pragma mark UIPageControlDelegate

- (IBAction)pageControlValueChanged:(id)sender
{
    [self selectCell:self.pageControl.currentPage];
}

// レポートが更新された
-(void) reportManagerUpdate
{
    [self setIapWeeklyData];
    [self setIapMonthlyData];
    [self setIapTotalData];

    [self setIapConversionRate];
    [self setReturningUsers];
    [self setRepeatSessionInOneDay];

}

// ページの設定
-(void)selectCell:(NSInteger)pageNo
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:pageNo inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
}

// スクロール終了時の処理
- (void)endScroll {
	// TODO: スクロール後の処理を書く
    CGPoint offset = self.collectionView.contentOffset;

    for(NSInteger i=0; i<MAX_PAGE_NUMBER; i++){
        if(offset.x==self.collectionView.bounds.size.width*i){
            self.pageControl.currentPage = i;
        }
    }
    
    self.currentPage = self.pageControl.currentPage;
}

// 上部Weekly表示データのセット
-(void)setIapWeeklyData
{
    CGFloat sumUnits = 0;

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapWeeklyUnits != nil){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        Unit* unit = reportManager.iapWeeklyUnits[6];
        DLog(@"%@", unit.beginDate);
        DLog(@"%@", unit.endDate);
        DLog(@"%f", unit.units);
        sumUnits = unit.units;

        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *beginFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *beginDateStr = [dateFormatter stringFromDate:beginFormatDate];
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *endFormatDate = [dateFormatter dateFromString:unit.endDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *endDateStr = [dateFormatter stringFromDate:endFormatDate];
        
        NSString* dateString = [NSString stringWithFormat:@"%@ - %@", beginDateStr, endDateStr];
        
        DLog(@"%@", dateString);
        self.weeklyPeriodLavel.text = dateString;

        sumUnits *= reportManager.customerPrice;
    }

    NSString* weeklyDataString = [NSString stringWithFormat:@"$%@",  [ReportManager roundingNumber:sumUnits] ];
    
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString alloc] initWithString:weeklyDataString];
    
    // フォント
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Trebuchet MS" size:20]
                    range:NSMakeRange(0, 1)];
    
    if([weeklyDataString hasSuffix:@"K"] ||
       [weeklyDataString hasSuffix:@"M"]){
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:30]
                        range:NSMakeRange(1, [weeklyDataString length]-2)];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:20]
                        range:NSMakeRange([weeklyDataString length]-1, 1)];
    }
    else{
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:30]
                        range:NSMakeRange(1, [weeklyDataString length]-1)];
    }
    
    [self.weeklyDataLabel setAttributedText:attrStr];
}

// 上部Monthly表示データのセット
// API修正までの暫定対応
// iTunesConnectの仕様で、Monthlyの集計は毎月５日に行うようになっているが、
// そのせいで１〜４日にアプリを起動すると０になってしまうため、
// 暫定的に最後の月が０だったときは一つ前月のデータを表示している
// 今後APIを修正する予定
-(void)setIapMonthlyData
{
    CGFloat sumUnits = 0;

    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapMonthlyUnits != nil){
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        Unit* unit = reportManager.iapMonthlyUnits[6];
        DLog(@"%@", unit.beginDate);
        DLog(@"%@", unit.endDate);
        DLog(@"%f", unit.units);
        
        if(unit.units == 0){
            unit = reportManager.iapMonthlyUnits[5];
            DLog(@"%@", unit.beginDate);
            DLog(@"%@", unit.endDate);
            DLog(@"%f", unit.units);
        }
        
        sumUnits = unit.units;
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *beginFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *beginDateStr = [dateFormatter stringFromDate:beginFormatDate];
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *endFormatDate = [dateFormatter dateFromString:unit.endDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *endDateStr = [dateFormatter stringFromDate:endFormatDate];
        
        NSString* dateString = [NSString stringWithFormat:@"%@ - %@", beginDateStr, endDateStr];
        
        DLog(@"%@", dateString);
        self.monthlyPeriodLabel.text = dateString;

        sumUnits *= reportManager.customerPrice;
    }

    NSString* monthlyDataString = [NSString stringWithFormat:@"$%@",  [ReportManager roundingNumber:sumUnits] ];

    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString alloc] initWithString:monthlyDataString];
    
    // フォント
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Trebuchet MS" size:20]
                    range:NSMakeRange(0, 1)];
    
    if([monthlyDataString hasSuffix:@"K"] ||
       [monthlyDataString hasSuffix:@"M"]){
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:30]
                        range:NSMakeRange(1, [monthlyDataString length]-2)];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:20]
                        range:NSMakeRange([monthlyDataString length]-1, 1)];
    }
    else{
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:30]
                        range:NSMakeRange(1, [monthlyDataString length]-1)];
    }
    
    [self.monthlyDataLabel setAttributedText:attrStr];
}

// 上部Total表示集計
-(void)setIapTotalData
{
    CGFloat sumUnits = 0;
    
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapTotalUnits != nil){
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        Unit* unit = reportManager.iapTotalUnits;
        DLog(@"%@", unit.beginDate);
        DLog(@"%@", unit.endDate);
        DLog(@"%f", unit.units);
        
        // 日付の文字列をMM/dd/yyyy -> dd.MMM に変換
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *beginFormatDate = [dateFormatter dateFromString:unit.beginDate];
        
        [dateFormatter setDateFormat:@"dd.MMM"];
        NSString *beginDateStr = [dateFormatter stringFromDate:beginFormatDate];
        
        NSString* dateString = [NSString stringWithFormat:@"Start - %@", beginDateStr];
        
        DLog(@"%@", dateString);
        self.totalPeriodLabel.text = dateString;
        sumUnits = reportManager.iapTotalUnits.units * reportManager.customerPrice;
    }

    NSString* totalDataString = [NSString stringWithFormat:@"$%@",  [ReportManager roundingNumber:sumUnits] ];

    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString alloc] initWithString:totalDataString];
    
    // フォント
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Trebuchet MS" size:20]
                    range:NSMakeRange(0, 1)];

    if([totalDataString hasSuffix:@"K"] ||
       [totalDataString hasSuffix:@"M"]){
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:30]
                        range:NSMakeRange(1, [totalDataString length]-2)];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:20]
                        range:NSMakeRange([totalDataString length]-1, 1)];
    }
    else{
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Trebuchet MS" size:30]
                        range:NSMakeRange(1, [totalDataString length]-1)];
    }
    
    
    [self.totalDataLabel setAttributedText:attrStr];

}



// 左円グラフ更新　％ of Purchase Conversion rate ( # of in-app / # of downloads)
-(void)setIapConversionRate
{
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.iapTotalUnits == nil){
        return ;
    }
    if(reportManager.appTotalUnits == nil){
        return ;
    }
    
    CGFloat percent = 0;
    if(reportManager.appTotalUnits.units > 0){
        percent = (reportManager.iapTotalUnits.units / reportManager.appTotalUnits.units) * 100;
    }

    // % of Purchese Conversion
    self.leftCircleBaseViewController.percent = percent;
    [self.leftCircleBaseViewController updateView];
}

// 真ん中円グラフ更新 (% of Returning Users)
-(void) setReturningUsers
{
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.usersTotal == nil){
        return ;
    }

    CGFloat percent = 0;
    
    CGFloat total = reportManager.usersTotal.newUsers + reportManager.usersTotal.returningUsers;
    
    if(total > 0){
        percent = (reportManager.usersTotal.returningUsers / total) * 100;
    }
    
    // % of Purchese Conversion
    self.centerCircleBaseViewController.percent = percent;

    [self.centerCircleBaseViewController updateView];
}

// 右円グラフ更新 (% of Repeat Session in one day)
-(void) setRepeatSessionInOneDay
{
    ReportManager* reportManager = [ReportManager sharedManager];
    if(reportManager.repeatSessionsTotal == nil){
        return ;
    }
    
    CGFloat percent = 0;
    
    CGFloat total = reportManager.repeatSessionsTotal.newSessions + reportManager.repeatSessionsTotal.repeatSessions;
    
    if(total > 0){
        percent = (reportManager.repeatSessionsTotal.repeatSessions / total) * 100;
    }
    
    // % of Purchese Conversion
    self.rightCircleBaseViewController.percent = percent;

    [self.rightCircleBaseViewController updateView];
}

@end
