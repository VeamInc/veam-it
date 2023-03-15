//
//  ConsoleEditShootVideoForMixedViewController.h
//  veam00000000
//
//  Created by veam on 7/12/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "MovieView.h"


@interface ConsoleEditShootVideoForMixedViewController : ConsoleViewController<ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    //ConsoleTextInputBarView *durationInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    
    UIImage *thumbnailImage ;
    
    MovieView *movieView ;
    
    BOOL videoStarted ;
}

@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)Mixed *mixed ;
@property(nonatomic,retain)NSURL *shootVideoUrl ;

- (id)init ;

@end
