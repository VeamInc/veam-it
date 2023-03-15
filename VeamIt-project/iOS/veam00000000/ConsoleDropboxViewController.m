//
//  ConsoleDropboxViewController.m
//  veam00000000
//
//  Created by veam on 9/13/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "ConsoleDropboxViewController.h"
#import "VeamUtil.h"

@interface ConsoleDropboxViewController ()

@end

@implementation ConsoleDropboxViewController

@synthesize delegate ;
@synthesize returnViewController ;
@synthesize dropboxPath ;
@synthesize restClient ;
@synthesize extensions ;

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
    // Do any additional setup after loading the view.
    
    urlFetching = NO ;
    
    if(self.restClient != nil){
        self.restClient.delegate = nil ;
        self.restClient = nil ;
    }
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]] ;
    self.restClient.delegate = self ;
    
    [self.restClient loadMetadata:self.dropboxPath] ;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    indicator.center = self.view.center ;
    [indicator startAnimating] ;
    [self.view addSubview:indicator] ;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupTable
{
    CGFloat currentY = [self addMainTableView] ;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine] ;
    [tableView setDelegate:self] ;
    [tableView setDataSource:self] ;
    [indicator setHidden:YES] ;
    [indicator stopAnimating] ;
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    currentMetadata = metadata ;
    if(metadata.isDirectory){
        //NSLog(@"Folder '%@' ", metadata.path) ;
        //NSLog(@"icon '%@' ", metadata.icon) ;
        for(DBMetadata *file in metadata.contents){
            //NSLog(@"	%@ icon:%@ filename:%@ path:%@",file.thumbnailExists?@"thumbnail exists":@"no thumbnail",file.icon,file.filename,file.path) ;
        }
    }
    [self performSelectorOnMainThread:@selector(setupTable) withObject:nil waitUntilDone:NO] ;
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    //NSLog(@"Error loading metadata: %@", error) ;
}


- (void)restClient:(DBRestClient *)restClient loadedSharableLink:(NSString *)link forFile:(NSString *)path
{
    //NSLog(@"path %@ link:%@", path,link) ;
    [self performSelectorOnMainThread:@selector(endUrlFetching) withObject:nil waitUntilDone:NO] ;
    if(delegate != nil){
        NSString *finalUrl = @"" ;
        NSRange range = [link rangeOfString:@"?dl=0"] ;
        if(range.location == NSNotFound){
            finalUrl = link ;
        } else {
            finalUrl = [link substringToIndex:range.location] ;
        }

        [delegate didFetchDropboxFileUrl:finalUrl] ;
        [self.navigationController popToViewController:returnViewController animated:YES] ;
    }
}

- (void)restClient:(DBRestClient *)restClient loadSharableLinkFailedWithError:(NSError *)error
{
    //NSLog(@"Error loading sharablelink: %@", error) ;
    [self performSelectorOnMainThread:@selector(endUrlFetching) withObject:nil waitUntilDone:NO] ;
    [VeamUtil dispError:@"Failed to get URL"] ;
}

- (void)startUrlFetching
{
    urlFetching = YES ;
    [indicator startAnimating] ;
    [indicator setHidden:NO] ;
}

- (void)endUrlFetching
{
    [indicator setHidden:YES] ;
    [indicator stopAnimating] ;
    urlFetching = NO ;
}

- (void)getSelectedFileUrl
{
    [self performSelectorOnMainThread:@selector(startUrlFetching) withObject:nil waitUntilDone:NO] ;
    
    DBMetadata *metadata = [currentMetadata.contents objectAtIndex:selectedIndex] ;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dropboxPath,metadata.filename] ;
    //NSLog(@"filePath %@",filePath) ;
    [self.restClient loadSharableLinkForFile:filePath shortUrl:NO] ;
}












- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 0 ;
    if(section == 0){
        numberOfContents = [currentMetadata.contents count] ;
        retValue = numberOfContents ;
    }
    
    //NSLog(@"numberOfRowsInSection section=%d number=%d",section,retValue) ;
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retValue = 0 ;
    return retValue ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil ;
    return sectionHeaderView ;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    if(indexPath.section == 0){
        if(indexPath.row < numberOfVideoCategories){
            retValue = [ConsoleVideoCategoryTableViewCell getCellHeight] ;
        } else {
            retValue = 44 ; // TODO addCell getCellHeight
        }
    }
    return retValue ;
}
*/

