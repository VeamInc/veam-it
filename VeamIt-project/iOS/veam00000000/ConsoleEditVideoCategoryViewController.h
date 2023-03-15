//
//  ConsoleEditVideoCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditVideoCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
}

@property(nonatomic,retain)VideoCategory *videoCategory ;

- (id)init ;

@end
