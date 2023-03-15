//
//  ConsoleEditSellSectionVideoViewController.h
//  veam00000000
//
//  Created by veam on 11/26/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "SellSectionItem.h"

@interface ConsoleEditSellSectionVideoViewController : ConsoleViewController<ConsoleTextInputBarViewDelegate,ConsoleDropboxInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleDropboxInputBarView *sourceUrlInputBarView ;
    ConsoleDropboxInputBarView *imageUrlInputBarView ;
    
    UIImage *thumbnailImage ;
}

@property(nonatomic,retain)SellSectionCategory *sellSectionCategory ;
@property(nonatomic,retain)Video *video ;
@property(nonatomic,retain)SellSectionItem *sellSectionItem ;

- (id)init ;

@end
