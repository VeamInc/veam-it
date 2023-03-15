//
//  ConsoleViewController.h
//  VeamConsole
//
//  Created by veam on 5/27/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsoleBarView.h"
#import "ConsoleTextInputBarView.h"
#import "ConsoleDropboxInputBarView.h"
#import "ConsoleTextSelectBarView.h"
#import "ConsoleLongTextInputBarView.h"
#import "ConsoleImageInputBarView.h"
#import "ConsoleSwitchBarView.h"
#import "ConsoleColorPickBarView.h"
#import "ConsoleUtil.h"
#import "GKImagePicker.h"
#import "HPReorderTableView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


#define VEAM_CONSOLE_TRANSITION_TYPE_HORIZONTAL     1
#define VEAM_CONSOLE_TRANSITION_TYPE_VERTICAL       2


@interface ConsoleViewController : UIViewController <ConsoleTextInputBarViewDelegate,ConsoleSwitchBarViewDelegate,ConsoleImageInputBarViewDelegate,GKImagePickerDelegate,ConsoleColorPickBarViewDelegate>
{
    UIImageView *backgroundImageView ;
    UIView *headerView ;
    UIView *contentView ;
    UIScrollView *scrollView ;
    HPReorderTableView *tableView ;
    UITableView *normalTableView ;
    UIView *footerView ;
    UIView *maskView ;
    UIActivityIndicatorView *maskIndicator ;
    CGFloat adjustedKeyboardHeight ;
    UILabel *headerTitleLabel ;
    CGFloat footerImageHeight ;
    UIView *statusBarBackView ;
}

@property (nonatomic,assign) BOOL shouldShowFloatingMenu ;
@property (nonatomic,assign) NSInteger headerStyle ;
@property (nonatomic,assign) NSString *headerTitle ;
@property (nonatomic,assign) NSString *headerRightText ;
@property (nonatomic,assign) BOOL launchFromPreview ;
@property (nonatomic,assign) BOOL showFooter ;
@property (nonatomic,assign) BOOL hideHeaderBottomLine ;
@property (nonatomic,assign) NSInteger contentMode ;
@property (nonatomic,assign) NSInteger numberOfHeaderDots ;
@property (nonatomic,assign) NSInteger selectedHeaderDot ;
@property (nonatomic,assign) NSInteger transitionType ;
@property (nonatomic,retain) UIImage *footerImage ;


- (CGFloat)addSectionHeader:(NSString *)title y:(CGFloat)y ;
- (ConsoleBarView *)addTextBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector ;
- (ConsoleTextInputBarView *)addTextInputBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag ;
- (ConsoleDropboxInputBarView *)addDropboxInputBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag extensions:(NSString *)extensions;
- (ConsoleColorPickBarView *)addColorPickBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag ;
- (ConsoleTextSelectBarView *)addTextSelectBar:(NSString *)title selections:(NSArray *)selections selectionValues:(NSArray *)selectionValues y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag ;
- (ConsoleLongTextInputBarView *)addLongTextInputBar:(NSString *)title y:(CGFloat)y height:(CGFloat)height fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag ;
- (ConsoleImageInputBarView *)addImageInputBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine displayWidth:(CGFloat)displayWidth  displayHeight:(CGFloat)displayHeight cropWidth:(CGFloat)cropWidth  cropHeight:(CGFloat)cropHeight resizableCropArea:(BOOL)resizableCropArea tag:(NSInteger)tag ;
- (ConsoleSwitchBarView *)addSwitchBar:(NSString *)title y:(CGFloat)y fullBottomLine:(BOOL)fullBottomLine selector:(SEL)selector tag:(NSInteger)tag ;
- (CGFloat)addMainTableView ;
- (CGFloat)addNormalTableView ;
- (CGFloat)addMainScrollView ;
- (CGFloat)addMainScrollViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle ;
- (void)setScrollHeight:(CGFloat)y ;
- (void)pushViewController:(ConsoleViewController *)viewController ;
- (void)popViewController ;
-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter ;
-(void)requestDidPost:(NSNotification *)notification ;
- (void)showMask:(BOOL)show ;

- (void)didTapClose ;
- (void)didTapBack ;
- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender ;
- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender ;
- (void)sendMailWithSubjedct:(NSString *)subject to:(NSArray *)to cc:(NSArray *)cc bcc:(NSArray *)bcc body:(NSString *)body ;
- (void)sendMailWithSubjedct:(NSString *)subject body:(NSString *)body ;

- (void) keyboardWillShow:(NSNotification *)note ;
- (void) keyboardWillHide:(NSNotification *)note ;



@end
