//
//  Configurations.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Configurations.h"

@implementation Configurations

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Configuration::parserDidStartDocument") ;
}


- (id)initWithResourceFile
{
    // load configurations
    NSString *configurationFilePath = [[NSBundle mainBundle] pathForResource:VEAM_CONFIGURATION_FILE_NAME ofType:nil] ;
    NSURL *configurationFileUrl = [NSURL fileURLWithPath:configurationFilePath] ;
    return [self initWithUrl:configurationFileUrl] ;
}


- (id)initWithUrl:(NSURL *)url
{
    self = [super init] ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url] ;
    [self startParsing:parser] ;
    
    return self ;
}

- (id)initWithData:(NSData *)data
{
    self = [super init] ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
    [self startParsing:parser] ;
    
    return self ;
}

- (void)startParsing:(NSXMLParser *)parser
{
    isParsing = YES ;
    dictionary = [NSMutableDictionary dictionary] ;
    
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
    NSString *value = [attributeDict objectForKey:@"value"];
    if(value != nil){
        //NSLog(@"elementName=%@ value=%@",elementName,value) ;
        [dictionary setObject:value forKey:elementName] ;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Configuration::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Configuration::parserDidEndDocument") ;
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
