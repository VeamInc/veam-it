//
//  MovieAnnotations.m
//  veam31000000
//
//  Created by veam on 3/6/13.
//
//

#import "MovieAnnotations.h"

@implementation MovieAnnotations


- (id)initWithObjectId:(NSString *)objectId streamNo:(NSInteger)streamNo
{
    self = [super init];
    if (self) {
        // Custom initialization
        mObjectId = objectId ;
        mStreamNo = streamNo ;
        mPreviousIndex = -1 ;
        /*
        NSString *keyString = [NSString stringWithFormat:@"annotation_count_%d",streamNo] ;
        mAnnotationCount = [[VEAMUtil getExtraDataFor:objectId named:keyString] integerValue] ;
        //NSLog(@"annotation count %@ %d",keyString,mAnnotationCount) ;
        if(mAnnotationCount > 0){
            mStartTimes = [NSMutableArray arrayWithCapacity:mAnnotationCount] ;
            mEndTimes = [NSMutableArray arrayWithCapacity:mAnnotationCount] ;
            mAnnotations = [NSMutableArray arrayWithCapacity:mAnnotationCount] ;
            for(int index = 0 ; index < mAnnotationCount ; index++){
                NSString *annotationInfo = [VEAMUtil getExtraDataFor:objectId named:[NSString stringWithFormat:@"annotation_info_%d_%d",streamNo,index]] ;
                //NSLog(@"annotationInfo %d : %@",index,annotationInfo) ;
                NSRange commaRange1 = [annotationInfo rangeOfString:@","] ;
                if(commaRange1.location != NSNotFound){
                    NSRange aRange ;
                    aRange.location = 0 ;
                    aRange.length = commaRange1.location ;
                    NSNumber *startTime = [NSNumber numberWithInt:[[annotationInfo substringWithRange:aRange] intValue]] ;
                    aRange.location = commaRange1.location + 1 ;
                    aRange.length = [annotationInfo length] - commaRange1.location - 1 ;
                    NSRange commaRange2 = [annotationInfo rangeOfString:@"," options:NSCaseInsensitiveSearch range:aRange] ;
                    if(commaRange2.location != NSNotFound){
                        aRange.location = commaRange1.location + 1 ;
                        aRange.length = commaRange2.location - commaRange1.location - 1 ;
                        NSNumber *endTime = [NSNumber numberWithInt:[[annotationInfo substringWithRange:aRange] intValue]] ;
                        
                        aRange.location = commaRange2.location + 1 ;
                        aRange.length = [annotationInfo length] - commaRange2.location - 1 ;
                        NSString *annotationString = [annotationInfo substringWithRange:aRange] ;
                        if(annotationString == nil){
                            annotationString = @" " ;
                        }
                        
                        [mStartTimes insertObject:startTime atIndex:index] ;
                        [mEndTimes insertObject:endTime atIndex:index] ;
                        [mAnnotations insertObject:annotationString atIndex:index] ;
                        
                        //NSLog(@"set annotation %d-%d:%@",[startTime intValue],[endTime intValue],annotationString) ;
                    }
                }
            }
        } else {
            mStartTimes = nil ;
            mEndTimes = nil ;
            mAnnotations = nil ;
        }
         */
        
    }
    return self;
}

-(NSString *)getAnnotationString:(NSTimeInterval)currentTime
{
    
    //NSLog(@"search for %f",currentTime) ;
    NSInteger currentTimeInt = (NSInteger)(currentTime * 1000) ;
    NSString *retString = nil ;
    
    NSInteger annotationIndex = -1 ;
    for(int index = 0 ; index < mAnnotationCount ; index++){
        NSInteger startTime = [[mStartTimes objectAtIndex:index] integerValue] ;
        NSInteger endTime = [[mEndTimes objectAtIndex:index] integerValue] ;
        //NSLog(@"%d %d %d",startTime,currentTimeInt,endTime) ;
        if((startTime <= currentTimeInt) && (currentTimeInt <= endTime)){
            annotationIndex = index ;
            break ;
        }
    }

    if(mPreviousIndex != annotationIndex){
        if(annotationIndex == -1){
            retString = @"" ;
        } else {
            retString = [mAnnotations objectAtIndex:annotationIndex] ;
        }
    }
    mPreviousIndex = annotationIndex ;
    
    return retString ;
}

@end
