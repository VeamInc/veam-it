//
//  VeamImagePickerController.m
//  veam31000014
//
//  Created by veam on 1/26/16.
//
//

#import "VeamImagePickerController.h"

@interface VeamImagePickerController ()

@end

@implementation VeamImagePickerController

@synthesize shutterImageView ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"VeamImagePickerController::touchesBegan") ;
    UITouch *touch = [touches anyObject];
    if(touch.view == shutterImageView){
        //NSLog(@"shutter") ;
        [self.shutterDelegate shutterTouchesBegan];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"VeamImagePickerController::touchesEnded") ;
    UITouch *touch = [touches anyObject];
    if(touch.view == shutterImageView){
        //NSLog(@"shutter") ;
        [self.shutterDelegate shutterTouchesEnded];
    }
}



@end
