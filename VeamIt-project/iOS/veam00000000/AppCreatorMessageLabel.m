//
//  AppCreatorMessageLabel.m
//  veam31000017
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppCreatorMessageLabel.h"
#import "VeamUtil.h"

@implementation AppCreatorMessageLabel

#define TOP_PADDING_SIZE 9.0f
#define BOTTOM_PADDING_SIZE 9.0f
#define PADDING_BUFFER 2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)drawTextInRect:(CGRect)rect
{
    // top, left, bottom, right
    UIEdgeInsets insets = {-2.0, 10.0, 0, BOTTOM_PADDING_SIZE};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)adjustSize:(NSInteger)direction
{
    messageDirection = direction ;
    
    CGRect labelFrame = self.frame ;
    originalWidth = labelFrame.size.width ;
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(originalWidth-TOP_PADDING_SIZE-BOTTOM_PADDING_SIZE-PADDING_BUFFER, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping] ;
    labelFrame.size.height = ceil(size.height + TOP_PADDING_SIZE + BOTTOM_PADDING_SIZE) ;
    labelFrame.size.width = ceil(size.width + TOP_PADDING_SIZE + BOTTOM_PADDING_SIZE + PADDING_BUFFER) ;
    if(messageDirection == MESSAGE_DIRECTION_RIGHT){
        labelFrame.origin.x += originalWidth - labelFrame.size.width ;
    }
    [self setFrame:labelFrame] ;
    
    //NSLog(@"adjust message frame width=%f,height=%f",labelFrame.size.width,labelFrame.size.height) ;
    
    [[self layer] setCornerRadius:9.0];
    [self setClipsToBounds:YES];

}

- (void)setBaseColor:(NSInteger)color
{
    NSString *pickImageName = @"" ;
    NSString *pickColorName = @"" ;
    switch (color) {
        case MESSAGE_COLOR_BLUE:
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFA3D6F5"]] ;
            pickColorName = @"blue" ;
            break;
        case MESSAGE_COLOR_PURPLE:
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFFD19EA"]] ;
            pickColorName = @"purple" ;
            break;
        case MESSAGE_COLOR_GRAY:
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFDBDBDB"]] ;
            pickColorName = @"gray" ;
            break;
        case MESSAGE_COLOR_DARK_GRAY:
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFCBCBCB"]] ;
            pickColorName = @"dark_gray" ;
            break;
        default:
            [self setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFDBDBDB"]] ;
            pickColorName = @"gray" ;
            break;
    }
    
    if(pickImageView != nil){
        [pickImageView removeFromSuperview] ;
        pickImageView = nil ;
    }

    
    CGRect imageFrame = [self frame] ;
    imageFrame.size.width = 11 ;
    imageFrame.size.height = 13 ;

    if(messageDirection == MESSAGE_DIRECTION_LEFT){
        pickImageName = [NSString stringWithFormat:@"pick_%@.png",pickColorName] ;
        imageFrame.origin.x -= 10 ;
    } else {
        pickImageName = [NSString stringWithFormat:@"pick_right_%@.png",pickColorName] ;
        imageFrame.origin.x = self.frame.origin.x + self.frame.size.width - 1 ;
    }
    
    pickImageView = [[UIImageView alloc] initWithFrame:imageFrame] ;
    [pickImageView setImage:[UIImage imageNamed:pickImageName]] ;
    [self.superview addSubview:pickImageView] ;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame] ;
    if(pickImageView != nil){
        CGRect imageFrame = [pickImageView frame] ;
        imageFrame.origin.x = frame.origin.x - 10 ;
        imageFrame.origin.y = frame.origin.y ;
        [pickImageView setFrame:imageFrame] ;
    }
}



@end
