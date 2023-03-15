//
//  Pdf.h
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandlePostResultDelegate.h"
#import "Mixed.h"

@interface Pdf : NSObject <HandlePostResultDelegate>

@property (nonatomic, retain) NSString *pdfId ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *pdfCategoryId ;
@property (nonatomic, retain) NSString *pdfSubCategoryId ;
@property (nonatomic, retain) NSString *imageUrl ;
@property (nonatomic, retain) NSString *imageSize ;
@property (nonatomic, retain) NSString *dataUrl ;
@property (nonatomic, retain) NSString *dataSize ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *createdAt ;
@property (nonatomic, retain) NSString *sourceUrl ;


- (id)initWithAttributes:(NSDictionary *)attributeDict ;

@end
