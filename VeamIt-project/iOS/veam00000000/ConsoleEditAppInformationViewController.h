//
//  ConsoleEditAppInformationViewController.h
//  veam00000000
//
//  Created by veam on 6/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleLongTextInputBarView.h"
#import "ConsoleImageInputBarView.h"
#import "ConsoleTextSelectBarView.h"

@interface ConsoleEditAppInformationViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate,ConsoleTextSelectBarViewDelegate,ConsoleLongTextInputBarViewDelegate,ConsoleImageInputBarViewDelegate>
{
    ConsoleTextInputBarView *appNameInputBarView ;
    ConsoleTextInputBarView *storeAppNameInputBarView ;
    ConsoleLongTextInputBarView *descriptionInputBarView ;
    ConsoleLongTextInputBarView *keywordInputBarView ;
    
    ConsoleTextSelectBarView *categoryInputBarView ;

    ConsoleImageInputBarView *screenShot1ImageInputBarView ;
    ConsoleImageInputBarView *screenShot2ImageInputBarView ;
    ConsoleImageInputBarView *screenShot3ImageInputBarView ;
    ConsoleImageInputBarView *screenShot4ImageInputBarView ;
    ConsoleImageInputBarView *screenShot5ImageInputBarView ;
    
    ConsoleContents *contents ;
}

@property(nonatomic,retain)AppInfo *appInfo ;

- (id)init ;

@end
