//
//  QuestionCellViewController.h
//  veam31000016
//
//  Created by veam on 3/4/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionCell.h"

@interface QuestionCellViewController : UIViewController
{
    IBOutlet QuestionCell *cell ;
}

@property (nonatomic, retain) QuestionCell *cell ;


@end
