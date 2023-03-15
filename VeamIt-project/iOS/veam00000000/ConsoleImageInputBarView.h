//
//  ConsoleImageInputBarView.h
//  veam00000000
//
//  Created by veam on 6/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleBarView.h"
#import "GKImagePicker.h"

@protocol ConsoleImageInputBarViewDelegate ;

@interface ConsoleImageInputBarView : ConsoleBarView <GKImagePickerDelegate>
{
    //UILabel *titleLabel ;
    UILabel *valueLabel ;
    GKImagePicker *gkImagePicker ;
}

@property(nonatomic, weak) id <ConsoleImageInputBarViewDelegate> delegate ;
@property(nonatomic,retain)NSString *inputValue ;
@property(nonatomic,assign)CGFloat displayWidth ;
@property(nonatomic,assign)CGFloat displayHeight ;
@property(nonatomic,assign)CGFloat cropWidth ;
@property(nonatomic,assign)CGFloat cropHeight ;
@property(nonatomic,assign)BOOL resizableCropArea ;

//- (void)setTitle:(NSString *)title ;
- (void)setInputValue:(NSString *)value ;
- (NSString *)getInputValue ;
- (void)showInputView ;

@end

@protocol ConsoleImageInputBarViewDelegate
- (void)showImagePicker:(GKImagePicker *)gkImagePicker ;
- (void)dismissImagePicker ;
- (void)didChangeImageInputValue:(ConsoleImageInputBarView *)view value:(UIImage *)value ;
@end

