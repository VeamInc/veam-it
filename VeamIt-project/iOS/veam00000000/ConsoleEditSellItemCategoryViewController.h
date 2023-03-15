//
//  ConsoleEditSellItemCategoryViewController.h
//  veam00000000
//
//  Created by veam on 10/29/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "SellItemCategory.h"

@interface ConsoleEditSellItemCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleTextInputBarView *urlInputBarView ;
    ConsoleTextSelectBarView *kindSelectBarView ;
    
    UIView *progressView ;
    UIActivityIndicatorView *progressIndicator ;

}

@property(nonatomic,retain)SellItemCategory *sellItemCategory ;

- (id)init ;

@end
