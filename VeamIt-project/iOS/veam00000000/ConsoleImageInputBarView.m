//
//  ConsoleImageInputBarView.m
//  veam00000000
//
//  Created by veam on 6/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleImageInputBarView.h"
#import "VeamUtil.h"

#define VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH 100

@implementation ConsoleImageInputBarView

@synthesize delegate ;
@synthesize inputValue ;
@synthesize cropWidth ;
@synthesize cropHeight ;
@synthesize displayWidth ;
@synthesize displayHeight ;
@synthesize resizableCropArea ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTitleLabel] ;
        [self addValueLabel] ;
        [valueLabel setText:@"Select Image"] ;
        [VeamUtil registerTapAction:self target:self selector:@selector(showInputView)] ;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

/*
- (void)setTitle:(NSString *)title
{
    [self addTitleLabel] ;
    [titleLabel setText:title] ;
}

- (void)addTitleLabel
{
    if(titleLabel == nil){
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VEAM_CONSOLE_BAR_LEFT_MARGIN, 0, VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH, self.frame.size.height)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]] ;
        [titleLabel setTextColor:[UIColor redColor]] ;
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]] ;
        [self addSubview:titleLabel] ;
    }
}
*/

- (void)setInputValue:(NSString *)value
{
    inputValue = value ;
    [self addValueLabel] ;
    if([VeamUtil isEmpty:value]){
        [valueLabel setText:@"Select Image"] ;
    } else {
        [valueLabel setText:@"Uploaded"] ;
    }
}

- (NSString *)getInputValue
{
    return inputValue ;
}

- (void)addValueLabel
{
    if(valueLabel == nil){
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               VEAM_CONSOLE_BAR_LEFT_MARGIN+VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                                                               0,
                                                               self.frame.size.width-VEAM_CONSOLE_BAR_LEFT_MARGIN*2-VEAM_CONSOLE_INPUT_TEXT_BAR_TITLE_WIDTH,
                                                               self.frame.size.height)] ;
        [valueLabel setBackgroundColor:[UIColor clearColor]] ;
        [valueLabel setTextColor:[UIColor blackColor]] ;
        [valueLabel setTextAlignment:NSTextAlignmentRight] ;
        [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
        [self addSubview:valueLabel] ;
    }
}

- (void)showInputView
{
    if(delegate != nil){
        gkImagePicker = [[GKImagePicker alloc] init] ;
        gkImagePicker.cropSize = CGSizeMake(displayWidth,displayHeight) ;
        gkImagePicker.delegate = self ;
        gkImagePicker.resizeableCropArea = YES ;
        gkImagePicker.allowResize = resizableCropArea ;
        
        [delegate showImagePicker:gkImagePicker] ;
    }
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    if(image == nil){
        //NSLog(@"image is nil") ;
    }
    
    //NSLog(@"pickedImage w=%f h=%f -> w=%f h=%f",image.size.width,image.size.height,cropWidth,cropHeight) ;
    
    if(delegate != nil){
        CGFloat resizeWidth = cropWidth ;
        CGFloat resizeHeight = cropHeight ;
        if(resizableCropArea){
            if(cropHeight == 0){
                resizeHeight = cropWidth * (image.size.height / image.size.width) ;
            } else if(cropWidth == 0) {
                resizeWidth = cropHeight * (image.size.width / image.size.height) ;
            }
        }
        
        [valueLabel setText:@"Selected"] ;
        [delegate didChangeImageInputValue:self value:[VeamUtil resizeImage:image width:resizeWidth height:resizeHeight backgroundColor:[UIColor whiteColor]]] ;
        [delegate dismissImagePicker] ;
    }
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker
{
    //NSLog(@"GKImagePicker canceled") ;
    if(delegate != nil){
        [delegate dismissImagePicker] ;
    }
}

@end
