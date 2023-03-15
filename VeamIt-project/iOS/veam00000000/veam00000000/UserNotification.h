//
//  UserNotification.h
//  veam31000015
//
//  Created by veam on 11/7/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_NOTIFICATION_KIND_MESSAGE          @"1"
#define USER_NOTIFICATION_KIND_FOLLOW           @"2"
#define USER_NOTIFICATION_KIND_LIKE_PICTURE     @"3"
#define USER_NOTIFICATION_KIND_COMMENT_PICTURE  @"4"


@interface UserNotification : NSObject

@property (nonatomic, retain) NSString *userNotificationId ;
@property (nonatomic, retain) NSString *fromUserId ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSString *message ;
@property (nonatomic, retain) NSString *text ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *readFlag ;
@property (nonatomic, retain) NSString *pictureId ;

@end
