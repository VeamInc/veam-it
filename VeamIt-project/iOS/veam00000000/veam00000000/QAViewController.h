//
//  QAViewController.h
//  veam31000016
//
//  Created by veam on 4/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeamViewController.h"
#import "Questions.h"
#import "PreviewDownloader.h"


@interface QAViewController : VeamViewController<UITableViewDelegate,UITableViewDataSource>
{
    Questions *questions ;
    NSInteger currentPageNo ;
    NSInteger numberOfQuestions ;
    UIActivityIndicatorView *indicator ;

    UITableView *qaListTableView ;
    NSInteger indexOffset ;
    NSInteger lastIndex ;
    
    NSInteger currentKind ;
    
    BOOL isUpdating ;
    BOOL isLikeSending ;
    BOOL needUpdate ;
    
    CGFloat originalY ;
    
    UIView *notificationView ;
    UILabel *instructionLabel ;
    UILabel *updatingLabel ;
    UIActivityIndicatorView *notificationIndicator ;
    
    UIImage *likeOffImage ;
    UIImage *likeOnImage ;
    UIImage *videoOffImage ;
    UIImage *videoOnImage ;
    UIImage *audioOnImage ;
    
    NSInteger pendingOperation ;
    NSInteger pendingTag ;
    
    Question *currentQuestion ;
    Video *currentVideo ;
    
    PreviewDownloader *previewDownloader ;
    
    UIView *sectionHeaderView ;
    UIImageView *voteButtonImageView ;
    UIImageView *rankingButtonImageView ;
    UIImageView *answerButtonImageView ;
    UILabel *voteButtonLabel ;
    UILabel *rankingButtonLabel ;
    UILabel *answerButtonLabel ;
    UIImage *voteButtonOnImage ;
    UIImage *rankingButtonOnImage ;
    UIImage *answerButtonOnImage ;
    UIImage *voteButtonOffImage ;
    UIImage *rankingButtonOffImage ;
    UIImage *answerButtonOffImage ;
    
    BOOL sectionHeaderMasked ;
    
    BOOL isBought ;
    
}

@end
