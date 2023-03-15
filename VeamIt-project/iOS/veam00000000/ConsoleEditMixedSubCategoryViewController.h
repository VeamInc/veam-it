//
//  ConsoleEditMixedSubCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "MixedSubCategory.h"

@interface ConsoleEditMixedSubCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
}

@property(nonatomic,retain)MixedCategory *mixedCategory ;
@property(nonatomic,retain)MixedSubCategory *mixedSubCategory ;

- (id)init ;

@end
