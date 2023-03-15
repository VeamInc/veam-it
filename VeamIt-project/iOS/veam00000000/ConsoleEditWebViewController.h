//
//  ConsoleEditWebViewController.h
//  veam00000000
//
//  Created by veam on 6/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ConsoleTextInputBarView.h"

@interface ConsoleEditWebViewController : ConsoleViewController <ConsoleTextInputBarViewDelegate>
{
    ConsoleTextInputBarView *titleInputBarView ;
    ConsoleTextInputBarView *urlInputBarView ;
}

@property(nonatomic,retain)Web *web ;

- (id)init ;

@end
