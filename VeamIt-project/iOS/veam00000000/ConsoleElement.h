//
//  ConsoleElement.h
//  veam00000000
//
//  Created by veam on 6/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsoleElement : NSObject

@property(nonatomic,retain)NSString *fileName ;
@property(nonatomic,retain)NSString *title ;
@property(nonatomic,assign)SEL selector ;
@property(nonatomic,assign)BOOL needLogin ;

- (id)initWithFileName:(NSString *)fileName title:(NSString *)title needLogin:(BOOL)needLogin selector:(SEL)selector ;

@end
