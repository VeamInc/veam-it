//
//  PieChartsView.m
//  veam31000014
//
//  Created by veam on 1/22/14.
//
//

#import "PieChartsView.h"

static inline float radians(double degrees) { return degrees * M_PI / 180.0; }

@implementation PieChartsView

@synthesize percentage ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]] ;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    // 中心座標の取得
    CGFloat x = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat y = CGRectGetHeight(self.bounds) / 2.0;
    
    // 半径
    CGFloat radius = x ;
    
    // 描画開始位置
    CGFloat start = -90.0;
	
    // 各項目の値の設定
    
    CGFloat itemAFinish = percentage * 360.0f / 100 ;
    CGFloat itemBFinish = (100-percentage) * 360.0f / 100;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*
    // 影の描画
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x + 2.0, y + 2.0, radius,  radians(0.0), radians(360.0), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
     */
    
    // 円グラフの描画
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start), radians(start + itemAFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start + itemAFinish), radians(start + itemAFinish + itemBFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)setPercentage:(CGFloat)targetPercentage
{
    percentage = targetPercentage ;
    [self setNeedsDisplay] ;
}



@end
