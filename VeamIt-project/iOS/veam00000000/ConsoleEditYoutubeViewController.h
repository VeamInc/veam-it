//
//  ConsoleEditYoutubeViewController.h
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleLongTextInputBarView.h"
#import "YoutubeCategory.h"
#import "YoutubeSubCategory.h"
#import "Youtube.h"

@interface ConsoleEditYoutubeViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *videoIdInputBarView ;
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleTextInputBarView *durationInputBarView ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
}

@property(nonatomic,retain)YoutubeCategory *youtubeCategory ;
@property(nonatomic,retain)YoutubeSubCategory *youtubeSubCategory ;
@property(nonatomic,retain)Youtube *youtube ;

- (id)init ;

@end
