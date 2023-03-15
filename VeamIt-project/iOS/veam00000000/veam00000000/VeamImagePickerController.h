//
//  VeamImagePickerController.h
//  veam31000014
//
//  Created by veam on 1/26/16.
//
//

#import <UIKit/UIKit.h>

@protocol VeamImagePickerControllerDelegate <NSObject>
- (void) shutterTouchesBegan ;
- (void) shutterTouchesEnded ;
@end

@interface VeamImagePickerController : UIImagePickerController

@property (nonatomic, retain) UIImageView *shutterImageView ;

@property (nonatomic, assign) id<VeamImagePickerControllerDelegate> shutterDelegate;

@end
