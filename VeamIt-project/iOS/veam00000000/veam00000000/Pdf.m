//
//  Pdf.m
//  veam31000000
//
//  Created by veam on 10/6/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "Pdf.h"
#import "VeamUtil.h"

@implementation Pdf

@synthesize pdfId ;
@synthesize title ;
@synthesize kind ;
@synthesize pdfCategoryId ;
@synthesize pdfSubCategoryId ;
@synthesize imageUrl ;
@synthesize imageSize ;
@synthesize dataUrl ;
@synthesize dataSize ;
@synthesize description ;
@synthesize createdAt ;
@synthesize sourceUrl ;


- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setPdfId:[attributeDict objectForKey:@"id"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setPdfCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setPdfSubCategoryId:[attributeDict objectForKey:@"s"]] ;
    [self setImageUrl:[attributeDict objectForKey:@"i"]] ;
    [self setImageSize:[attributeDict objectForKey:@"is"]] ;
    [self setDataUrl:[attributeDict objectForKey:@"v"]] ;
    [self setDataSize:[attributeDict objectForKey:@"vs"]] ;
    [self setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
    
    NSString *encodedUrl = [attributeDict objectForKey:@"bu"] ;
    if(![VeamUtil isEmpty:encodedUrl]){
        [self setDataUrl:[VeamUtil bbDecode:encodedUrl]] ;
    }
    
    NSString *encodedToken = [attributeDict objectForKey:@"bt"] ;
    if(![VeamUtil isEmpty:encodedToken]){
        [VeamUtil setPdfToken:[VeamUtil bbDecode:encodedToken] pdfId:pdfId] ;
    }
    
    /*
     mixed = [[Mixed alloc] init] ;
     [mixed setMixedId:[attributeDict objectForKey:@"mi"]] ;
     [mixed setTitle:[attributeDict objectForKey:@"t"]] ;
     [mixed setMixedCategoryId:[attributeDict objectForKey:@"mc"]] ;
     [mixed setMixedSubCategoryId:[attributeDict objectForKey:@"ms"]] ;
     [mixed setKind:[attributeDict objectForKey:@"mk"]] ;
     [mixed setThumbnailUrl:[attributeDict objectForKey:@"mt"]] ;
     [mixed setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
     [mixed setContentId:self.videoId] ;
     [mixed setDisplayType:[attributeDict objectForKey:@"mdt"]] ;
     [mixed setDisplayName:[attributeDict objectForKey:@"mdn"]] ;
     */
    
    //NSLog(@"video created at = %@",[attributeDict objectForKey:@"cr"]) ;
    //NSLog(@"video mixed id = %@",[attributeDict objectForKey:@"mi"]) ;
    
    return self ;
}

- (void)handlePostResult:(NSArray *)results
{
    //NSLog(@"%@::handlePostResult",NSStringFromClass([self class])) ;
    if([results count] >= 3){
        //NSLog(@"count >= 3") ;
        NSString *result = [results objectAtIndex:0] ;
        if([result isEqualToString:@"OK"]){
            [self setPdfId:[results objectAtIndex:1]] ;
            //NSLog(@"set PdfId:%@",self.PdfId) ;
            //[self.mixed setMixedId:[results objectAtIndex:2]] ;
            //NSLog(@"set mixedId:%@",self.mixed.mixedId) ;
            if([results count] >= 6){
                //[self setStatus:[results objectAtIndex:3]] ;
                //NSLog(@"set status:%@",self.status) ;
                //[self setStatusText:[results objectAtIndex:4]] ;
                //NSLog(@"set statusText:%@",self.statusText) ;
                [self setImageUrl:[results objectAtIndex:5]] ;
                //NSLog(@"set imageUrl:%@",self.imageUrl) ;
            }
        }
    }
}


@end
