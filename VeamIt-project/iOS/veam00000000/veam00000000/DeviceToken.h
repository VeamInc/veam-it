//
//  DeviceToken.h
//  veam31000006
//
//  Created by veam on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface DeviceToken : NSObject{
    NSData *token ;
}

@property (nonatomic, retain) NSData *token;

-(void)sendToProvider ;

@end
