//
//  ConsoleCustomizeElement.h
//  veam00000000
//
//  Created by veam on 9/8/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VEAM_CONSOLE_CUSTOMIZE_KIND_DESIGN          1
#define VEAM_CONSOLE_CUSTOMIZE_KIND_FEATURE         2
#define VEAM_CONSOLE_CUSTOMIZE_KIND_SUBSCRIPTION    3

@interface ConsoleCustomizeElement : NSObject{
    
}

@property(nonatomic,retain)NSString *customizeElementId ;
@property(nonatomic,retain)NSString *title ;
@property(nonatomic,retain)NSString *description ;
@property(nonatomic,retain)NSString *imageFileName ;
@property(nonatomic,assign)NSInteger kind ;

- (id)initWithCustomizeElementId:(NSString *)customizeElementId title:(NSString *)title description:(NSString *)description imageFileName:(NSString *)imageFileName kind:(NSInteger)kind ;

@end
