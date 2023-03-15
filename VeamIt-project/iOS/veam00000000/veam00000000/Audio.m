//
//  Audio.m
//  veam31000016
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Audio.h"
#import "VeamUtil.h"

@implementation Audio

@synthesize mixed ;
@synthesize audioId ;
@synthesize kind ;
@synthesize audioCategoryId ;
@synthesize audioSubCategoryId ;
@synthesize author ;
@synthesize duration ;
@synthesize title ;
@synthesize description ;
@synthesize imageUrl ;
@synthesize rectangleImageUrl ;
@synthesize dataUrl ;
@synthesize dataSize ;
@synthesize linkUrl ;
@synthesize createdAt ;

#define AUDIO_STRING_DELIMITER @":-:"

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    self = [super init] ;
    
    [self setAudioId:[attributeDict objectForKey:@"id"]] ;
    [self setAudioCategoryId:[attributeDict objectForKey:@"c"]] ;
    [self setAudioSubCategoryId:[attributeDict objectForKey:@"s"]] ;
    [self setDuration:[attributeDict objectForKey:@"d"]] ;
    [self setTitle:[attributeDict objectForKey:@"t"]] ;
    [self setKind:[attributeDict objectForKey:@"k"]] ;
    [self setImageUrl:[attributeDict objectForKey:@"i"]] ;
    [self setRectangleImageUrl:[attributeDict objectForKey:@"ri"]] ;
    [self setDataUrl:[attributeDict objectForKey:@"v"]] ;
    [self setDataSize:[attributeDict objectForKey:@"vs"]] ;
    [self setLinkUrl:[attributeDict objectForKey:@"l"]] ;
    [self setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
    
    NSString *encodedUrl = [attributeDict objectForKey:@"bu"] ;
    if(![VeamUtil isEmpty:encodedUrl]){
        [self setDataUrl:[VeamUtil bbDecode:encodedUrl]] ;
    }
    
    mixed = [[Mixed alloc] init] ;
    [mixed setMixedId:[attributeDict objectForKey:@"mi"]] ;
    [mixed setTitle:[attributeDict objectForKey:@"t"]] ;
    [mixed setMixedCategoryId:[attributeDict objectForKey:@"mc"]] ;
    [mixed setMixedSubCategoryId:[attributeDict objectForKey:@"ms"]] ;
    [mixed setKind:[attributeDict objectForKey:@"mk"]] ;
    [mixed setThumbnailUrl:[attributeDict objectForKey:@"mt"]] ;
    [mixed setCreatedAt:[attributeDict objectForKey:@"cr"]] ;
    [mixed setContentId:self.audioId] ;
    [mixed setDisplayType:[attributeDict objectForKey:@"mdt"]] ;
    [mixed setDisplayName:[attributeDict objectForKey:@"mdn"]] ;
    
    //NSLog(@"audio created at = %@",[attributeDict objectForKey:@"cr"]) ;
    //NSLog(@"audio mixed id = %@",[attributeDict objectForKey:@"mi"]) ;
    //NSLog(@"audio mixed thumbnail = %@",[attributeDict objectForKey:@"mt"]) ;
    
    return self ;
}

/*
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithProgramId:(NSString *)targetProgramId
{
    self = [super init];
    if (self) {
        // Initialization code
        [self load:targetAudioId] ;
    }
    return self;
}

- (void)save
{
    [VeamUtil setProgramString:[self getProgramString] programId:programId] ;
}

- (void)load:(NSString *)targetProgramId
{
    NSString *programString = [VeamUtil getProgramStringForProgramId:targetProgramId] ;
    if(![VeamUtil isEmpty:programString]){
        self.programId = targetProgramId ;
        [self setProgramString:programString] ;
    }
}
- (void)setProgramString:(NSString *)programString
{
    NSArray *elements = [programString componentsSeparatedByString:PROGRAM_STRING_DELIMITER] ;
    if([elements count] >= 9){
        kind = elements[0] ;
        author = elements[1] ;
        duration = elements[2] ;
        title = elements[3] ;
        description = elements[4] ;
        smallImageUrl = elements[5] ;
        largeImageUrl = elements[6] ;
        dataUrl = elements[7] ;
        dataSize = elements[8] ;
        NSString *createdAtString = elements[9] ;
        self.createdAt = [createdAtString integerValue] ;
    }
}

- (NSString *)getProgramString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%d",
                                kind,PROGRAM_STRING_DELIMITER,
                                author,PROGRAM_STRING_DELIMITER,
                                duration,PROGRAM_STRING_DELIMITER,
                                title,PROGRAM_STRING_DELIMITER,
                                description,PROGRAM_STRING_DELIMITER,
                                smallImageUrl,PROGRAM_STRING_DELIMITER,
                                largeImageUrl,PROGRAM_STRING_DELIMITER,
                                dataUrl,PROGRAM_STRING_DELIMITER,
                                dataSize,PROGRAM_STRING_DELIMITER,
                                self.createdAt] ;

}
*/
- (NSString *)getDataFileName
{
    return [NSString stringWithFormat:@"aud%@.dat",audioId] ;
}

- (NSString *)getDataFilePath
{
    return [VeamUtil getFilePathAtCachesDirectory:[self getDataFileName]] ;
}

- (BOOL)hasCachedDataFile
{
    BOOL retValue = NO ;
    NSString *fileName = [self getDataFileName] ;
    if([VeamUtil fileExists:fileName] && ([VeamUtil fileSizeOf:fileName] == [dataSize integerValue])){
        retValue = YES ;
    }
    return retValue ;
}


@end
