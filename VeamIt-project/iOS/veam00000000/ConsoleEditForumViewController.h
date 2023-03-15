//
//  ConsoleEditForumViewController.h
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleSwitchBarView.h"

@interface ConsoleEditForumViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    //ConsoleSwitchBarView *hotTopicInputBarView ;
}

@property(nonatomic,retain)Forum *forum ;

- (id)init ;

@end
