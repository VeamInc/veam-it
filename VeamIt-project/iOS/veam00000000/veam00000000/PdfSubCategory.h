//
//  PdfSubCategory.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HandlePostResultDelegate.h"

@interface PdfSubCategory : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *pdfSubCategoryId ;
@property (nonatomic, retain) NSString *pdfCategoryId ;
@property (nonatomic, retain) NSString *name ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
