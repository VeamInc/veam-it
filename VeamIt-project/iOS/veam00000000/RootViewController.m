//
//  RootViewController.m
//  Stats
//
//  Created by veam on 2014/08/26.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "RootViewController.h"
#import "ContentsBaseViewController.h"
#import "CircleBaseViewController.h"
#import "ReportManager.h"
#import "CommUtil.h"
#import "AppDelegate.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@end

@implementation RootViewController

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
    
    // ApplicationBecamActive Observerを設定
/*    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];*/

    ReportManager* reportManager = [ReportManager sharedManager];
    if(self.appId != nil){
        reportManager.appId = self.appId;
    }
    if(self.customerPrice > 0){
        reportManager.customerPrice = self.customerPrice;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self requestApi:self SEL:@selector(apiRequestEnd:)];
}

- (void)dealloc {
    // Observerを破棄
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews
{
    // ScrollViewにcontentSizeを設定(containerViewのサイズにする
    self.scrollView.contentSize = CGSizeMake(self.containerView.frame.size.width, self.containerView.frame.size.height);
    
    [self.view layoutIfNeeded];
}


#pragma mark - Navigation


// ナビゲーションバーをステータスバーと一体化する
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

// ステータスバーの文字色を帰る
- (UIStatusBarStyle)preferredStatusBarStyle {
    //文字を白くする
    return UIStatusBarStyleLightContent;
}

// Observerのハンドラ
/*- (void)applicationDidBecomeActive {
    // WebAPIをリクエストする
    [self requestApi:self SEL:@selector(apiRequestEnd:)];
}*/

// WebAPIをリクエストする
-(void)requestApi:(id)target SEL:(SEL)selector
{
    ReportManager* reportManager = [ReportManager sharedManager];
    NSString* urlString = [NSString stringWithFormat:URL_WEBAPI, reportManager.appId ];
    DLog(@"API_URL = %@", urlString);
    
    [CommUtil requestFile:urlString Target:target Selector:selector];
}

// WebAPIリクエストの終了
-(void)apiRequestEnd:(id)data
{
    // 受信したデータのセット
    ReportManager* reportManager = [ReportManager sharedManager];
    if([reportManager setData:data] == YES){
        // 結果が正しく取得できたのでローカル通知を行う
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REPORT_MANAGER_UPDATE
                                                            object:nil];
    }
}

- (IBAction)backButtonDown:(id)sender {
    [[AppDelegate sharedInstance] backFromStats] ;
}

@end

