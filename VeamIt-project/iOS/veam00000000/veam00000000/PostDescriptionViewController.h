//
//  PostDescriptionViewController.h
//  veam31000000
//
//  Created by veam on 2/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"

@interface PostDescriptionViewController : VeamViewController
{
    UITextView *commentTextView ;
    UIActivityIndicatorView *indicator ;
    BOOL isPosting ;
    NSURLConnection *conn ;
    NSMutableData *buffer ;
    UILabel *postLabel ;
}

@property (nonatomic, retain) NSString *defaultDescription ;

@end
