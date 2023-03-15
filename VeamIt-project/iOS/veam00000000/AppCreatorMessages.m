//
//  AppCreatorMessages.m
//  veam31000015
//
//  Created by veam on 10/28/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "AppCreatorMessages.h"
#import "VeamUtil.h"

@implementation AppCreatorMessages

@synthesize appCreatorName ;
@synthesize mcnName ;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Messages::parserDidStartDocument") ;
}

- (void)setup
{
    messages = [[NSMutableArray alloc] init] ;
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

- (void)parseWithData:(NSData *)data generateDateElement:(BOOL)generate ;
{
    isParsing = YES ;
    shouldGenerateDateElement = generate ;
    
    latestAddCount = 0 ;
    
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
    if([elementName isEqualToString:@"message"]){
        AppCreatorMessage *message = [[AppCreatorMessage alloc] init] ;
        [message setAppCreatorMessageId:[attributeDict objectForKey:@"id"]] ;
        [message setAppCreatorId:[attributeDict objectForKey:@"cid"]] ;
        [message setMcnId:[attributeDict objectForKey:@"mid"]] ;
        [message setCreatedAt:[attributeDict objectForKey:@"c"]] ;
        [message setText:[attributeDict objectForKey:@"t"]] ;
        [message setDirection:[attributeDict objectForKey:@"d"]] ;
        [message setKind:MESSAGE_KIND_MESSAGE] ;
        
        if(shouldGenerateDateElement){
            NSString *dateString = [VeamUtil getMessageDateString:message.createdAt] ;
            if(![dateString isEqualToString:previousDateString]){
                if(previousDateString != nil){
                    AppCreatorMessage *dateMessage = [[AppCreatorMessage alloc] init] ;
                    [dateMessage setAppCreatorMessageId:previousDateString] ;
                    [dateMessage setAppCreatorId:@"0"] ;
                    [dateMessage setMcnId:@"0"] ;
                    [dateMessage setCreatedAt:message.createdAt] ;
                    [dateMessage setText:previousDateString] ;
                    [dateMessage setKind:MESSAGE_KIND_DATE] ;
                    [messages insertObject:dateMessage atIndex:0] ;
                    latestAddCount++ ;
                }
                
                previousDateString = dateString ;
            }
            [messages insertObject:message atIndex:0] ;
        } else {
            [messages addObject:message] ;
        }

        //[messages addObject:message] ;
        latestAddCount++ ;
        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
    } else if([elementName isEqualToString:@"user_name"]){
        appCreatorName = [attributeDict objectForKey:@"creator"] ;
        mcnName = [attributeDict objectForKey:@"mcn"] ;
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
    //NSLog(@"Messages::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Messages::parserDidEndDocument") ;
    if(previousDateString != nil){
        AppCreatorMessage *dateMessage = [[AppCreatorMessage alloc] init] ;
        [dateMessage setAppCreatorMessageId:previousDateString] ;
        [dateMessage setAppCreatorId:@"0"] ;
        [dateMessage setMcnId:@"0"] ;
        [dateMessage setCreatedAt:@"0"] ;
        [dateMessage setText:previousDateString] ;
        [dateMessage setKind:MESSAGE_KIND_DATE] ;
        [messages insertObject:dateMessage atIndex:0] ;
        latestAddCount++ ;
    }

    [parser setDelegate:nil] ;
    isParsing = NO ;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (AppCreatorMessage *)getMessageForId:(NSString *)messageId
{
    NSInteger count = [messages count] ;
    AppCreatorMessage *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        AppCreatorMessage *message = [messages objectAtIndex:index] ;
        if([[message appCreatorMessageId] isEqualToString:messageId]){
            retValue = message ;
            break ;
        }
    }
    return retValue ;
}

- (NSInteger)getMessageIndexForId:(NSString *)messageId
{
    NSInteger count = [messages count] ;
    NSInteger retValue = -1 ;
    for(int index = 0 ; index < count ; index++){
        AppCreatorMessage *message = [messages objectAtIndex:index] ;
        if([[message appCreatorMessageId] isEqualToString:messageId]){
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

- (NSInteger)getNumberOfMessages
{
    return [messages count] ;
}

- (AppCreatorMessage *)getMessageAt:(NSInteger)index
{
    AppCreatorMessage *retValue = nil ;
    if(index < [messages count]){
        retValue = [messages objectAtIndex:index] ;
    }
    return retValue ;
}

- (void)deleteMessage:(AppCreatorMessage *)message
{
    if(message != nil){
        [messages removeObject:message] ;
    }
}

- (BOOL)noMoreMessages
{
    BOOL retValue = NO ;
    if(lastPageLoaded){
        retValue = YES ;
    }
    return retValue ;
}

- (NSInteger)getLatestAddCount
{
    return latestAddCount ;
}

- (BOOL)isBlocked
{
    BOOL retValue = NO ;
    NSString *blockedValue = [self getValueForKey:MESSAGES_KEY_IS_BLOCKED] ;
    if(![VeamUtil isEmpty:blockedValue] && [blockedValue isEqual:@"1"]){
        retValue = YES ;
    }
    return retValue ;
}

@end

