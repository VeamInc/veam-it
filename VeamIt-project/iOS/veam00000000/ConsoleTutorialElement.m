//
//  ConsoleTutorialElement.m
//  veam00000000
//
//  Created by veam on 2/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleTutorialElement.h"

@implementation ConsoleTutorialElement

@synthesize tutorialElementId ;
@synthesize title ;
@synthesize description ;
@synthesize imageFileName ;
@synthesize kind ;

- (id)initWithTutorialElementId:(NSString *)targetTutorialElementId title:(NSString *)targetTitle description:(NSString *)targetDescription imageFileName:(NSString *)targetImageFileName kind:(NSInteger)targetKind
{
    self = [super init] ;
    if (self != nil){
        self.tutorialElementId = targetTutorialElementId ;
        self.title = targetTitle ;
        self.description = targetDescription ;
        self.imageFileName = targetImageFileName ;
        self.kind = targetKind ;
    }
    return self ;
}

@end
