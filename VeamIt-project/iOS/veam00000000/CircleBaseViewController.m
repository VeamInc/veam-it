//
//  CircleBaseViewController.m
//  Stats
//
//  Created by veam on 2014/08/28.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#import "CircleBaseViewController.h"

#define RADIANS_TO_DEGREES(radians) ((radians-90) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(degrees) ((degrees-90) * (M_PI / 180.0))

@interface CircleBaseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *circleDrawView;
@property (strong, nonatomic) CAShapeLayer *shapeLayerCircle;
@property (strong, nonatomic) CAShapeLayer *shapeLayerArc;

@property CGFloat lineWidth;

@end

@implementation CircleBaseViewController

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

    self.percent = 0;
    self.lineWidth = CIRCLE_LINE_WIDTH;
    
    self.shapeLayerCircle = [[CAShapeLayer alloc] initWithLayer:self.view.layer];
    [self.circleDrawView.layer addSublayer:self.shapeLayerCircle];

    self.shapeLayerArc = [[CAShapeLayer alloc] initWithLayer:self.view.layer];
    [self.circleDrawView.layer addSublayer:self.shapeLayerArc];

    // ローカル通知の登録
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reportManagerUpdate)
                                                 name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                               object:nil];
    
}

- (void)dealloc {
    // Observerの破棄
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REPORT_MANAGER_UPDATE
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self drawChart];
}

-(void) viewDidLayoutSubviews
{
    [self updateView];
}

-(void)updateView
{
    self.titleLabel.text = [NSString stringWithFormat:@"%.0f%%", self.percent];
    [self drawChart];
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

- (void)drawChart
{
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    self.shapeLayerCircle.lineWidth = self.lineWidth;
    self.shapeLayerCircle.strokeColor = [UIColor lightGrayColor].CGColor;
    self.shapeLayerCircle.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayerCircle.lineJoin = kCALineJoinRound;
    
    self.shapeLayerArc.lineWidth = self.lineWidth;
    self.shapeLayerArc.strokeColor = self.lineColor.CGColor;
    self.shapeLayerArc.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayerArc.lineJoin = kCALineJoinRound;

    // 円のPathを生成
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:
                            CGRectMake(self.lineWidth*0.5, self.lineWidth*0.5, w-self.lineWidth, h-self.lineWidth)];
    self.shapeLayerCircle.path = circlePath.CGPath;

    float degrees = 360 * self.percent / 100;

    // 円弧のpathを生成
    UIBezierPath* arcPath
    = [UIBezierPath
       bezierPathWithArcCenter:CGPointMake(w/2, h/2)
       radius:w/2-self.lineWidth*0.5    // 半径
       startAngle:DEGREES_TO_RADIANS(0)
       endAngle:DEGREES_TO_RADIANS(degrees)
       clockwise:YES];
    
    self.shapeLayerArc.path = arcPath.CGPath;
    
    [self startAnimation];
}

- (void) startAnimation
{
    [self.shapeLayerArc removeAllAnimations];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = ANIMATION_TIME;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.shapeLayerArc addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

// レポートが更新された
-(void) reportManagerUpdate
{
    [self drawChart];
}

@end
