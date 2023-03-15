//
//  AudioData.m
//  veam31000016
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "AudioData.h"
#import "AudioComment.h"
#import "VeamUtil.h"

@implementation AudioData

@synthesize contentVideoId ;
@synthesize isLike ;
@synthesize numberOfLikes ;
@synthesize comments ;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Pictures::parserDidStartDocument") ;
}

- (void)setup
{
    dictionary = [NSMutableDictionary dictionary] ;
    comments = [[NSMutableArray alloc] init] ;
    isLike = NO ;
    numberOfLikes = 0 ;
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
    // <?xml version="1.0" encoding="UTF-8"?><list>
    // <youtube id="496" like="0" />
    // <comment id="1" user_id="6" user_name="veam03" text="hoge" />
    // <check value="OK" /></list>
    if([elementName isEqualToString:@"audio"]){
        contentVideoId = [attributeDict objectForKey:@"id"] ;
        NSString *likeString = [attributeDict objectForKey:@"like"] ;
        numberOfLikes = [likeString integerValue] ;
        //NSLog(@"number of likes : %d",numberOfLikes) ;
    } else if([elementName isEqualToString:@"comment"]){
        AudioComment *comment = [[AudioComment alloc] init] ;
        [comment setCommentId:[attributeDict objectForKey:@"id"]] ;
        [comment setOwnerUserId:[attributeDict objectForKey:@"user_id"]] ;
        [comment setOwnerName:[attributeDict objectForKey:@"user_name"]] ;
        [comment setComment:[attributeDict objectForKey:@"text"]] ;
        //NSLog(@"add comment : %@ %@",[comment commentId],[comment comment]) ;
        [self addComment:comment] ;
    } else if([elementName isEqualToString:@"audio_like"]){
        NSString *value = [attributeDict objectForKey:@"value"];
        //NSLog(@"audio_like value=%@",value) ;
        if(value != nil){
            NSArray *likes = [value componentsSeparatedByString:@","] ;
            NSInteger count = [likes count] ;
            for(int index = 0 ; index < count ; index++){
                NSString *likeId = [likes objectAtIndex:index] ;
                if(![VeamUtil isEmpty:likeId]){
                    if([likeId isEqualToString:contentVideoId]){
                        isLike = YES ;
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

- (void)addComment:(AudioComment *)comment
{
    //NSLog(@"comment to be added : %@,%@,%@,%@,%@",[comment commentId],[comment pictureId],[comment ownerUserId],[comment ownerName],[comment comment]) ;
    NSInteger index = [self getCommentIndexForId:[comment commentId]] ;
    if(index >= 0){
        [comments setObject:comment atIndexedSubscript:index] ;
    } else {
        [comments addObject:comment] ;
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

- (NSInteger)getNumberOfComments
{
    return [comments count] ;
}

- (AudioComment *)getCommentAt:(NSInteger)index
{
    AudioComment *retValue = nil ;
    if(index < [comments count]){
        retValue = [comments objectAtIndex:index] ;
    }
    return retValue ;
}

- (NSInteger)getCommentIndexForId:(NSString *)commentId
{
    NSInteger retValue = -1 ;
    NSInteger count = [comments count] ;
    for(int index = 0 ; index < count ; index++){
        AudioComment *comment = [comments objectAtIndex:index] ;
        if([[comment commentId] isEqualToString:commentId]){
            retValue = index ;
            break ;
        }
    }
    return retValue ;
}



@end
