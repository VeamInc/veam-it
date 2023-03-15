//
//  ConsoleStarterColorPickerViewController.m
//  veam00000000
//
//  Created by veam on 9/1/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleStarterColorPickerViewController.h"
#import "RSBrightnessSlider.h"
#import "RSOpacitySlider.h"
#import "VeamUtil.h"
#import "ConsoleIconSelectViewController.h"
#import "ConsolePostData.h"
#import "ConsoleUtil.h"


@interface ConsoleStarterColorPickerViewController ()

@end

@implementation ConsoleStarterColorPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define COLOR_PICKER_RADIUS 100

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    colorSending = NO ;

    UIImage *sliderBackImage = [UIImage imageNamed:@"color_slide_back.png"] ;
    CGFloat imageWidth = sliderBackImage.size.width / 2 ;
    CGFloat imageHeight = sliderBackImage.size.height / 2 ;
    UIImageView *sliderBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, ([VeamUtil getScreenHeight]-imageHeight)/2, imageWidth, imageHeight)] ;
    [sliderBackImageView setImage:sliderBackImage] ;
    [self.view addSubview:sliderBackImageView] ;

    
    // View that displays color picker (needs to be square)
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(
                                                                       ([VeamUtil getScreenWidth]-COLOR_PICKER_RADIUS*2)/2,
                                                                       ([VeamUtil getScreenHeight]-COLOR_PICKER_RADIUS*2)/2,
                                                                         COLOR_PICKER_RADIUS*2, COLOR_PICKER_RADIUS*2)];
    

    // View that shows selected color
    CGFloat patchRadius = 26 ;
    _colorPatch = [[UIView alloc] initWithFrame:CGRectMake(25, _colorPicker.frame.origin.y-35, patchRadius*2,patchRadius*2)] ;
    _colorPatch.layer.cornerRadius = patchRadius ;
    _colorPatch.clipsToBounds = YES ;
    [self.view addSubview:_colorPatch] ;

    [_colorPicker setShowLoupe:NO] ;
    
    // Optionally set and force the picker to only draw a circle
	[_colorPicker setCropToCircle:YES] ; // Defaults to NO (you can set BG color)
    
    // Set the selection color - useful to present when the user had picked a color previously
    [_colorPicker setSelectionColor:RSRandomColorOpaque(YES)] ;
    [_colorPicker setBrightness:1.0] ;
    
    // Set the delegate to receive events
    [_colorPicker setDelegate:self] ;
    
    [self.view addSubview:_colorPicker];
    
    
    // View that controls brightness
    _brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(177, _colorPicker.frame.origin.y+_colorPicker.frame.size.height/2-15, 235, 30.0)] ;
    //_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(0, _colorPicker.frame.origin.y+_colorPicker.frame.size.height/2-15, 233, 15.0)] ;
    [_brightnessSlider setColorPicker:_colorPicker];
    _brightnessSlider.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [_brightnessSlider setBackgroundColor:[UIColor clearColor]] ;
    
    [_brightnessSlider setMinimumValue:0.3] ;

    [self.view addSubview:_brightnessSlider] ;
    
    UIColor *color = [VeamUtil getColorFromArgbString:@"FF6D6D6D"] ;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _colorPicker.frame.origin.y - 75, [VeamUtil getScreenWidth], 30)] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter] ;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]] ;
    [titleLabel setText:@"Pickup your favorite color"] ;
    [titleLabel setTextColor:color] ;
    [titleLabel setBackgroundColor:[UIColor clearColor]] ;
    [self.view addSubview:titleLabel] ;
    
    [self showHeader:@"" backgroundColor:[VeamUtil getColorFromArgbString:@"FF1B1B1B"]] ;
    
    
    /*
    // View that controls opacity
    _opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(0 + 4, 340.0, 320 - (20 + 0), 30.0)];
    [_opacitySlider setColorPicker:_colorPicker];
    [self.view addSubview:_opacitySlider];
     */
    
    

}

#pragma mark - RSColorPickerView delegate methods

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
    
    // Get color data
    UIColor *color = [cp selectionColor];
    
    CGFloat r, g, b, a;
    [[cp selectionColor] getRed:&r green:&g blue:&b alpha:&a];
    
    // Update important UI
    _colorPatch.backgroundColor = color;
    _brightnessSlider.value = [cp brightness];
    _opacitySlider.value = [cp opacity];
    
    
    // Debug
    NSString *colorDesc = [NSString stringWithFormat:@"rgba: %f, %f, %f, %f", r, g, b, a];
    //NSLog(@"%@", colorDesc);
    int ir = r * 255;
    int ig = g * 255;
    int ib = b * 255;
    int ia = a * 255;
    colorDesc = [NSString stringWithFormat:@"rgba: %d, %d, %d, %d", ir, ig, ib, ia];
    //NSLog(@"%@", colorDesc);
    _rgbLabel.text = colorDesc;
    
    //NSLog(@"%@", NSStringFromCGPoint(cp.selection));
}

- (void)launchIconView
{
    [self hideProgress] ;
    if(self.showBackButton){
        [ConsoleUtil restartHome] ;
    } else {
        ConsoleIconSelectViewController *viewController = [[ConsoleIconSelectViewController alloc] init] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

- (void)didHeaderNextTap
{
    //NSLog(@"ConsoleStarterColorPickerViewController::didHeaderNextTap") ;
    
    if(!colorSending){
        [self showProgress] ;
        [self sendConceptColor] ;
    }
}

- (void)showProgress
{
    colorSending = YES ;
    [nextIndicator startAnimating] ;
    [nextIndicator setAlpha:1.0] ;
    
}

- (void)hideProgress
{
    colorSending = NO ;
    [nextIndicator setAlpha:0.0] ;
    [nextIndicator stopAnimating] ;
}

- (void)sendConceptColor
{
    NSString *colorString = [VeamUtil getArgbStringFromColor:_colorPicker.selectionColor] ;
    //NSLog(@"concept color:%@",colorString) ;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            colorString,@"c",
                            nil] ;
    
    ConsolePostData *postData = [[ConsolePostData alloc] init] ;
    [postData setApiName:@"app/setconceptcolor"] ;
    [postData setParams:params] ;
    [self performSelectorInBackground:@selector(doPost:) withObject:postData] ;
}

- (void)doPost:(ConsolePostData *)postData
{
    @autoreleasepool
    {
        NSArray *results = [ConsoleUtil doPost:postData] ;
        if(results != nil){
            int count = [results count] ;
            if(count > 0){
                NSString *code = [results objectAtIndex:0] ;
                if([code isEqual:@"OK"]){
                    [self performSelectorOnMainThread:@selector(launchIconView) withObject:nil waitUntilDone:NO] ;
                } else {
                    [self performSelectorOnMainThread:@selector(updateFailed:) withObject:@"Failed to update" waitUntilDone:NO] ;
                }
            }
        } else {
            [self performSelectorOnMainThread:@selector(updateFailed:) withObject:@"Failed to update" waitUntilDone:NO] ;
        }
    }
}

- (void)updateFailed:(NSString *)message
{
    //NSLog(@"updateFailed:%@",message) ;
    [VeamUtil dispError:message] ;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
