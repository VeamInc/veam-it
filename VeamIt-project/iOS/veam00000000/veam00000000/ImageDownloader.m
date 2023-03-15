//
//  ImageDownloader.m
//  veam31000000
//
//  Created by veam on 7/11/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "ImageDownloader.h"
#import "VeamUtil.h"

@implementation ImageDownloader

@synthesize pictureImage;
@synthesize pictureUrl ;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize imageIndex ;

#pragma mark

- (void)finishLoading
{
    ////NSLog(@"finishLoading") ;
    // call our delegate and tell it that our icon is ready for display
    [delegate imageDidLoad:self.indexPathInTableView imageIndex:self.imageIndex] ;
}

- (void)startDownload
{
    //NSLog(@"startDownload %@",pictureUrl) ;
    UIImage *image = [VeamUtil getCachedImage:pictureUrl downloadIfNot:NO] ;
    if(image == nil){
        self.activeDownload = [NSMutableData data] ;
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                 [NSURLRequest requestWithURL:[NSURL URLWithString:[VeamUtil getSecureUrl:pictureUrl]]] delegate:self startImmediately:NO] ;
        [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes] ;
        [conn start];
        self.imageConnection = conn;
    } else {
        //NSLog(@"cache file found %fx%f index=%d",image.size.width,image.size.height,indexPathInTableView.row) ;
        self.pictureImage = image ;
        [self performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:NO] ;
    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceivedData") ;
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError %@",pictureUrl) ;
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //NSLog(@"connectionDidFinishLoading %@",pictureUrl) ;
    
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload] ;
    if((image != nil) && (image.size.width > 0)){
        [VeamUtil storeCachedImage:pictureUrl data:self.activeDownload] ;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    self.pictureImage = image ;
    [self finishLoading] ;
}


@end
