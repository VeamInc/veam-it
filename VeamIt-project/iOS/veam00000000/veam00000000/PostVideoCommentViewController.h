//
//  PostVideoCommentViewController.h
//  veam31000016
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "VeamViewController.h"

@interface PostVideoCommentViewController : VeamViewController
{
    UITextView *commentTextView ;
    UIActivityIndicatorView *indicator ;
    BOOL isPosting ;
    NSURLConnection *conn ;
    NSMutableData *buffer ;
    UILabel *postLabel ;
}

@property (nonatomic, retain) NSString *videoId ;

@end
