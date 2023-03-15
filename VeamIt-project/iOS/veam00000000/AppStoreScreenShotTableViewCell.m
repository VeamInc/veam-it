//
//  AppStoreScreenShotTableViewCell.m
//  ColorPickerTest
//
//  Created by veam on 8/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppStoreScreenShotTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "VeamUtil.h"

@implementation AppStoreScreenShotTableViewCell

@synthesize screenShotImageViews ;
@synthesize loadIndicators ;
@synthesize uploadImageViews ;
@synthesize uploadIndicators ;

#define SS_NUMBER_OF_SCREEN_SHOTS       5
#define SS_IMAGE_WIDTH                  195
#define SS_IMAGE_HEIGHT                 346
#define SS_GAP                          15

#define SS_CELL_HEIGHT                  380



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        screenShotImageViews = [NSMutableArray array] ;
        uploadImageViews = [NSMutableArray array] ;
        loadIndicators = [NSMutableArray array] ;
        uploadIndicators = [NSMutableArray array] ;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], SS_CELL_HEIGHT)] ;
        self.scrollView.backgroundColor = [UIColor clearColor] ;
        
        UIImage *uploadImage = [UIImage imageNamed:@"c_upload_image"] ;
        CGFloat uploadImageWidth = uploadImage.size.width / 2 ;
        CGFloat uploadImageHeight = uploadImage.size.height / 2 ;
        
        for(int index = 0 ; index < SS_NUMBER_OF_SCREEN_SHOTS ; index++){
            CGFloat imageX = (SS_IMAGE_WIDTH + SS_GAP) * index + SS_GAP ;
            CGRect imageFrame = CGRectMake(imageX, SS_GAP, SS_IMAGE_WIDTH, SS_IMAGE_HEIGHT) ;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame] ;
            [imageView setBackgroundColor:[UIColor whiteColor]] ;
            imageView.layer.borderColor = [VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR].CGColor ;
            imageView.layer.borderWidth = 0.5 ;
            [screenShotImageViews addObject:imageView] ;
            [self.scrollView addSubview:imageView] ;
            
            
            UIActivityIndicatorView *loadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
            [loadIndicator setCenter:imageView.center] ;
            [self.scrollView addSubview:loadIndicator] ;
            [loadIndicator setHidden:YES] ;
            [loadIndicator stopAnimating] ;
            [loadIndicators addObject:loadIndicator] ;

            /*
            CGRect uploadImageFrame = CGRectMake(imageX+SS_IMAGE_WIDTH-uploadImageWidth, SS_GAP+SS_IMAGE_HEIGHT-uploadImageHeight, uploadImageWidth, uploadImageHeight) ;
            UIImageView *uploadImageView = [[UIImageView alloc] initWithFrame:uploadImageFrame] ;
            [uploadImageView setImage:uploadImage] ;
            [uploadImageViews addObject:uploadImageView] ;
            [self.scrollView addSubview:uploadImageView] ;
            
            UIActivityIndicatorView *uploadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
            [uploadIndicator setCenter:uploadImageView.center] ;
            [self.scrollView addSubview:uploadIndicator] ;
            [uploadIndicator setHidden:YES] ;
            [uploadIndicator stopAnimating] ;
            [uploadIndicators addObject:uploadIndicator] ;
             */

        }
        
        self.scrollView.contentSize = CGSizeMake(SS_NUMBER_OF_SCREEN_SHOTS*(SS_IMAGE_WIDTH + SS_GAP) + SS_GAP, SS_IMAGE_HEIGHT+SS_GAP*2) ;
        [self.contentView addSubview:self.scrollView] ;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(CONSOLE_TABLE_SEPARATOR_MARGIN, [AppStoreScreenShotTableViewCell getCellHeight]-1, [VeamUtil getScreenWidth]-CONSOLE_TABLE_SEPARATOR_MARGIN, 0.5)] ;
        [separatorView setBackgroundColor:[VeamUtil getColorFromArgbString:CONSOLE_TABLE_SEPARATOR_COLOR]] ;
        [self.contentView addSubview:separatorView] ;
        
        UIActivityIndicatorView *loadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
        [self.contentView addSubview:loadIndicator] ;

    }
    return self;
}

+ (CGFloat)getCellHeight
{
    return SS_IMAGE_HEIGHT+SS_GAP*2 ;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
