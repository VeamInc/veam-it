//
//  DRMMPMoviePlayerControllerCustom.m
//  VEAM
//
//  Created by veam on 11/12/04.
//  Copyright (c) 2011年 veam Corporation. All rights reserved.
//

#import "DRMMPMoviePlayerControllerCustom.h"

@implementation DRMMPMoviePlayerControllerCustom

- (BOOL)isControlsVisible
{    
    BOOL isControlsVisible_ = NO;
    
    for(id views in [[self view] subviews]){
        
        for(id subViews in [views subviews]){
            
            for (id controlView in [subViews subviews]){
                
                isControlsVisible_ = ([controlView alpha] <= 0.0) ? (NO) : (YES);
                
            }
            
        }
        
    }
    
    return isControlsVisible_;
}



@end
