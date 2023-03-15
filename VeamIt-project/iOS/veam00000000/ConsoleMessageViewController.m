//
//  ConsoleMessageViewController.m
//  veam00000000
//
//  Created by veam on 3/3/15.
//  Copyright (c) 2015 veam. All rights reserved.
//

#import "ConsoleMessageViewController.h"

#import "AppCreatorMessages.h"
#import "VeamUtil.h"
#import "AppCreatorMessageCellViewController.h"
#import "NotificationCellViewController.h"

@interface ConsoleMessageViewController ()

@end

@implementation ConsoleMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    /*
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter] ;
    [notificationCenter addObserver:self selector:@selector(didReceiveNotification) name:NOTIFICATION_RECEIVED_ID_MESSAGE object:nil] ;
     */

    isUpdating = NO ;
    
    messages = [[AppCreatorMessages alloc] init] ;
    imageDownloadsInProgressForUser = [NSMutableDictionary dictionary] ;
    messageListTableView = nil ;
    currentPageNo = 1 ;
    
    inputViewHeight = 44 ;
    
    initialTableFrame = CGRectMake(0, [VeamUtil getViewTopOffset]+VEAM_CONSOLE_HEADER_HEIGHT, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight]-VEAM_CONSOLE_HEADER_HEIGHT) ;
    messageListTableView = [[UITableView alloc] initWithFrame:initialTableFrame] ;
    [messageListTableView setDelegate:self] ;
    [messageListTableView setDataSource:self] ;
    [messageListTableView setBackgroundColor:[UIColor clearColor]] ;
    [messageListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [messageListTableView setAlpha:0.0] ;
    [messageListTableView setShowsVerticalScrollIndicator:NO] ;
    [self.view addSubview:messageListTableView] ;

    /*
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, [VeamUtil getScreenHeight]-inputViewHeight-[VeamUtil getStatusBarHeight]+[VeamUtil getViewTopOffset], [VeamUtil getScreenWidth], inputViewHeight)] ;
    [inputView setBackgroundColor:[UIColor whiteColor]] ;
    [self.view addSubview:inputView] ;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [VeamUtil getScreenWidth], 1)] ;
    [lineView setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFADADAD"]] ;
    [inputView addSubview:lineView] ;
    
    CGFloat fieldLeftMargin = 10 ;
    CGFloat fieldWidth = 256 ;
    
    messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLeftMargin, 8, fieldWidth, 28)] ;
    [messageTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]] ;
    messageTextField.borderStyle = UITextBorderStyleRoundedRect ;
    messageTextField.textColor = [VeamUtil getColorFromArgbString:@"FF252525"] ;
    messageTextField.placeholder = @"Message" ;
    messageTextField.clearButtonMode = UITextFieldViewModeAlways ;
    [inputView addSubview:messageTextField] ;
    
    CGFloat labelX = fieldLeftMargin+fieldWidth ;
    sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, [VeamUtil getScreenWidth]-labelX, inputViewHeight)] ;
    [sendLabel setBackgroundColor:[UIColor clearColor]] ;
    [sendLabel setText:@"Send"] ;
    [sendLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]] ;
    [sendLabel setTextColor:[VeamUtil getColorFromArgbString:@"FF8F8F8F"]] ;
    [sendLabel setTextAlignment:NSTextAlignmentCenter] ;
    [VeamUtil registerTapAction:sendLabel target:self selector:@selector(didSendLabelTap)] ;
    [inputView addSubview:sendLabel] ;
    
    sendIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    CGRect indicatorFrame = sendIndicator.frame ;
    indicatorFrame.size.width = inputViewHeight ;
    indicatorFrame.size.height = inputViewHeight ;
    [sendIndicator setFrame:indicatorFrame] ;
    [sendIndicator setCenter:sendLabel.center] ;
    [sendIndicator stopAnimating] ;
    [sendIndicator setAlpha:0.0] ;
    [inputView addSubview:sendIndicator] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [self.view addSubview:indicator] ;
     */

    [self performSelectorInBackground:@selector(updateMessages) withObject:nil] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didSendLabelTap
{
    //NSLog(@"didSendLabelTap text=%@",messageTextField.text) ;
    if([VeamUtil isEmpty:messageTextField.text]){
        return ;
    }
    
    if(!isSending){
        [self postMessage] ;
    }
}

-(void)updateMessages
{
    @autoreleasepool
    {
        //NSLog(@"update messages start") ;
        isUpdating = YES ;
        NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
        NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
        NSString *pageNo = [NSString stringWithFormat:@"%d",currentPageNo] ;
        
        NSString *apiName = @"account/pagedmessage" ;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                userName,@"un",
                                password,@"pw",
                                pageNo,@"p",
                                nil] ;
        
        ConsolePostData *postData = [[ConsolePostData alloc] init] ;
        [postData setApiName:apiName] ;
        [postData setParams:params] ;

        NSData *data = [ConsoleUtil getDataFrom:postData] ;
        
        if(currentPageNo == 1){
            AppCreatorMessages *workMessages = [[AppCreatorMessages alloc] init] ;
            [workMessages parseWithData:data generateDateElement:YES] ;
            messages = workMessages ;
            creatorName = messages.appCreatorName ;
            mcnName = messages.mcnName ;
        } else {
            [messages parseWithData:data generateDateElement:YES] ; // add
        }
        isUpdating = NO ;
        //NSLog(@"update messages end") ;
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
}

- (void)reloadData
{
    //NSLog(@"reloadData") ;
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [findIndicator stopAnimating] ;
    [findIndicator setAlpha:0.0] ;
    [messageListTableView reloadData] ;
    CGFloat contentHeight = messageListTableView.contentSize.height ;
    //NSLog(@"contentheight = %f",contentHeight) ;
    [messageListTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)] ;
    
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[messages getLatestAddCount]+1 inSection:0] ;
    [messageListTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO] ;
    
    CGRect frame = [messageListTableView frame] ;
    frame.origin.y = [VeamUtil getViewTopOffset] + VEAM_CONSOLE_HEADER_HEIGHT ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3] ;
    [messageListTableView setAlpha:1.0] ;
    [messageListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
}

