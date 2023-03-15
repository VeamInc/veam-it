//
//  ConsoleDropboxViewController.h
//  veam00000000
//
//  Created by veam on 9/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@protocol ConsoleDropboxViewControllerDelegate ;

#define DROPBOX_VIDEO_EXTENSIONS    @"mov,mp4,mpg,m4v,mts,wmv"
#define DROPBOX_AUDIO_EXTENSIONS    @"aac,mp3,m4a"
#define DROPBOX_IMAGE_EXTENSIONS    @"jpg,png"
#define DROPBOX_PDF_EXTENSIONS      @"pdf"

@interface ConsoleDropboxViewController : ConsoleViewController
{
    DBMetadata *currentMetadata ;
    UIActivityIndicatorView *indicator ;
    NSInteger numberOfContents ;
    NSInteger selectedIndex ;
    BOOL urlFetching ;
}

@property (nonatomic, weak) id <ConsoleDropboxViewControllerDelegate> delegate ;
@property (nonatomic, retain) UIViewController *returnViewController ;
@property (nonatomic, retain) NSString *dropboxPath ;
@property (nonatomic, retain) DBRestClient *restClient ;

@property (nonatomic, retain) NSString *extensions ;

@end

@protocol ConsoleDropboxViewControllerDelegate
- (void)didFetchDropboxFileUrl:(NSString *)url ;
@end

