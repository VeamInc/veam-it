//
//  ConsoleEditYoutubeSubCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "YoutubeSubCategory.h"

@interface ConsoleEditYoutubeSubCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
}

@property(nonatomic,retain)YoutubeCategory *youtubeCategory ;
@property(nonatomic,retain)YoutubeSubCategory *youtubeSubCategory ;

- (id)init ;

@end
