//
//  ConsoleMessageViewController.h
//  veam00000000
//
//  Created by veam on 3/3/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleViewController.h"
#import "AppCreatorMessages.h"

@interface ConsoleMessageViewController : ConsoleViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    NSInteger indexOffset ;
    NSArray *recipes ;
    NSInteger lastIndex ;
    
    AppCreatorMessages *messages ;
    UITableView *messageListTableView ;
    UIActivityIndicatorView *indicator ;
    UIActivityIndicatorView *sendIndicator ;
    
    NSInteger currentPageNo ;
    NSInteger numberOfMessages ;
    
    NSMutableDictionary *imageDownloadsInProgressForUser ;  // the set of ImageDownloader objects for each picture
    
    BOOL isUpdating ;
    BOOL isSending ;
    
    NSInteger targetSocialUserId ;
    
    
    UITextField *messageTextField ;
    UILabel *sendLabel ;
    UIActivityIndicatorView *findIndicator ;
    
    UIView *inputView ;
    CGFloat inputViewHeight ;
    NSURLConnection *conn ;
    NSMutableData *buffer ;
    
    UIImageView *blockImageView ;
    UIImage *blockOffImage ;
    UIImage *blockOnImage ;
    BOOL isBlocked ;
    BOOL isBlockSending ;
    
    NSString *creatorName ;
    NSString *mcnName ;
    
    CGRect initialTableFrame ;
    
}

@property (nonatomic, retain) NSString *socialUserId ;
@property (nonatomic, assign) NSInteger userListKind ;
@property (nonatomic, assign) NSInteger messageKind ;
@property (nonatomic, retain) NSString *userImageUrl ;



@end
