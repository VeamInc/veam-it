//
//  Follows.m
//  veam31000000
//
//  Created by veam on 2/10/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "Follows.h"

@implementation Follows

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Follows::parserDidStartDocument") ;
}

- (void)setup
{
    follows = [[NSMutableArray alloc] init] ;
    dictionary = [NSMutableDictionary dictionary] ;
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
    if([elementName isEqualToString:@"user"]){
        Follow *follow = [[Follow alloc] init] ;
        [follow setSocialUserId:[attributeDict objectForKey:@"id"]] ;
        [follow setName:[attributeDict objectForKey:@"n"]] ;
        [follow setImageUrl:[attributeDict objectForKey:@"u"]] ;

        [follows addObject:follow] ;
        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
    } else if([elementName isEqualToString:@"page"]){
        NSString *isLastPage = [attributeDict objectForKey:@"is_last_page"];
        if([isLastPage intValue] == 1){
            lastPageLoaded = YES ;
        } else {
            lastPageLoaded = NO ;
        }
    } else {
        NSString *value = [attributeDict objectForKey:@"value"];
        if(value != nil){
            //NSLog(@"elementName=%@ value=%@",elementName,value) ;
            [dictionary setObject:value forKey:elementName] ;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Follows::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Follows::parserDidEndDocument") ;
    [parser setDelegate:nil] ;
    isParsing = NO ;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (Follow *)getFollowForId:(NSString *)socialUserId
{
    NSInteger count = [follows count] ;
    Follow *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        Follow *follow = [follows objectAtIndex:index] ;
        if([[follow socialUserId] isEqualToString:socialUserId]){
            retValue = follow ;
            break ;
        }
    }
    return retValue ;
}

- (NSInteger)getFollowIndexForId:(NSString *)socialUserId
{
    NSInteger count = [follows count] ;
    NSInteger retValue = -1 ;
    for(int index = 0 ; index < count ; index++){
        Follow *follow = [follows objectAtIndex:index] ;
        if([[follow socialUserId] isEqualToString:socialUserId]){
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

- (NSInteger)getNumberOfFollows
{
    return [follows count] ;
}

- (Follow *)getFollowAt:(NSInteger)index
{
    Follow *retValue = nil ;
    if(index < [follows count]){
        retValue = [follows objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)deleteFollow:(Follow *)follow
{
    if(follow != nil){
        [follows removeObject:follow] ;
    }
}

- (BOOL)noMoreFollows
{
    BOOL retValue = NO ;
    if(lastPageLoaded){
        retValue = YES ;
    }
    return retValue ;
}

@end

