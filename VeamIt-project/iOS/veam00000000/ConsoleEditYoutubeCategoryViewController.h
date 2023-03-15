//
//  ConsoleEditYoutubeCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/3/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "YoutubeCategory.h"

@interface ConsoleEditYoutubeCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleSwitchBarView *embedFlagInputBarView ;
    ConsoleTextInputBarView *embedUrlInputBarView ;
}

@property(nonatomic,retain)YoutubeCategory *youtubeCategory ;

- (id)init ;

@end
