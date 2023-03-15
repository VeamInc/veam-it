//
//  ConsoleEditVideoViewController.h
//  veam00000000
//
//  Created by veam on 6/18/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditVideoViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    //ConsoleTextInputBarView *durationInputBarView ;
    ConsoleImageInputBarView *thumbnailImageInputBarView ;
    
    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)Mixed *mixed ;

- (id)init ;

@end
