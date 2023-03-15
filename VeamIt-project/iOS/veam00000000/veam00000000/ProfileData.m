//
//  Pictures.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ProfileData.h"

@implementation ProfileData

@synthesize socialUserId ;
@synthesize name ;
@synthesize description ;
@synthesize imageUrl ;
@synthesize numberOfPosts ;
@synthesize numberOfFollowers ;
@synthesize numberOfFollowings ;
@synthesize isFollowing ;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Pictures::parserDidStartDocument") ;
}

- (void)setup
{
    dictionary = [NSMutableDictionary dictionary] ;
    isFollowing = NO ;
    numberOfPosts = 0 ;
    numberOfFollowers = 0 ;
    numberOfFollowings = 0 ;
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
    if([elementName isEqualToString:@"profile"]){
        socialUserId = [attributeDict objectForKey:@"id"] ;
        name = [attributeDict objectForKey:@"n"] ;
        description = [attributeDict objectForKey:@"d"] ;
        imageUrl = [attributeDict objectForKey:@"u"] ;
        NSString *postsString = [attributeDict objectForKey:@"p"] ;
        numberOfPosts = [postsString integerValue] ;
        NSString *followersString = [attributeDict objectForKey:@"fers"] ;
        numberOfFollowers = [followersString integerValue] ;
        NSString *followingsString = [attributeDict objectForKey:@"fing"] ;
        numberOfFollowings = [followingsString integerValue] ;


        //NSLog(@"number of likes : %d",numberOfLikes) ;
    } else if([elementName isEqualToString:@"following"]){
        NSString *isFollowingString = [attributeDict objectForKey:@"value"] ;
        if([isFollowingString isEqualToString:@"1"]){
            self.isFollowing = YES ;
        } else {
            self.isFollowing = NO ;
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



@end
