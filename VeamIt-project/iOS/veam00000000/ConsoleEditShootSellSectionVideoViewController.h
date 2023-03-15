//
//  ConsoleEditShootSellSectionVideoViewController.h
//  veam00000000
//
//  Created by veam on 7/27/16.
//  Copyright © 2016 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "MovieView.h"

@interface ConsoleEditShootSellSectionVideoViewController : ConsoleViewController<ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    
    UIImage *thumbnailImage ;
    
    MovieView *movieView ;
    
    BOOL videoStarted ;

}

@property(nonatomic,retain)SellSectionCategory *sellSectionCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)SellSectionItem *sellSectionItem ;
@property(nonatomic,retain)NSURL *shootVideoUrl ;

- (id)init ;

@end
