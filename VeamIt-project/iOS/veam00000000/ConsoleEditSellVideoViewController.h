//
//  ConsoleEditSellVideoViewController.h
//  veam00000000
//
//  Created by veam on 11/2/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleEditSellVideoViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
    ConsoleTextSelectBarView *priceSelectBarView ;
    NSArray *prices ;

    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)VideoCategory *videoCategory ;
@property(nonatomic,retain)VideoSubCategory *videoSubCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)SellVideo *sellVideo ;
@property(nonatomic,assign)BOOL isSellSection ;

- (id)init ;

@end
