//
//  BankAccountInfo.h
//  veam00000000
//
//  Created by veam on 2/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"

@interface BankAccountInfo : NSObject<HandlePostResultDelegate>

@property (nonatomic, retain) NSString *bankAccountId ;
@property (nonatomic, retain) NSString *routingNumber ;
@property (nonatomic, retain) NSString *accountNumber ;
@property (nonatomic, retain) NSString *accountName ;
@property (nonatomic, retain) NSString *accountType ;
@property (nonatomic, retain) NSString *streetAddress ;
@property (nonatomic, retain) NSString *city ;
@property (nonatomic, retain) NSString *state ;
@property (nonatomic, retain) NSString *zipCode ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

- (BOOL)isCompleted ;



@end
