//
//  PostQuestionViewController.h
//  veam31000016
//
//  Created by veam on 4/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"

@interface PostQuestionViewController : VeamViewController
{
    UITextView *commentTextView ;
    UIActivityIndicatorView *indicator ;
    BOOL isPosting ;
    NSURLConnection *conn ;
    NSMutableData *buffer ;
    UILabel *postLabel ;
}

@end