- (void)hideIndicator
{
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
}

- (void)hideFindIndicator
{
    if(findIndicator != nil){
        [findIndicator stopAnimating] ;
        [findIndicator setAlpha:0.0] ;
    }
}

#define MESSAGE_CELL_BOTTOM_MARGIN 10 ;
- (CGFloat)getCellHeight:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    
    NSInteger index = indexPath.row - 1 ;
    AppCreatorMessage *message = [messages getMessageAt:index] ;
    
    if([message.kind isEqualToString:MESSAGE_KIND_DATE]){
        retValue = 44 ;
    } else {
        AppCreatorMessageCellViewController *controller = [[AppCreatorMessageCellViewController alloc] initWithNibName:@"AppCreatorMessageCell" bundle:nil] ;
        AppCreatorMessageCell *messageCell = (AppCreatorMessageCell *)controller.view ;
        [[messageCell messageLabel] setText:message.text] ;
        [[messageCell messageLabel] adjustSize:MESSAGE_DIRECTION_RIGHT] ;
        CGRect frame = [[messageCell messageLabel] frame] ;
        retValue = frame.origin.y + frame.size.height + MESSAGE_CELL_BOTTOM_MARGIN ;
    }
    return retValue ;
}

#define TABLE_BOTTOM_PDDING 50
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0 ;
    if(indexPath.row == 0){
        //height = [VeamUtil getTopBarHeight] ;
        height = 2 ;
    } else if(indexPath.row == (numberOfMessages+1)){
        height = TABLE_BOTTOM_PDDING ;
        /*
         if([messages noMoreMessages]){
         height = 50 ;
         } else {
         height = 100 ;
         }
         */
    } else {
        height = [self getCellHeight:indexPath] ;
    }
    return height ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numberOfMessages = [messages getNumberOfMessages] ;
    NSInteger retInt = numberOfMessages ;
    retInt += 2 ; // spacer
    //NSLog(@"number of rows : %d",retInt) ;
    return retInt ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"cellForRowAtIndexPath row=%d",indexPath.row) ;
    
    UITableViewCell *cell ;
    
    if(indexPath.row == 0){
        // notification
        
        NotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:@"Notification"] ;
        if (notificationCell == nil) {
            NotificationCellViewController *controller = [[NotificationCellViewController alloc] initWithNibName:@"NotificationCell" bundle:nil] ;
            notificationCell = (NotificationCell *)controller.view ;
        }
        
        if(isUpdating){
            [notificationCell.indicator startAnimating] ;
            [notificationCell.indicator setAlpha:1.0] ;
            [notificationCell.updatingLabel setAlpha:1.0] ;
            [notificationCell.instructionLabel setAlpha:0.0] ;
        } else {
            [notificationCell.indicator stopAnimating] ;
            [notificationCell.indicator setAlpha:0.0] ;
            [notificationCell.updatingLabel setAlpha:0.0] ;
            if([tableView contentOffset].y < -50){
                [notificationCell.instructionLabel setAlpha:1.0] ;
            } else {
                [notificationCell.instructionLabel setAlpha:0.0] ;
            }
        }
        
        cell = notificationCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else if(indexPath.row == (numberOfMessages+1)){
        // spacer
        cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        NSInteger index = indexPath.row - 1 ;
        AppCreatorMessage *message = [messages getMessageAt:index] ;
        if([message.kind isEqualToString:MESSAGE_KIND_DATE]){
            UITableViewCell *dateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
            
            
            CGRect dateFrame = CGRectMake(115, 12, 90, 20) ;
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame] ;
            [dateLabel setText:message.text] ;
            [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]] ;
            [dateLabel setTextAlignment:NSTextAlignmentCenter] ;
            [dateLabel setBackgroundColor:[VeamUtil getColorFromArgbString:@"FFCACACA"]] ;
            [[dateLabel layer] setCornerRadius:9.0] ;
            [dateLabel setClipsToBounds:YES] ;
            [dateCell addSubview:dateLabel] ;
            
            [dateCell setBackgroundColor:[UIColor clearColor]] ;
            [dateCell.contentView setBackgroundColor:[UIColor clearColor]] ;
            cell = dateCell ;
        } else {
            BOOL isMyMessage = NO ;
            if([message.direction isEqualToString:@"1"]){
                isMyMessage = YES ;
            }
            AppCreatorMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
            if (messageCell == nil) {
                AppCreatorMessageCellViewController *controller = [[AppCreatorMessageCellViewController alloc] initWithNibName:@"AppCreatorMessageCell" bundle:nil] ;
                messageCell = (AppCreatorMessageCell *)controller.view ;
            }
            
            if(isMyMessage){
                [[messageCell titleLabel] setText:creatorName] ;
            } else {
                [[messageCell titleLabel] setText:mcnName] ;
            }
            [[messageCell titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
            [[messageCell titleLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF6D6D6D"]] ;
            
            [[messageCell dateLabel] setText:[VeamUtil getMessageTimeString:message.createdAt]] ;
            [[messageCell dateLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]] ;
            [[messageCell dateLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF6D6D6D"]] ;
            
            [[messageCell messageLabel] setText:message.text] ;
            [[messageCell messageLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
            
            CGFloat dateMargin = 3 ;
            CGRect labelFrame ;
            CGRect dateFrame = messageCell.dateLabel.frame ;
            if(isMyMessage){
                labelFrame = messageCell.messageLabel.frame ;
                labelFrame.origin.x += 24 ;
                [messageCell.messageLabel setFrame:labelFrame] ;
                [[messageCell messageLabel] adjustSize:MESSAGE_DIRECTION_RIGHT] ;
                [[messageCell messageLabel] setBaseColor:MESSAGE_COLOR_GRAY] ;
                labelFrame = messageCell.messageLabel.frame ;
                
                dateFrame.origin.x = labelFrame.origin.x - dateFrame.size.width - dateMargin ;
                [messageCell.dateLabel setTextAlignment:NSTextAlignmentRight] ;
                [messageCell.titleLabel setTextAlignment:NSTextAlignmentRight] ;
            } else {
                [[messageCell messageLabel] adjustSize:MESSAGE_DIRECTION_LEFT] ;
                [[messageCell messageLabel] setBaseColor:MESSAGE_COLOR_DARK_GRAY] ;
                labelFrame = messageCell.messageLabel.frame ;
                
                dateFrame.origin.x = labelFrame.origin.x + labelFrame.size.width + dateMargin ;
                [messageCell.dateLabel setTextAlignment:NSTextAlignmentLeft] ;
                [messageCell.titleLabel setTextAlignment:NSTextAlignmentLeft] ;
                
                /*
                AGMedallionView *userImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)] ;
                userImageView.image = [VeamUtil getCachedImage:userImageUrl downloadIfNot:NO] ;
                [messageCell addSubview:userImageView] ;
                 */
            }
            dateFrame.origin.y = labelFrame.origin.y + labelFrame.size.height - dateFrame.size.height ;
            [messageCell.dateLabel setFrame:dateFrame] ;
            
            /*
             messageCell.thumbnailImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(13, 6, 32, 32)] ;
             [messageCell.contentView addSubview:messageCell.thumbnailImageView] ;
             
             UIImage *ownerIconImage = [VeamUtil getCachedImage:[message imageUrl] downloadIfNot:NO] ;
             if(ownerIconImage == nil){
             [self startImageDownload:[message imageUrl] forIndexPath:indexPath imageIndex:1] ;
             } else {
             [messageCell.thumbnailImageView setImage:ownerIconImage] ;
             }
             */
            
            
            [messageCell setBackgroundColor:[UIColor clearColor]] ;
            [messageCell.contentView setBackgroundColor:[UIColor clearColor]] ;
            
            cell = messageCell ;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    UIView *selectedView = [[UIView alloc] init] ;
    [selectedView setBackgroundColor:[VeamUtil getTableSelectionColor]] ;
    [cell setSelectedBackgroundView:selectedView] ;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

- (void)startUpdating
{
    NotificationCell *notificationCell = (NotificationCell *)[messageListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    CGRect frame = [messageListTableView frame] ;
    frame.origin.y = [VeamUtil getTopBarHeight] + [VeamUtil getViewTopOffset] + VEAM_CONSOLE_HEADER_HEIGHT ;
    [notificationCell.indicator startAnimating] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [notificationCell.indicator setAlpha:1.0] ;
    [notificationCell.updatingLabel setAlpha:1.0] ;
    [messageListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
    currentPageNo = 1 ;
    [self performSelectorInBackground:@selector(updateMessages) withObject:nil] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = [scrollView contentOffset].y ;
    //NSLog(@"scrollViewDidEndDragging offset = %f",offsetY) ;
    
    if((offsetY < -50) && !isUpdating){
        //NSLog(@"update") ;
        //[self startUpdating] ;
        if(!([messages noMoreMessages] || (numberOfMessages == 0))){
            //NSLog(@"last cell %d : update",indexPath.row) ;
            if(!isUpdating){
                currentPageNo++ ;
                [self performSelectorInBackground:@selector(updateMessages) withObject:nil] ;
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = [scrollView contentOffset].y ;
    //NSLog(@"scrollViewDidScroll offset = %f",offsetY) ;
    
    NotificationCell *notificationCell = (NotificationCell *)[messageListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    if((offsetY < -50) && !isUpdating){
        //[notificationCell.instructionLabel setAlpha:1.0] ;
    } else {
        [notificationCell.instructionLabel setAlpha:0.0] ;
    }
}

- (void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo] ;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size ;
    //NSLog(@"%@::keyboardWillShow w:%f h:%f",NSStringFromClass([self class]),kbSize.width, kbSize.height) ;
    
    CGRect frame = inputView.frame ;
    frame.origin.y = [VeamUtil getScreenHeight]-inputViewHeight-[VeamUtil getStatusBarHeight] + [VeamUtil getViewTopOffset] - kbSize.height ;
    
    CGRect tableFrame = messageListTableView.frame ;
    tableFrame.size.height = frame.origin.y - [VeamUtil getViewTopOffset] - VEAM_CONSOLE_HEADER_HEIGHT + TABLE_BOTTOM_PDDING ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [inputView setFrame:frame] ;
    [messageListTableView setFrame:tableFrame] ;
    [UIView commitAnimations] ;
    
}

- (void) keyboardWillHide:(NSNotification *)note
{
    // move the view back to the origin
    //NSLog(@"%@::keyboardWillHide",NSStringFromClass([self class])) ;
    
    CGRect frame = inputView.frame ;
    frame.origin.y = [VeamUtil getScreenHeight]-inputViewHeight -[VeamUtil getStatusBarHeight] + [VeamUtil getViewTopOffset] ;
    [inputView setFrame:frame] ;
    
    CGRect tableFrame = messageListTableView.frame ;
    tableFrame.size.height = frame.origin.y - [VeamUtil getStatusBarHeight] + TABLE_BOTTOM_PDDING ;
    [messageListTableView setFrame:initialTableFrame] ;
    
}







- (void)showSendingIndicator
{
    [sendIndicator startAnimating] ;
    [sendIndicator setAlpha:1.0] ;
}

- (void)startSending
{
    isSending = YES ;
    [self performSelectorOnMainThread:@selector(showSendingIndicator) withObject:nil waitUntilDone:NO] ;
}

- (void)hideSendingIndicator
{
    [sendIndicator stopAnimating] ;
    [sendIndicator setAlpha:0.0] ;
}

- (void)endSending
{
    isSending = NO ;
    [self performSelectorOnMainThread:@selector(hideSendingIndicator) withObject:nil waitUntilDone:NO] ;
}

- (void)postMessage
{
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    //NSLog(@"postMessage %@",messageTextField.text) ;
    [self startSending] ;
    [self performSelectorInBackground:@selector(sendPostRequest) withObject:nil] ;
}

- (void)sendPostRequest
{
    NSString *userName = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_USERNAME] ;
    NSString *password = [VeamUtil getUserDefaultString:VEAM_CONSOLE_KEY_PASSWORD] ;
    
    //NSLog(@"username='%@'",userName) ;
    
    NSString *message = [messageTextField text] ;
    //NSString *urlEncodedMessage = [VeamUtil urlEncode:message] ;
    
    NSString *apiName = @"account/sendmessagetomcn" ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userName,@"un",
                            password,@"pw",
                            message,@"m",
                            nil] ;
    
    ConsolePostData *postData = [[ConsolePostData alloc] init] ;
    [postData setApiName:apiName] ;
    [postData setParams:params] ;
    
    NSData *data = [ConsoleUtil getDataFrom:postData] ;
    
    //NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
    NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"received %@",contents) ;
    NSArray *results = [contents componentsSeparatedByString:@"\n"];
    //NSLog(@"count=%d",[results count]) ;
    NSString *messageId = nil ;
    if([results count] >= 2){
        if([[results objectAtIndex:0] compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame){
            messageId = [results objectAtIndex:1] ;
            [self performSelectorOnMainThread:@selector(unfocusTextField) withObject:nil waitUntilDone:NO] ;
            [self startUpdating] ;
        }
    }
    
    [self endSending] ;
    
    //NSLog(@"%@", contents);
    buffer = nil ;

}

- (void)unfocusTextField
{
    [messageTextField setText:@""] ;
    [messageTextField resignFirstResponder] ;
}

- (void)didReceiveNotification
{
    [self performSelectorInBackground:@selector(updateMessages) withObject:nil] ;
}

-(void)dealloc
{
    //NSLog(@"%@::dealloc",NSStringFromClass([self class])) ;
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

@end
