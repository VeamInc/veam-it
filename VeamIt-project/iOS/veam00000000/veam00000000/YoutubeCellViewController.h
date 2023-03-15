//
//  YoutubeCellViewController.h
//  veam31000000
//
//  Created by veam on 7/17/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubeCell.h"

@interface YoutubeCellViewController : UIViewController
{
    IBOutlet YoutubeCell *cell ;
}

@property (nonatomic, retain) YoutubeCell *cell ;


@end
