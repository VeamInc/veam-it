//
//  ConsoleElement.m
//  veam00000000
//
//  Created by veam on 6/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleElement.h"

@implementation ConsoleElement

@synthesize fileName ;
@synthesize title ;
@synthesize needLogin ;
@synthesize selector ;

- (id)initWithFileName:(NSString *)fileName title:(NSString *)title needLogin:(BOOL)needLogin selector:(SEL)selector
{
    self = [super init] ;
    if (self != nil){
        self.fileName = fileName ;
        self.title = title ;
        self.needLogin = needLogin ;
        self.selector = selector ;
    }
    return self ;
}

@end
