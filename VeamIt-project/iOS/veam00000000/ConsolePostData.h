//
//  ConsolePostData.h
//  veam00000000
//
//  Created by veam on 6/2/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface ConsolePostData : NSObject

@property(nonatomic,retain)NSString *apiName ;
@property(nonatomic,retain)NSDictionary *params ;
@property(nonatomic,retain)UIImage *image ;
@property(nonatomic,retain)id <HandlePostResultDelegate> handlePostResultDelegate ;


@end
