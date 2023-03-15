//
//  PostDescriptionViewController.m
//  veam31000000
//
//  Created by veam on 2/11/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "PostDescriptionViewController.h"
#import "VeamUtil.h"

@interface PostDescriptionViewController ()

@end

@implementation PostDescriptionViewController

@synthesize defaultDescription ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewName:@"PostProfileComment/"] ;
    
    isPosting = NO ;
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,[VeamUtil getViewTopOffset] + [VeamUtil getTopBarHeight] + 10, [VeamUtil getScreenWidth] - 20, 150)] ;
    [commentTextView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
    [commentTextView setTextColor:[VeamUtil getBaseTextColor]] ;
    [commentTextView setText:defaultDescription] ;
    [commentTextView becomeFirstResponder] ;
    [self.view addSubview:commentTextView] ;
    
    [self addTopBar:YES showSettingsButton:NO] ;
    
    CGFloat postWidth = 50 ;
    CGRect postFrame = CGRectMake(topBarTitleMaxRight-postWidth, 0, postWidth, [VeamUtil getTopBarHeight]) ;
    postLabel = [[UILabel alloc] initWithFrame:postFrame] ;
    [postLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]] ;
    [postLabel setTextColor:[VeamUtil getTopBarActionTextColor]] ;
    [postLabel setBackgroundColor:[UIColor clearColor]] ;
    [postLabel setText:NSLocalizedString(@"done",nil)] ;
    [VeamUtil registerTapAction:postLabel target:self selector:@selector(onPostButtonTap)] ;
    [topBarView addSubview:postLabel] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
    CGRect frame = indicator.frame ;
    frame.origin.x = postFrame.origin.x + (postFrame.size.width - frame.size.width) / 2 ;
    frame.origin.y = postFrame.origin.y + (postFrame.size.height - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator setAlpha:0.0] ;
    [topBarView addSubview:indicator] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onPostButtonTap
{
    //NSLog(@"post");
    
    if(isPosting){
        return ;
    }
    
    NSString *comment = [commentTextView text] ;
    if((comment == nil) || [comment isEqualToString:@""]){
        return ;
    }
    
    
    isPosting = YES ;
    [indicator startAnimating] ;
    [indicator setAlpha:1.0] ;
    [postLabel setAlpha:0.0] ;
    
    [self postComment] ;
}

- (void)postComment
{
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    //NSLog(@"postComment %@ %@",[name text],[comment text]) ;
    [self sendPostRequest] ;
}

- (void)sendPostRequest
{
    NSURL *url = [VeamUtil getApiUrl:@"socialuser/postdescription"] ;
    
    NSString *comment = [commentTextView text] ;
    NSString *urlEncodedComment = [VeamUtil urlEncode:comment] ;
    //NSLog(@"urlEncodedMessage = %@",urlEncodedMessage);
    
    NSString *uid = [VeamUtil getUid] ;
    NSInteger socialUserId = [VeamUtil getSocialUserId] ;
    NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d_%@",socialUserId,comment]] ;
    
    NSString *params ;
    params = [NSString stringWithFormat:@"u=%@&sid=%d&d=%@&s=%@",uid,socialUserId,urlEncodedComment,signature] ;
    NSData *myRequestData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    
    conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(conn){
        buffer = [NSMutableData data] ;
    } else {
        // error handling
    }
}


- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res
{
    NSHTTPURLResponse *hres = (NSHTTPURLResponse *)res;
    /*
     NSLog(@"Received Response. Status Code: %d", [hres statusCode]);
     NSLog(@"Expected ContentLength: %qi", [hres expectedContentLength]);
     NSLog(@"MIMEType: %@", [hres MIMEType]);
     NSLog(@"Suggested File Name: %@", [hres suggestedFilename]);
     NSLog(@"Text Encoding Name: %@", [hres textEncodingName]);
     NSLog(@"URL: %@", [hres URL]);
     NSLog(@"Received Response. Status Code: %d", [hres statusCode]);
     */
    NSDictionary *dict = [hres allHeaderFields];
    NSArray *keys = [dict allKeys];
    for (int i = 0; i < [keys count]; i++) {
        /*
         NSLog(@"    %@: %@",
         [keys objectAtIndex:i],
         [dict objectForKey:[keys objectAtIndex:i]]);
         */
    }
    [buffer setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData
{
    [buffer appendData:receivedData];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    conn = nil ;
    buffer = nil ;
    NSLog(@"Connection failed: %@", [error localizedDescription]);
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [postLabel setAlpha:1.0] ;
    [VeamUtil dispError:@"Request failed"] ;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
    NSString *contents = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    //NSLog(@"received %@",contents) ;
    NSArray *results = [contents componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    if([results count] >= 2){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            [VeamUtil setDescriptionPosted:YES] ;
        }
    }
    
    //NSLog(@"%@", contents);
    buffer = nil ;
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end
