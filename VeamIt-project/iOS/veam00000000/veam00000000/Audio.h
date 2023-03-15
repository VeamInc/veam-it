//
//  Audio.h
//  veam31000016
//
//  Created by veam on 7/16/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mixed.h"

#define VEAM_AUDIO_KIND_FAVORITES     @"FAVORITES"
#define VEAM_AUDIO_KIND_YEAR          @"0"
#define VEAM_AUDIO_KIND_MESSAGE       @"1"
#define VEAM_AUDIO_KIND_MUSIC         @"2"
#define VEAM_AUDIO_KIND_SPECIAL       @"3"

@interface Audio : NSObject

@property (nonatomic, retain) Mixed *mixed ;
@property (nonatomic, retain) NSString *audioId ;
@property (nonatomic, retain) NSString *kind ;
@property (nonatomic, retain) NSString *audioCategoryId ;
@property (nonatomic, retain) NSString *audioSubCategoryId ;
@property (nonatomic, retain) NSString *author ;
@property (nonatomic, retain) NSString *duration ;
@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *description ;
@property (nonatomic, retain) NSString *imageUrl ;
@property (nonatomic, retain) NSString *rectangleImageUrl ;
@property (nonatomic, retain) NSString *dataUrl ;
@property (nonatomic, retain) NSString *dataSize ;
@property (nonatomic, retain) NSString *linkUrl ;
@property (nonatomic, retain) NSString *createdAt ;

- (id)initWithAttributes:(NSDictionary *)attributeDict ;

/*
- (id)initWithAudioId:(NSString *)targetAudioId ;
- (void)save ;
- (void)load:(NSString *)targetAudioId ;
 */
- (NSString *)getDataFileName ;
- (NSString *)getDataFilePath ;
- (BOOL)hasCachedDataFile ;

@end
