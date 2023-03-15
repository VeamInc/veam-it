//
//  ConsoleEditAudioViewController.h
//  veam00000000
//
//  Created by veam on 1/8/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "AudioCategory.h"
#import "AudioSubCategory.h"
#import "Audio.h"

@interface ConsoleEditAudioViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    ConsoleDropboxInputBarView *linkUrlInputBarView ;
    
    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)AudioCategory *audioCategory ;
@property(nonatomic,retain)AudioSubCategory *audioSubCategory ;
@property(nonatomic,retain)Audio *audio ;
@property(nonatomic,retain)Mixed *mixed ;

- (id)init ;

@end
