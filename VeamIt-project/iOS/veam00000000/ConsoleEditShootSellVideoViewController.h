//
//  ConsoleEditShootSellVideoViewController.h
//  veam00000000
//
//  Created by veam on 7/27/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "MovieView.h"

@interface ConsoleEditShootSellVideoViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
    ConsoleTextSelectBarView *priceSelectBarView ;
    NSArray *prices ;
    
    UIImage *thumbnailImage ;
    
    MovieView *movieView ;

    BOOL videoStarted ;
}

@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)SellVideo *sellVideo ;
@property(nonatomic,assign)BOOL isSellSection ;
@property(nonatomic,retain)NSURL *shootVideoUrl ;

- (id)init ;

@end
