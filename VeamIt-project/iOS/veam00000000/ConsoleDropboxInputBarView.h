//
//  ConsoleDropboxInputBarView.h
//  veam00000000
//
//  Created by veam on 9/12/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"

@protocol ConsoleDropboxInputBarViewDelegate ;

@interface ConsoleDropboxInputBarView : ConsoleBarView
{
    UILabel *valueLabel ;
    UILabel *valueField ;
    NSString *hintString ;
}

@property (nonatomic, weak) id <ConsoleDropboxInputBarViewDelegate> delegate ;
@property(nonatomic,retain)NSString *inputValue ;
@property(nonatomic,retain)NSString *extensions ;

- (void)setInputValue:(NSString *)value ;
- (NSString *)getInputValue ;
- (void)showInputView ;
- (void)didFetchDropboxFileUrl:(NSString *)url ;

@end

@protocol ConsoleDropboxInputBarViewDelegate
- (void)showDropboxViewController:(ConsoleDropboxInputBarView *)view ;
- (void)didChangeDropboxInputValue:(ConsoleDropboxInputBarView *)view value:(NSString *)value ;
@end

