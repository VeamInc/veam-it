//
//  Recipe.h
//  veam31000000
//
//  Created by veam on 7/18/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mixed.h"

@interface Recipe : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) Mixed *mixed ;
@property (nonatomic, retain) NSString *recipeId ;
@property (nonatomic, retain) NSString *recipeCategoryId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *imageUrl ;
@property (nonatomic, retain) NSString *directions ;
@property (nonatomic, retain) NSString *ingredients ;
@property (nonatomic, retain) NSString *nutrition ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
