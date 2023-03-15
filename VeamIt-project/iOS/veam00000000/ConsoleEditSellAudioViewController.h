//
//  ConsoleEditSellAudioViewController.h
//  veam00000000
//
//  Created by veam on 11/5/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "AudioCategory.h"
#import "AudioSubCategory.h"
#import "Audio.h"
#import "SellAudio.h"

@interface ConsoleEditSellAudioViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleSwitchBarView *periodicalFlagInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    ConsoleDropboxInputBarView *pdfUrlInputBarView ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
    ConsoleTextSelectBarView *priceSelectBarView ;
    NSArray *prices ;
    
    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)AudioCategory *audioCategory ;
@property(nonatomic,retain)AudioSubCategory *audioSubCategory ;
@property(nonatomic,retain)Audio *audio ;
@property(nonatomic,retain)SellAudio *sellAudio ;
@property(nonatomic,assign)BOOL isSellSection ;

- (id)init ;

@end
