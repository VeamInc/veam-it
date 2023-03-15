//
//  NSDictionary+Additions.m
//  sumahodeusen
//
//  Created by veam on 2013/07/23.
//  Copyright (c) 2013年 veam All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

@implementation NSDictionary (Additions)

- (NSString*)toQueryString
{
    
    NSMutableString *s = [NSMutableString string];
    
    NSString *key;
    for ( key in self ) {
        NSString *uriEncodedValue = [[self objectForKey:key] uriEncode];
        [s appendFormat:@"%@=%@&", key, uriEncodedValue];
    }
    
    if ( [s length] > 0 ) {
        [s deleteCharactersInRange:NSMakeRange([s length]-1, 1)];
    }
    return s;
}

@end
