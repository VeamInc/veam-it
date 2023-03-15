//
//  AppCreatorMessage
//  veam31000015
//
//  Created by veam on 10/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MESSAGE_KIND_MESSAGE    @"1"
#define MESSAGE_KIND_DATE       @"2"

@interface AppCreatorMessage : NSObject

@property (nonatomic, retain) NSString *appCreatorMessageId ;
@property (nonatomic, retain) NSString *appCreatorId ;
@property (nonatomic, retain) NSString *mcnId ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSString *text ;
@property (nonatomic, retain) NSString *direction ;
@property (nonatomic, retain) NSString *kind ;

@end
