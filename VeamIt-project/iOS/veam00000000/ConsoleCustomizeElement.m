//
//  ConsoleCustomizeElement.m
//  veam00000000
//
//  Created by veam on 9/8/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleCustomizeElement.h"

@implementation ConsoleCustomizeElement

@synthesize customizeElementId ;
@synthesize title ;
@synthesize description ;
@synthesize imageFileName ;
@synthesize kind ;

- (id)initWithCustomizeElementId:(NSString *)targetCustomizeElementId title:(NSString *)targetTitle description:(NSString *)targetDescription imageFileName:(NSString *)targetImageFileName kind:(NSInteger)targetKind
{
    self = [super init] ;
    if (self != nil){
        self.customizeElementId = targetCustomizeElementId ;
        self.title = targetTitle ;
        self.description = targetDescription ;
        self.imageFileName = targetImageFileName ;
        self.kind = targetKind ;
    }
    return self ;
}

@end
