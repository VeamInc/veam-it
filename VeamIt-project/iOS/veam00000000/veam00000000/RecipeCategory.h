//
//  RecipeCategory.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeCategory : NSObject

@property (nonatomic, retain) NSString *recipeCategoryId ;
@property (nonatomic, retain) NSString *name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
