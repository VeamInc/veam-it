//
//  MovieAnnotations.h
//  veam31000000
//
//  Created by veam on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@interface MovieAnnotations : NSObject {
    NSString *mObjectId ;
    NSInteger mStreamNo ;
    
    NSInteger mAnnotationCount ; 
    NSMutableArray *mStartTimes ;
    NSMutableArray *mEndTimes ;
    NSMutableArray *mAnnotations ;
    NSInteger mPreviousIndex ;
    
}

- (id)initWithObjectId:(NSString *)objectId streamNo:(NSInteger)streamNo ;
-(NSString *)getAnnotationString:(NSTimeInterval)currentTime ;


@end
