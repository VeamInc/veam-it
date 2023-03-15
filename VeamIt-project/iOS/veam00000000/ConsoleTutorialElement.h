//
//  ConsoleTutorialElement.h
//  veam00000000
//
//  Created by veam on 2/17/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE            1
#define VEAM_CONSOLE_TUTORIAL_KIND_EXCLUSIVE_RELEASED   2
#define VEAM_CONSOLE_TUTORIAL_KIND_YOUTUBE              3
#define VEAM_CONSOLE_TUTORIAL_KIND_FORUM                4
#define VEAM_CONSOLE_TUTORIAL_KIND_FORUM_RELEASED       5
#define VEAM_CONSOLE_TUTORIAL_KIND_LINK                 6

@interface ConsoleTutorialElement : NSObject

@property(nonatomic,retain)NSString *tutorialElementId ;
@property(nonatomic,retain)NSString *title ;
@property(nonatomic,retain)NSString *description ;
@property(nonatomic,retain)NSString *imageFileName ;
@property(nonatomic,assign)NSInteger kind ;

- (id)initWithTutorialElementId:(NSString *)tutorialElementId title:(NSString *)title description:(NSString *)description imageFileName:(NSString *)imageFileName kind:(NSInteger)kind ;

@end
