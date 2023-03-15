//
//  MessageLabel.h
//  veam31000017
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSAGE_COLOR_BLUE     1
#define MESSAGE_COLOR_PURPLE   2
#define MESSAGE_COLOR_GRAY     3
#define MESSAGE_COLOR_DARK_GRAY     4

#define MESSAGE_DIRECTION_LEFT      1
#define MESSAGE_DIRECTION_RIGHT     2

@interface AppCreatorMessageLabel : UILabel
{
    UIImageView *pickImageView ;
    CGFloat originalWidth ;
    NSInteger messageDirection ;
}

- (void)adjustSize:(NSInteger)direction ;

- (void)setBaseColor:(NSInteger)color ;

- (BOOL) canBecomeFirstResponder ;

@end