- (NSString *)getDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar] ;
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"] ;
    NSString *dateString = [dateFormatter stringFromDate:date] ;
    return dateString ;
}

- (NSString *)getSizeString:(long long)size
{
    CGFloat convertedSize = 0 ;
    NSString *unit = @"" ;
    CGFloat giga = 1024*1024*1024 ;
    CGFloat mega = 1024*1024 ;
    CGFloat kilo = 1024 ;
    if(size >= giga){
        unit = @"GB" ;
        convertedSize = size / giga ;
    } else if(size >= mega){
        unit = @"MB" ;
        convertedSize = size / mega ;
    } else if(size >= kilo){
        unit = @"KB" ;
        convertedSize = size / kilo ;
    } else {
        unit = @"B" ;
        convertedSize = size ;
    }
    
    NSString *sizeString = [NSString stringWithFormat:@"%.1f %@",convertedSize,unit] ;
    return sizeString ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    
    if(indexPath.section == 0){
        if(indexPath.row < numberOfContents){
            //BOOL isLast = (indexPath.row == (numberOfContents-1)) ;
            DBMetadata *metadata = [currentMetadata.contents objectAtIndex:indexPath.row] ;
            if(metadata.isDirectory){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
                [cell.textLabel setText:metadata.filename] ;
            } else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] ;
                [cell.textLabel setText:metadata.filename] ;

                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@, modified %@",[self getSizeString:metadata.totalBytes],[self getDateString:metadata.lastModifiedDate]]] ;

            }
            
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17] ;
            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle] ;

        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
            cell.textLabel.text = @"" ;
        }
    }
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"] ;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]] ;
        [cell.textLabel setText:@""] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }

    return cell;
}

- (BOOL)isAcceptable:(NSString *)extension
{
    //NSLog(@"isAcceptable %@ %@",extension,extensions) ;
    BOOL retValue = NO ;
    if([VeamUtil isEmpty:extensions]){
        retValue = YES ;
    } else {
        NSArray *extensionStrings = [extensions componentsSeparatedByString:@","] ;
        NSInteger count = [extensionStrings count] ;
        for(int index = 0 ; index < count ; index++){
            NSString *workExtension = [extensionStrings objectAtIndex:index] ;
            //if([extension isEqualToString:workExtension]){
            if([extension caseInsensitiveCompare:workExtension] == NSOrderedSame){
                retValue = true ;
                break ;
            }
        }
    }
    return retValue ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath") ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if(!urlFetching){
        if(indexPath.section == 0){
            if(indexPath.row < numberOfContents){
                DBMetadata *metadata = [currentMetadata.contents objectAtIndex:indexPath.row] ;
                if(metadata.isDirectory){
                    NSString *targetPath = [NSString stringWithFormat:@"%@/%@",dropboxPath,metadata.filename] ;
                    ConsoleDropboxViewController *dropboxViewController = [[ConsoleDropboxViewController alloc] init] ;
                    [dropboxViewController setDelegate:delegate] ;
                    [dropboxViewController setReturnViewController:returnViewController] ;
                    [dropboxViewController setHeaderStyle:VEAM_CONSOLE_HEADER_STYLE_BACK|VEAM_CONSOLE_HEADER_STYLE_LEFT_TITLE] ;
                    [dropboxViewController setShowFooter:NO] ;
                    [dropboxViewController setContentMode:VEAM_CONSOLE_UPLOAD_MODE] ;
                    [dropboxViewController setDropboxPath:targetPath] ;
                    [dropboxViewController setHeaderTitle:metadata.filename] ;
                    [dropboxViewController setExtensions:extensions] ;
                    [self pushViewController:dropboxViewController] ;
                } else {
                    if([self isAcceptable:[metadata.filename pathExtension]]){
                        //NSLog(@"select file") ;
                        selectedIndex = indexPath.row ;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:metadata.filename message:@"Select this file?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] ;
                        [alert show];
                    } else {
                        [VeamUtil dispError:[NSString stringWithFormat:@"Please select the file with following extensions %@",extensions]] ;
                    }
                }
            }
        }
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    switch (buttonIndex) {
        case 0:
            // cancel
            break;
        case 1:
        {
            // OK
            [self getSelectedFileUrl] ;
            break;
        }
    }
}


@end
