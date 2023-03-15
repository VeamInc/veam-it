//
//  PieChartsView.h
//  veam31000014
//
//  Created by veam on 1/22/14.
//
//

#import <UIKit/UIKit.h>

@interface PieChartsView : UIView


@property (nonatomic, assign) CGFloat percentage ;

- (void)setPercentage:(CGFloat)targetPercentage ;

- (id)initWithFrame:(CGRect)frame ;

@end
