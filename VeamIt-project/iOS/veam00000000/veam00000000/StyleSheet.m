//
//  StyleSheet.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "StyleSheet.h"
#import "VeamUtil.h"

@implementation StyleSheet

/*
- (TTStyle*) commentUserName {
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12] color:RGBCOLOR(255,128,189) next:nil];
}
*/




/*
- (TTStyle*) viewAllComments {
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] color:RGBCOLOR(100,100,100) next:nil];
}
*/

- (UIColor *) viewAllCommentsColor {
    return RGBCOLOR(100,100,100) ;
}

- (TTStyle*)viewAllComments:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
          [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] next:
           [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) next:
            [TTTextStyle styleWithColor:self.viewAllCommentsColor next:nil]]]]];
        
    } else {
        return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] color:self.viewAllCommentsColor next:nil];
    }
}




- (TTStyle*) redText {
    return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:14] color:RGBCOLOR(255,0,0) next:nil];
}

- (TTStyle*) blueText {
    return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:14] color:RGBCOLOR(80,146,241) next:nil];
}

- (TTStyle*) twitterUserText {
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"Times New Roman" size:16] color:RGBCOLOR(80,146,241) next:nil];
}

- (TTStyle*) twitterBaseText {
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"Times New Roman" size:16] color:RGBCOLOR(0,0,0) next:nil];
}



/*
- (TTStyle*) commentText {
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] color:RGBCOLOR(32,32,32) next:nil];
}
*/
- (UIColor *) commentTextColor {
    //NSLog(@"commentUserNameColor") ;
    return [VeamUtil getBaseTextColor] ;
    //return RGBCOLOR(255,128,189) ;
}

- (TTStyle*)commentText:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
          [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] next:
           [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) next:
            [TTTextStyle styleWithColor:self.commentUserNameColor next:nil]]]]];
        
    } else {
        return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] color:self.commentTextColor next:nil];
    }
}


- (UIColor *) commentUserNameColor {
    //NSLog(@"commentUserNameColor") ;
    return [VeamUtil getNewVideosTextColor] ;
    //return RGBCOLOR(255,128,189) ;
}

- (TTStyle*)commentUserName:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
          [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] next:
           [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) next:
            [TTTextStyle styleWithColor:self.commentUserNameColor next:nil]]]]];
        
    } else {
        return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12] color:self.commentUserNameColor next:nil];
    }
}

- (TTStyle*)linkText:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
          [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] next:
           [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) next:
            [TTTextStyle styleWithColor:self.linkTextColor next:nil]]]]];
        
    } else {
        return [TTTextStyle styleWithFont:[UIFont fontWithName:@"Times New Roman" size:16] color:self.linkTextColor next:nil];
    }
}

- (TTStyle*)desc
{
    // FD62B9
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] color:RGBCOLOR(37,37,37) next:nil];
}

- (TTStyle*)descLink:(UIControlState)state
{
    // FD62B9
    return [TTTextStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] color:[VeamUtil getNewVideosTextColor] next:nil];
}



- (UIColor *) linkTextColor {
    return [VeamUtil getNewVideosTextColor] ;
    //return RGBCOLOR(80,146,241) ;
}


@end
