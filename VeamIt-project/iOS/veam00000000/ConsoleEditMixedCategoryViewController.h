//
//  ConsoleEditMixedCategoryViewController.h
//  veam00000000
//
//  Created by veam on 6/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"
#import "MixedCategory.h"

@interface ConsoleEditMixedCategoryViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
}

@property(nonatomic,retain)MixedCategory *mixedCategory ;

- (id)init ;

@end
