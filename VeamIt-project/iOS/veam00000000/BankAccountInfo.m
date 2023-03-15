//
//  BankAccountInfo.m
//  veam00000000
//
//  Created by veam on 2/20/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "BankAccountInfo.h"
#import "VeamUtil.h"

@implementation BankAccountInfo

@synthesize bankAccountId ;
@synthesize routingNumber ;
@synthesize accountNumber ;
@synthesize accountName ;
@synthesize accountType ;
@synthesize streetAddress ;
@synthesize city ;
@synthesize state ;
@synthesize zipCode ;

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setBankAccountId:[attributeDict objectForKey:@"id"]] ;
    [self setRoutingNumber:[attributeDict objectForKey:@"r"]] ;
    [self setAccountNumber:[attributeDict objectForKey:@"nu"]] ;
    [self setAccountName:[attributeDict objectForKey:@"na"]] ;
    [self setAccountType:[attributeDict objectForKey:@"ty"]] ;
    [self setStreetAddress:[attributeDict objectForKey:@"a"]] ;
    [self setCity:[attributeDict objectForKey:@"c"]] ;
    [self setState:[attributeDict objectForKey:@"s"]] ;
    [self setZipCode:[attributeDict objectForKey:@"z"]] ;
    
    return self ;
}

- (BOOL)isCompleted
{
    return (
        ![VeamUtil isEmpty:routingNumber] &&
        ![VeamUtil isEmpty:accountNumber] &&
        ![VeamUtil isEmpty:accountName] &&
        ![VeamUtil isEmpty:accountType] &&
        ![VeamUtil isEmpty:streetAddress] &&
        ![VeamUtil isEmpty:city] &&
        ![VeamUtil isEmpty:state] &&
        ![VeamUtil isEmpty:zipCode]
          ) ;
}


- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 10){
        //NSLog(@"count >= 10") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setBankAccountId:[results objectAtIndex:1]] ;
            [self setRoutingNumber:[results objectAtIndex:2]] ;
            [self setAccountNumber:[results objectAtIndex:3]] ;
            [self setAccountName:[results objectAtIndex:4]] ;
            [self setAccountType:[results objectAtIndex:5]] ;
            [self setStreetAddress:[results objectAtIndex:6]] ;
            [self setCity:[results objectAtIndex:7]] ;
            [self setState:[results objectAtIndex:8]] ;
            [self setZipCode:[results objectAtIndex:9]] ;
        }
    }
}

@end
