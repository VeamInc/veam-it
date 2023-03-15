//
//  Pictures.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Pictures.h"
#import "Picture.h"
#import "Comment.h"

@implementation Pictures

@synthesize numberOfPicturesBetweenAds ;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Pictures::parserDidStartDocument") ;
}

- (void)setup
{
    pictures = [[NSMutableArray alloc] init] ;
    dictionary = [NSMutableDictionary dictionary] ;
    numberOfPicturesBetweenAds = 0 ;
}

- (id)init
{
    self = [super init] ;
    if(self != nil){
        [self setup] ;
    }
    return self ;
}

- (void)parseWithData:(NSData *)data
{
    isParsing = YES ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError) {
        NSLog(@"error: %@", parseError);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    //NSLog(@"elementName=%@",elementName) ;
    if([elementName isEqualToString:@"picture"]){
        Picture *picture = [[Picture alloc] init] ;
        [picture setPictureId:[attributeDict objectForKey:@"id"]] ;
        [picture setPictureUrl:[attributeDict objectForKey:@"url"]] ;
        [picture setOwnerUserId:[attributeDict objectForKey:@"user_id"]] ;
        [picture setOwnerName:[attributeDict objectForKey:@"user_name"]] ;
        [picture setOwnerIconUrl:[attributeDict objectForKey:@"user_icon_url"]] ;
        [picture setIsLike:[[attributeDict objectForKey:@"is_like"] isEqualToString:@"1"]] ;
        [picture setNumberOfLikes:[[attributeDict objectForKey:@"likes"] integerValue]] ;
        [picture setCreatedAt:[attributeDict objectForKey:@"created_at"]] ;
        NSInteger index = [self getPictureIndexForId:[picture pictureId]] ;
        if(index >= 0){
            [pictures setObject:picture atIndexedSubscript:index] ;
        } else {
            [pictures addObject:picture] ;
            if(numberOfPicturesBetweenAds > 0){
                int pictureCount = [pictures count] ;
                BOOL addAd = (((pictureCount - numberOfPicturesBetweenAds) % (numberOfPicturesBetweenAds + 1)) == 0) ;
                if(addAd){
                    Picture *adPicture = [[Picture alloc] init] ;
                    [adPicture setPictureId:@"AD"] ;
                    [adPicture setPictureUrl:@""] ;
                    [adPicture setOwnerUserId:@""] ;
                    [adPicture setOwnerName:@""] ;
                    [adPicture setOwnerIconUrl:@""] ;
                    [adPicture setIsLike:NO] ;
                    [adPicture setNumberOfLikes:0] ;
                    [adPicture setCreatedAt:@""] ;
                    [pictures addObject:adPicture] ;
                }
            }
        }
        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
    } else if([elementName isEqualToString:@"comment"]){
        Comment *comment = [[Comment alloc] init] ;
        [comment setCommentId:[attributeDict objectForKey:@"id"]] ;
        [comment setPictureId:[attributeDict objectForKey:@"picture_id"]] ;
        [comment setOwnerUserId:[attributeDict objectForKey:@"user_id"]] ;
        [comment setOwnerName:[attributeDict objectForKey:@"user_name"]] ;
        [comment setComment:[attributeDict objectForKey:@"text"]] ;
        //NSLog(@"add comment : %@ %@",[comment commentId],[comment comment]) ;
        [self addComment:comment] ;
    } else if([elementName isEqualToString:@"page"]){
        NSString *isLastPage = [attributeDict objectForKey:@"is_last_page"];
        if([isLastPage intValue] == 1){
            lastPageLoaded = YES ;
        } else {
            lastPageLoaded = NO ;
        }
    } else if([elementName isEqualToString:@"picture_like"]){
        NSString *value = [attributeDict objectForKey:@"value"];
        //NSLog(@"value=%@",value) ;
        if(value != nil){
            NSArray *likes = [value componentsSeparatedByString:@","] ;
            NSInteger count = [likes count] ;
            for(int index = 0 ; index < count ; index++){
                NSString *pictureId = [likes objectAtIndex:index] ;
                if(pictureId != nil){
                    Picture *picture = [self getPictureForId:pictureId] ;
                    if(picture != nil){
                        //NSLog(@"like %@",pictureId) ;
                        [picture setIsLike:YES] ;
                    }
                }
            }
        }
    } else {
        NSString *value = [attributeDict objectForKey:@"value"];
        if(value != nil){
            //NSLog(@"elementName=%@ value=%@",elementName,value) ;
            [dictionary setObject:value forKey:elementName] ;
        }
    }
}

- (void)addComment:(Comment *)comment
{
    Picture *picture = [self getPictureForId:[comment pictureId]] ;
    if(picture != nil){
        //NSLog(@"comment to be added : %@,%@,%@,%@,%@",[comment commentId],[comment pictureId],[comment ownerUserId],[comment ownerName],[comment comment]) ;
        NSInteger index = [picture getCommentIndexForId:[comment commentId]] ;
        if(index >= 0){
            [[picture comments] setObject:comment atIndexedSubscript:index] ;
        } else {
            [[picture comments] addObject:comment] ;
        }
    } else {
        NSLog(@"picture not found : %@",[comment pictureId]) ;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Pictures::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Pictures::parserDidEndDocument") ;
    [parser setDelegate:nil] ;
    isParsing = NO ;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (Picture *)getPictureForId:(NSString *)pictureId
{
    NSInteger count = [pictures count] ;
    Picture *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        Picture *picture = [pictures objectAtIndex:index] ;
        if([[picture pictureId] isEqualToString:pictureId]){
            retValue = picture ;
            break ;
        }
    }
    return retValue ;
}

- (NSInteger)getPictureIndexForId:(NSString *)pictureId
{
    NSInteger count = [pictures count] ;
    NSInteger retValue = -1 ;
    for(int index = 0 ; index < count ; index++){
        Picture *picture = [pictures objectAtIndex:index] ;
        if([[picture pictureId] isEqualToString:pictureId]){
            retValue = index ;
            break ;
        }
    }
    return retValue ;
}

- (NSString *)getValueForKey:(NSString *)key
{
    //NSLog(@"key=%@",key) ;
    NSString *value = [dictionary objectForKey:key] ;
    return value ;
}

- (void)setValueForKey:(NSString *)key value:(NSString *)value
{
    //NSLog(@"setValueForKey %@ %@",key,value) ;
    [dictionary setObject:value forKey:key] ;
}

- (NSInteger)getNumberOfPictures
{
    return [pictures count] ;
}

- (Picture *)getPictureAt:(NSInteger)index
{
    Picture *retValue = nil ;
    if(index < [pictures count]){
        retValue = [pictures objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)deletePicture:(Picture *)picture
{
    if(picture != nil){
        [pictures removeObject:picture] ;
    }
}

- (BOOL)noMorePictures
{
    BOOL retValue = NO ;
    if(lastPageLoaded){
        retValue = YES ;
    }
    return retValue ;
}

@end
