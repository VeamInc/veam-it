//
//  SellSectionItem.h
//  veam00000000
//
//  Created by veam on 11/25/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellSectionItem : NSObject

@property (nonatomic, retain) NSString *sellSectionItemId ;
@property (nonatomic, retain) NSString *sellSectionCategoryId ;
@property (nonatomic, retain) NSString *sellSectionSubCategoryId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *contentId ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSString *status ;
@property (nonatomic, retain) NSString *statusText ;

- (NSString *)getKindString ;
- (NSString *) getDurationString ;
- (NSString *)getImageUrl ;

@end
