//
//  ConsoleYoutubeViewController.h
//  veam00000000
//
//  Created by veam on 6/5/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleYoutubeViewController : ConsoleViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)YoutubeCategory *youtubeCategory ;
@property(nonatomic,retain)YoutubeSubCategory *youtubeSubCategory ;

@end
