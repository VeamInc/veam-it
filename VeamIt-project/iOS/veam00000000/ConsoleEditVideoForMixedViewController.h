//
//  ConsoleEditVideoForMixedViewController.h
//  veam00000000
//
//  Created by veam on 1/8/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditVideoForMixedViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    //ConsoleTextInputBarView *durationInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    
    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)Mixed *mixed ;

- (id)init ;

@end
