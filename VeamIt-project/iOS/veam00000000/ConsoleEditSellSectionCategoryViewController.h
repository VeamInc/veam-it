//
//  ConsoleEditSellSectionCategoryViewController.h
//  veam00000000
//
//  Created by veam on 11/18/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "SellSectionCategory.h"

@interface ConsoleEditSellSectionCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    //ConsoleTextSelectBarView *kindSelectBarView ;
    
    UIView *progressView ;
    UIActivityIndicatorView *progressIndicator ;
    
}

@property(nonatomic,retain)SellSectionCategory *sellSectionCategory ;

- (id)init ;

@end
