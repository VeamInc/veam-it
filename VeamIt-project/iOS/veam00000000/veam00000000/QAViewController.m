//
//  QAViewController.m
//  veam31000016
//
//  Created by veam on 4/22/14.
//  Copyright (c) 2014 veam. All rights reserved.
//

#import "QAViewController.h"
#import "VeamUtil.h"
#import "PostQuestionViewController.h"
#import "NotificationCellViewController.h"
#import "QuestionCellViewController.h"
#import "QuestionTopCellViewController.h"
#import "AnswerCellViewController.h"
#import "AppDelegate.h"
#import "SubscriptionPurchaseViewController.h"

#define VEAM_PENDING_OPERATION_ASK      1
#define VEAM_PENDING_OPERATION_LIKE     2

#define ALERT_VIEW_TAG_DOWNLOAD     1
#define ALERT_VIEW_TAG_REMOVE       2

#define QUESTION_CELL_BOTTOM_MARGIN 30
#define QUESTION_CELL_MIN_HEIGHT 73

#define QUESTION_CELL_USER_NAME_MAX_WIDTH 120

#define QUESTION_CELL_LINE_HEIGHT 16

#define SECTION_HEADER_HEIGHT   41
#define QA_HEADER_HEIGHT   180

#define VEAM_ANSWER_KIND_NONE   0
#define VEAM_ANSWER_KIND_VIDEO  1
#define VEAM_ANSWER_KIND_AUDIO  2



@interface QAViewController ()

@end

@implementation QAViewController

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
    
    //NSLog(@"YoutubeViewController::viewDidLoad %@ %@",categoryId,subCategoryId) ;
    
    [self setViewName:@"QAList/"] ;
    
    isBought = [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;

    currentKind = VEAM_QUESTION_KIND_DATE ;
    currentPageNo = 1 ;
    
    likeOffImage = [VeamUtil imageNamed:@"vote_off.png"] ;
    likeOnImage = [VeamUtil imageNamed:@"vote_on.png"] ;
    videoOffImage = [VeamUtil imageNamed:@"answer_video_off.png"] ;
    videoOnImage = [VeamUtil imageNamed:@"answer_video_on.png"] ;
    audioOnImage = [VeamUtil imageNamed:@"answer_audio_on.png"] ;
    
    originalY = [VeamUtil getViewTopOffset]+[VeamUtil getTopBarHeight] ;
    
    qaListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originalY, [VeamUtil getScreenWidth], [VeamUtil getScreenHeight] - [VeamUtil getStatusBarHeight]-[VeamUtil getTopBarHeight]-[VeamUtil getTabBarHeight])] ;
    [qaListTableView setDelegate:self] ;
    [qaListTableView setDataSource:self] ;
    [qaListTableView setBackgroundColor:[UIColor clearColor]] ;
    [qaListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [qaListTableView setShowsVerticalScrollIndicator:NO] ;
    //[qaListTableView setContentInset:UIEdgeInsetsMake(-50, 0, 0, 0)] ;
    [self.view addSubview:qaListTableView] ;
    
    instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, originalY + 12, [VeamUtil getScreenWidth], 30)] ;
    [instructionLabel setBackgroundColor:[UIColor clearColor]] ;
    [instructionLabel setText:@"Release to refresh"] ;
    [instructionLabel setTextAlignment:NSTextAlignmentCenter] ;
    [instructionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]] ;
    [instructionLabel setTextColor:[UIColor lightGrayColor]] ;
    [instructionLabel setAlpha:0.0] ;
    [self.view addSubview:instructionLabel] ;
    
    updatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, originalY + 12, 200, 30)] ;
    [updatingLabel setBackgroundColor:[UIColor clearColor]] ;
    [updatingLabel setText:@"Updating..."] ;
    [updatingLabel setTextAlignment:NSTextAlignmentLeft] ;
    [updatingLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]] ;
    [updatingLabel setTextColor:[UIColor lightGrayColor]] ;
    [updatingLabel setAlpha:0.0] ;
    [self.view addSubview:updatingLabel] ;
    
    notificationIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    [notificationIndicator setFrame:CGRectMake(89, originalY + 17, 20, 20)] ;
    [notificationIndicator setAlpha:0.0] ;
    [self.view addSubview:notificationIndicator] ;
    
    //scrollViewToBeScrolledToTop = qaListTableView ;

    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[VeamUtil getActivityIndicatorViewStyle]] ;
    CGRect frame = [indicator frame] ;
    frame.origin.x = ([VeamUtil getScreenWidth] - frame.size.width) / 2 ;
    frame.origin.y = ([VeamUtil getScreenHeight] - frame.size.height) / 2 ;
    [indicator setFrame:frame] ;
    [indicator startAnimating] ;
    [self.view addSubview:indicator] ;
    
    [self addTopBar:NO showSettingsButton:YES] ;

    [self performSelectorInBackground:@selector(updateQuestions) withObject:nil] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}

- (Questions *)getQuestionsForKind:(NSInteger)kind
{
    Questions *retValue ;
    if((kind == VEAM_QUESTION_KIND_DATE) || (kind == VEAM_QUESTION_KIND_RATING)){
        retValue = questions ;
    } else {
        retValue = [VeamUtil getAnswers] ;
        NSInteger count = [retValue getNumberOfQuestions:kind] ;
        if(count <= 0){
            retValue = questions ;
        }
    }
    return retValue ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retInt = 0 ;
    if(section == 0){
        retInt = 1 ;
    } else {
        numberOfQuestions = [[self getQuestionsForKind:currentKind] getNumberOfQuestions:currentKind] ;
        retInt = numberOfQuestions ;
        if(![[self getQuestionsForKind:currentKind] noMoreQuestions:currentKind]){
            retInt++ ;
        }
        
    }
    return retInt ;
}


- (void)adjustLabelSize:(UILabel *)label
{
    CGRect labelFrame = label.frame ;
    CGFloat originalWidth = labelFrame.size.width ;
    
    [label setNumberOfLines:0] ;
    [label sizeToFit] ;

    labelFrame = label.frame ;
    labelFrame.size.width = originalWidth ;
    [label setFrame:labelFrame] ;
}

- (CGFloat)getCellHeight:(NSIndexPath *)indexPath
{
    CGFloat retValue = 0 ;
    Question *question = [[self getQuestionsForKind:currentKind] getQuestionAt:indexPath.row kind:currentKind] ;
    if((currentKind == VEAM_QUESTION_KIND_DATE) || (currentKind == VEAM_QUESTION_KIND_RATING)){
        QuestionCellViewController *controller = [[QuestionCellViewController alloc] initWithNibName:@"QuestionCell" bundle:nil] ;
        QuestionCell *questionCell = (QuestionCell *)controller.view ;
        //[[questionCell questionLabel] setText:[question text]] ;
        [VeamUtil setTextWithLineHeight:[questionCell questionLabel] text:[question text] lineHeight:QUESTION_CELL_LINE_HEIGHT] ;
        [self adjustLabelSize:questionCell.questionLabel] ;
        CGRect frame = [[questionCell questionLabel] frame] ;
        retValue =  frame.origin.y + frame.size.height + QUESTION_CELL_BOTTOM_MARGIN ;
    } else {
        AnswerCellViewController *controller = [[AnswerCellViewController alloc] initWithNibName:@"AnswerCell" bundle:nil] ;
        AnswerCell *answerCell = (AnswerCell *)controller.view ;
        //[[answerCell questionLabel] setText:[question text]] ;
        [VeamUtil setTextWithLineHeight:[answerCell questionLabel] text:[question text] lineHeight:QUESTION_CELL_LINE_HEIGHT] ;
        [self adjustLabelSize:answerCell.questionLabel] ;
        CGRect frame = [[answerCell questionLabel] frame] ;
        retValue =  frame.origin.y + frame.size.height + QUESTION_CELL_BOTTOM_MARGIN ;
    }
    
    if(retValue < QUESTION_CELL_MIN_HEIGHT){
        retValue = QUESTION_CELL_MIN_HEIGHT ;
    }
    return retValue ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = 44.0 ; // basic
    if(indexPath.section == 0){
        retValue = QA_HEADER_HEIGHT ;
    } else if(indexPath.section == 1){
        retValue = [self getCellHeight:indexPath] ;
    }
    //NSLog(@"heightForRowAtIndexPath %d %f",indexPath.row,retValue) ;
    return retValue ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    
    if(indexPath.section == 0){
        QuestionTopCell *questionTopCell = [tableView dequeueReusableCellWithIdentifier:@"QuestionTopCell"] ;
        if (questionTopCell == nil) {
            QuestionTopCellViewController *controller = [[QuestionTopCellViewController alloc] initWithNibName:@"QuestionTopCell" bundle:nil] ;
            questionTopCell = (QuestionTopCell *)controller.view ;
        }
        
        
        UIColor *qaHeaderTextColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_TEXT_COLOR default:@"FFFFFFFF"]] ;
        UIColor *qaHeaderHighlightColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_HIGHLIGHT_COLOR default:@"FF000000"]] ;
        UIColor *qaHeaderBackgroundColor = [VeamUtil getQuestionHeaderColor] ;
        NSString *qaHeaderTitle = [VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_TITLE default:@"Ask"] ;
        NSString *qaHeaderSubTitle = [VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_SUB_TITLE default:@"-"] ;
        NSString *qaHeaderAskButtonTitle = [VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_ASK_BUTTON_TITLE default:@"Ask"] ;
        
        [questionTopCell.thumbnailImageView setImage:[VeamUtil imageNamed:@"question_top.png"]] ;
        [questionTopCell.titleLabel setTextColor:qaHeaderTextColor] ;
        [questionTopCell.titleLabel setText:qaHeaderTitle] ;
        [questionTopCell.subTitleLabel setTextColor:qaHeaderTextColor] ;
        [questionTopCell.subTitleLabel setText:qaHeaderSubTitle] ;
        [questionTopCell.askButtonImageView setImage:[VeamUtil imageNamed:@"ask_button.png"]] ;
        [questionTopCell.askButtonLabel setText:qaHeaderAskButtonTitle] ;
        [questionTopCell.askButtonLabel setTextColor:qaHeaderHighlightColor] ;
        [VeamUtil registerTapAction:questionTopCell.askButtonImageView target:self selector:@selector(askButtonTap)] ;
        [questionTopCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
        cell = questionTopCell ;
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:qaHeaderBackgroundColor] ;
    } else if(indexPath.row == numberOfQuestions){
        // spacer
        if([[self getQuestionsForKind:currentKind] noMoreQuestions:currentKind] || (numberOfQuestions == 0)){
            cell = [tableView dequeueReusableCellWithIdentifier:@"Spacer"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spacer"] ;
            }
        } else {
            //NSLog(@"last cell %d : update",indexPath.row) ;
            NotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:@"Notification"] ;
            if (notificationCell == nil) {
                NotificationCellViewController *controller = [[NotificationCellViewController alloc] initWithNibName:@"NotificationCell" bundle:nil] ;
                notificationCell = (NotificationCell *)controller.view ;
            }
            [notificationCell.indicator startAnimating] ;
            [notificationCell.indicator setAlpha:1.0] ;
            [notificationCell.updatingLabel setAlpha:1.0] ;
            [notificationCell.instructionLabel setAlpha:0.0] ;
            cell = notificationCell ;
            if(!isUpdating){
                currentPageNo++ ;
                [self performSelectorInBackground:@selector(updateQuestions) withObject:nil] ;
            }
        }
        [cell setBackgroundColor:[UIColor clearColor]] ;
        [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    } else {
        Question *question = [[self getQuestionsForKind:currentKind] getQuestionAt:indexPath.row kind:currentKind] ;
        if((currentKind == VEAM_QUESTION_KIND_DATE) || (currentKind == VEAM_QUESTION_KIND_RATING)){
            // questions
            QuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"] ;
            if (questionCell == nil) {
                QuestionCellViewController *controller = [[QuestionCellViewController alloc] initWithNibName:@"QuestionCell" bundle:nil] ;
                questionCell = (QuestionCell *)controller.view ;
            }

            // set values
            [[questionCell titleLabel] setText:[question socialUserName]] ;
            [[questionCell likeNumLabel] setText:[question numberOfLikes]] ;
            [[questionCell dateLabel] setText:[VeamUtil getShortTimeDescription:[question createdAt]]] ;
            //[[questionCell questionLabel] setText:[question text]] ;
            [VeamUtil setTextWithLineHeight:[questionCell questionLabel] text:[question text] lineHeight:QUESTION_CELL_LINE_HEIGHT] ;
            
            // adjust position
            [self adjustLabelSize:[questionCell questionLabel]] ;
            CGRect textFrame = [[questionCell questionLabel] frame] ;
            
            [[questionCell titleLabel] sizeToFit] ;
            CGRect titleFrame = [[questionCell titleLabel] frame] ;
            titleFrame.origin.y = textFrame.origin.y + textFrame.size.height + 6 ;
            if(titleFrame.size.width > QUESTION_CELL_USER_NAME_MAX_WIDTH){
                titleFrame.size.width = QUESTION_CELL_USER_NAME_MAX_WIDTH ;
            }
            [[questionCell titleLabel] setFrame:titleFrame] ;
            
            CGRect dateFrame = [[questionCell dateLabel] frame] ;
            dateFrame.origin.x = titleFrame.origin.x + titleFrame.size.width + 8 ;
            dateFrame.origin.y = titleFrame.origin.y ;
            dateFrame.size.height = titleFrame.size.height ;
            [[questionCell dateLabel] setFrame:dateFrame] ;
            
            [[questionCell likeNumLabel] sizeToFit] ;
            CGRect likeNumFrame = [[questionCell likeNumLabel] frame] ;
            likeNumFrame.origin.x = [VeamUtil getScreenWidth] - 70 - likeNumFrame.size.width ;
            likeNumFrame.origin.y = titleFrame.origin.y ;
            [[questionCell likeNumLabel] setFrame:likeNumFrame] ;
            
            CGRect likeNumImageFrame = [[questionCell likeNumImageView] frame] ;
            likeNumImageFrame.origin.x = likeNumFrame.origin.x - likeNumImageFrame.size.width - 2 ;
            likeNumImageFrame.origin.y = titleFrame.origin.y - 2 ;
            [[questionCell likeNumImageView] setFrame:likeNumImageFrame] ;
            
            CGRect separatorFrame = [[questionCell separatorView] frame] ;
            separatorFrame.origin.y = textFrame.origin.y + textFrame.size.height + QUESTION_CELL_BOTTOM_MARGIN - 1 ;
            if(separatorFrame.origin.y < (QUESTION_CELL_MIN_HEIGHT - 1)){
                separatorFrame.origin.y = QUESTION_CELL_MIN_HEIGHT - 1 ;
            }
            separatorFrame.size.height = 1.0f ;
            [[questionCell separatorView] setFrame:separatorFrame] ;
            
            
            // set text colors
            [[questionCell titleLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[questionCell likeNumLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[questionCell dateLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
            [[questionCell questionLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
            [[questionCell separatorView] setBackgroundColor:[VeamUtil getSeparatorColor]] ;

            // set images
            if([[self getQuestionsForKind:currentKind] isLike:[question questionId]]){
                [[questionCell likeImageView] setImage:likeOnImage] ;
            } else {
                [[questionCell likeImageView] setImage:likeOffImage] ;
            }
            [VeamUtil registerTapAction:questionCell.likeImageView target:self selector:@selector(onLikeButtonTap:)] ;
            [questionCell.likeImageView setTag:indexPath.row] ;
            
            if(currentKind == VEAM_QUESTION_KIND_DATE){
                [[questionCell iconImageView] setImage:[VeamUtil imageNamed:@"q_vote_icon.png"]] ;
            } else {
                [[questionCell iconImageView] setImage:[VeamUtil imageNamed:@"q_ranking_icon.png"]] ;
            }
            
            [[questionCell likeNumImageView] setImage:[VeamUtil imageNamed:@"q_ranking_icon.png"]] ;


            [questionCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
            cell = questionCell ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        } else {
            // answers
            AnswerCell *answerCell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"] ;
            if (answerCell == nil) {
                AnswerCellViewController *controller = [[AnswerCellViewController alloc] initWithNibName:@"AnswerCell" bundle:nil] ;
                answerCell = (AnswerCell *)controller.view ;
            }
            
            // set values
            [[answerCell titleLabel] setText:[question socialUserName]] ;
            [[answerCell dateLabel] setText:[NSString stringWithFormat:@"Update %@",[VeamUtil getAnswerDateString:[question answeredAt]]]] ;
            //[[answerCell questionLabel] setText:[question text]] ;
            [VeamUtil setTextWithLineHeight:[answerCell questionLabel] text:[question text] lineHeight:QUESTION_CELL_LINE_HEIGHT] ;

            // adjust position
            [self adjustLabelSize:[answerCell questionLabel]] ;
            [[answerCell titleLabel] sizeToFit] ;
            CGRect textFrame = [[answerCell questionLabel] frame] ;
            
            CGRect titleFrame = [[answerCell titleLabel] frame] ;
            titleFrame.origin.y = textFrame.origin.y + textFrame.size.height + 6 ;
            if(titleFrame.size.width > QUESTION_CELL_USER_NAME_MAX_WIDTH){
                titleFrame.size.width = QUESTION_CELL_USER_NAME_MAX_WIDTH ;
            }
            [[answerCell titleLabel] setFrame:titleFrame] ;
            
            CGRect deleteFrame = [[answerCell deleteLabel] frame] ;
            deleteFrame.origin.y = titleFrame.origin.y - 5 ;
            [[answerCell deleteLabel] setFrame:deleteFrame] ;
            
            CGRect separatorFrame = [[answerCell separatorView] frame] ;
            separatorFrame.origin.y = textFrame.origin.y + textFrame.size.height + QUESTION_CELL_BOTTOM_MARGIN - 1 ;
            if(separatorFrame.origin.y < (QUESTION_CELL_MIN_HEIGHT - 1)){
                separatorFrame.origin.y = QUESTION_CELL_MIN_HEIGHT - 1 ;
            }
            separatorFrame.size.height = 1.0f ;
            [[answerCell separatorView] setFrame:separatorFrame] ;
            
            CGRect actionImageFrame = [[answerCell actionImageView] frame] ;
            actionImageFrame.origin.y = (separatorFrame.origin.y - actionImageFrame.size.height) / 2 ;
            [[answerCell actionImageView] setFrame:actionImageFrame] ;
            
            CGRect actionLabelFrame = [[answerCell actionLabel] frame] ;
            actionLabelFrame.origin.y = actionImageFrame.origin.y + 20 ;
            [[answerCell actionLabel] setFrame:actionLabelFrame] ;
            
            CGRect arrowImageFrame = [[answerCell arrowImageView] frame] ;
            arrowImageFrame.origin.y = (separatorFrame.origin.y - arrowImageFrame.size.height) / 2 ;
            [[answerCell arrowImageView] setFrame:arrowImageFrame] ;
            
            
            
            
            // set colors
            [[answerCell titleLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[answerCell deleteLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
            [[answerCell dateLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
            [[answerCell questionLabel] setTextColor:[VeamUtil getBaseTextColor]] ;
            [[answerCell separatorView] setBackgroundColor:[VeamUtil getSeparatorColor]] ;

            // set images
            [[answerCell iconImageView] setImage:[VeamUtil imageNamed:@"q_answer_icon.png"]] ;
            if([self getAnswerKind:question] == VEAM_ANSWER_KIND_VIDEO){
                [[answerCell actionLabel] setText:@"Videos"] ;
                if([self answerDownloaded:question]){
                    [[answerCell actionImageView] setImage:videoOnImage] ;
                    [[answerCell actionLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
                    [[answerCell deleteLabel] setAlpha:1.0] ;
                    [[answerCell arrowImageView] setAlpha:1.0] ;
                    [VeamUtil registerTapAction:answerCell.deleteLabel target:self selector:@selector(onDeleteButtonTap:)] ;
                    [[answerCell deleteLabel] setTag:indexPath.row] ;
                } else {
                    [[answerCell actionImageView] setImage:videoOffImage] ;
                    [[answerCell actionLabel] setTextColor:[VeamUtil getColorFromArgbString:@"FF9F9F9F"]] ;
                    [[answerCell deleteLabel] setAlpha:0.0] ;
                    [[answerCell arrowImageView] setAlpha:0.0] ;
                }
            } else if([self getAnswerKind:question] == VEAM_ANSWER_KIND_AUDIO){
                [[answerCell actionImageView] setImage:audioOnImage] ;
                [[answerCell actionLabel] setText:@"Audio"] ;
                [[answerCell actionLabel] setTextColor:[VeamUtil getNewVideosTextColor]] ;
                [[answerCell deleteLabel] setAlpha:0.0] ;
                [[answerCell arrowImageView] setAlpha:1.0] ;
                [[answerCell deleteLabel] setTag:indexPath.row] ;
            }
            [VeamUtil registerTapAction:answerCell.actionImageView target:self selector:@selector(onActionButtonTap:)] ;
            [answerCell.actionImageView setTag:indexPath.row] ;
            
            [answerCell setSelectionStyle:UITableViewCellSelectionStyleNone] ;

            cell = answerCell ;
            [cell setBackgroundColor:[UIColor clearColor]] ;
            [cell.contentView setBackgroundColor:[VeamUtil getBackgroundColor]] ;
        }
    }
    return cell;
}

- (NSInteger)getAnswerKind:(Question *)question
{
    NSInteger retValue = VEAM_ANSWER_KIND_NONE ;
    if([question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_FIXED_VIDEO] ||
       [question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_PERIODICAL_VIDEO] ||
       [question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_FREE_VIDEO]
       ){
        retValue = VEAM_ANSWER_KIND_VIDEO ;
    } else if([question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_FIXED_AUDIO] ||
              [question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_PERIODICAL_AUDIO] ||
              [question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_FREE_AUDIO]
              ){
        retValue = VEAM_ANSWER_KIND_AUDIO ;
    }
    return retValue ;
}

- (BOOL)answerDownloaded:(Question *)question
{
    Video *video = [VeamUtil getVideoForId:[question answerId]] ;
    //NSLog(@"check exists video id=%@",video.videoId) ;
    return [VeamUtil videoExists:video] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath : %d %d %d",currentKind,indexPath.section,indexPath.row) ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat retFloat = 0 ;
    if(section == 1){
        retFloat = SECTION_HEADER_HEIGHT ;
    }
    return retFloat ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *containerView = nil ;
    if(section == 1){
        if(sectionHeaderView == nil){
            sectionHeaderView = [[UIView alloc] init] ;
            [sectionHeaderView setBackgroundColor:[VeamUtil getQuestionHeaderColor]] ;
            
            voteButtonOnImage = [VeamUtil imageNamed:@"vote_button_on.png"] ;
            voteButtonOffImage = [VeamUtil imageNamed:@"vote_button_off.png"] ;
            rankingButtonOnImage = [VeamUtil imageNamed:@"ranking_button_on.png"] ;
            rankingButtonOffImage = [VeamUtil imageNamed:@"ranking_button_off.png"] ;
            answerButtonOnImage = [VeamUtil imageNamed:@"answer_button_on.png"] ;
            answerButtonOffImage = [VeamUtil imageNamed:@"answer_button_off.png"] ;
            
            NSString *qaVoteButtonTitle = [VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_VOTE_BUTTON_TITLE default:@"Vote"] ;
            NSString *qaRankingButtonTitle = [VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_RANKING_BUTTON_TITLE default:@"Vote Ranking"] ;
            NSString *qaAnswerButtonTitle = [VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_ANSWER_BUTTON_TITLE default:@"Answer"] ;

            UIColor *qaHeaderTextColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_TEXT_COLOR default:@"FFFFFFFF"]] ;
            UIColor *qaHeaderHighlightColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_HIGHLIGHT_COLOR default:@"FF000000"]] ;
            
            voteButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 102, 29)] ;
            [voteButtonImageView setImage:voteButtonOnImage] ;
            [sectionHeaderView addSubview:voteButtonImageView] ;
            [VeamUtil registerTapAction:voteButtonImageView target:self selector:@selector(showQuestionsDateOrder)] ;
            
            voteButtonLabel = [[UILabel alloc] initWithFrame:voteButtonImageView.frame] ;
            [voteButtonLabel setBackgroundColor:[UIColor clearColor]] ;
            [voteButtonLabel setText:qaVoteButtonTitle] ;
            [voteButtonLabel setTextColor:qaHeaderHighlightColor] ;
            [voteButtonLabel setTextAlignment:NSTextAlignmentCenter] ;
            [voteButtonLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
            [sectionHeaderView addSubview:voteButtonLabel] ;
            
            
            rankingButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(109, 6, 102, 29)] ;
            [rankingButtonImageView setImage:rankingButtonOffImage] ;
            [sectionHeaderView addSubview:rankingButtonImageView] ;
            [VeamUtil registerTapAction:rankingButtonImageView target:self selector:@selector(showQuestionsRatingOrder)] ;
            
            rankingButtonLabel = [[UILabel alloc] initWithFrame:rankingButtonImageView.frame] ;
            [rankingButtonLabel setBackgroundColor:[UIColor clearColor]] ;
            [rankingButtonLabel setText:qaRankingButtonTitle] ;
            [rankingButtonLabel setTextColor:qaHeaderTextColor] ;
            [rankingButtonLabel setTextAlignment:NSTextAlignmentCenter] ;
            [rankingButtonLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
            [sectionHeaderView addSubview:rankingButtonLabel] ;

            
            answerButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(211, 6, 102, 29)] ;
            [answerButtonImageView setImage:answerButtonOffImage] ;
            [sectionHeaderView addSubview:answerButtonImageView] ;
            [VeamUtil registerTapAction:answerButtonImageView target:self selector:@selector(showAnswersDateOrder)] ;

            answerButtonLabel = [[UILabel alloc] initWithFrame:answerButtonImageView.frame] ;
            [answerButtonLabel setBackgroundColor:[UIColor clearColor]] ;
            [answerButtonLabel setText:qaAnswerButtonTitle] ;
            [answerButtonLabel setTextColor:qaHeaderTextColor] ;
            [answerButtonLabel setTextAlignment:NSTextAlignmentCenter] ;
            [answerButtonLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]] ;
            [sectionHeaderView addSubview:answerButtonLabel] ;
        }
        containerView = sectionHeaderView ;
    }
    return containerView ;
}

- (void)changeKind:(NSInteger)kind
{
    currentKind = kind ;
    if(sectionHeaderView != nil){
        
        UIColor *qaHeaderTextColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_TEXT_COLOR default:@"FFFFFFFF"]] ;
        UIColor *qaHeaderHighlightColor = [VeamUtil getColorFromArgbString:[VeamUtil getConfigurationString:VEAM_CONFIG_QA_HEADER_HIGHLIGHT_COLOR default:@"FF000000"]] ;

        switch (currentKind) {
            case VEAM_QUESTION_KIND_DATE:
                [voteButtonImageView setImage:voteButtonOnImage] ;
                [voteButtonLabel setTextColor:qaHeaderHighlightColor] ;
                
                [rankingButtonImageView setImage:rankingButtonOffImage] ;
                [rankingButtonLabel setTextColor:qaHeaderTextColor] ;
                
                [answerButtonImageView setImage:answerButtonOffImage] ;
                [answerButtonLabel setTextColor:qaHeaderTextColor] ;
                
                break;
            case VEAM_QUESTION_KIND_RATING:
                [voteButtonImageView setImage:voteButtonOffImage] ;
                [voteButtonLabel setTextColor:qaHeaderTextColor] ;

                [rankingButtonImageView setImage:rankingButtonOnImage] ;
                [rankingButtonLabel setTextColor:qaHeaderHighlightColor] ;

                [answerButtonImageView setImage:answerButtonOffImage] ;
                [answerButtonLabel setTextColor:qaHeaderTextColor] ;
                break;
            case VEAM_QUESTION_KIND_ANSWER_DATE:
                [voteButtonImageView setImage:voteButtonOffImage] ;
                [voteButtonLabel setTextColor:qaHeaderTextColor] ;

                [rankingButtonImageView setImage:rankingButtonOffImage] ;
                [rankingButtonLabel setTextColor:qaHeaderTextColor] ;

                [answerButtonImageView setImage:answerButtonOnImage] ;
                [answerButtonLabel setTextColor:qaHeaderHighlightColor] ;
                break;
                
            default:
                break;
        }
    }
    [qaListTableView reloadData] ;
}

- (void)showQuestionsDateOrder
{
    [self changeKind:VEAM_QUESTION_KIND_DATE] ;
}

- (void)showQuestionsRatingOrder
{
    [self changeKind:VEAM_QUESTION_KIND_RATING] ;
}

- (void)showAnswersDateOrder
{
    [self changeKind:VEAM_QUESTION_KIND_ANSWER_DATE] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //NSLog(@"%@::viewDidAppear",NSStringFromClass([self class])) ;

    if([VeamUtil getQuestionPosted]){
        [VeamUtil setQuestionPosted:NO] ;
        [self startUpdating] ;
    }
    
    if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
        if(!isBought){
            isBought = YES ;
            [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
        }
    }


}

- (void)askButtonTap
{
    [self operatePostQuestion] ;
}

- (void)operatePostQuestion
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_ASK ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
            if([VeamUtil isConnected]){
                PostQuestionViewController *postQuestionViewController = [[PostQuestionViewController alloc] initWithNibName:@"PostQuestionViewController" bundle:nil] ;
                [postQuestionViewController setTitleName:@"Ask"] ;
                [self.navigationController pushViewController:postQuestionViewController animated:YES] ;
            } else {
                [VeamUtil dispNotConnectedError] ;
            }
        } else {
            SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
            [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
            [subscriptionPurchaseViewController setTitle:@"About Subscription"] ;
            [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
            /*
            QAPurchaseViewController *qaPurchaseViewController = [[QAPurchaseViewController alloc] init] ;
            [qaPurchaseViewController setTitleName:@"About Subscription"] ;
            [self.navigationController pushViewController:qaPurchaseViewController animated:YES] ;
             */
        }
    }
}



-(void)updateQuestions
{
    @autoreleasepool
    {
        //NSLog(@"update questions start") ;
        isUpdating = YES ;
        NSURL *url = [VeamUtil getApiUrl:@"question/list"] ;
        
        NSInteger socialUserId = [VeamUtil getSocialUserId] ;
        
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d",socialUserId]] ;
        
        NSString *urlString = [NSString stringWithFormat:@"%@&p=%d&sid=%d&s=%@",[url absoluteString],currentPageNo,socialUserId,signature] ;
        
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"questions update url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            if(currentPageNo == 1){
                Questions *workQuestions = [[Questions alloc] init] ;
                [workQuestions parseWithData:data] ;
                questions = workQuestions ;
            } else {
                [[self getQuestionsForKind:currentKind] parseWithData:data] ; // add
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        isUpdating = NO ;
        //NSLog(@"update questions end") ;
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
}


- (void)reloadData
{
    //NSLog(@"reloadData") ;
    [updatingLabel setAlpha:0.0] ;
    [notificationIndicator setAlpha:0.0] ;
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
    [qaListTableView reloadData] ;
    CGRect frame = [qaListTableView frame] ;
    frame.origin.y = originalY ;
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3] ;
    [qaListTableView setAlpha:1.0] ;
    [qaListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
}

- (void)updateList
{
    [self reloadData] ;
}

-(void)contentsDidUpdate:(NSNotificationCenter*)notificationCenter
{
    [super contentsDidUpdate:notificationCenter] ;
    
    //NSLog(@"%@::contentsDidUpdate",NSStringFromClass([self class])) ;
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO] ;
}


- (void)hideIndicator
{
    [indicator stopAnimating] ;
    [indicator setAlpha:0.0] ;
}

- (void)startUpdating
{
    CGRect frame = [qaListTableView frame] ;
    frame.origin.y = originalY + [VeamUtil getTopBarHeight] ;
    [notificationIndicator startAnimating] ;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.5] ;
    [notificationIndicator setAlpha:1.0] ;
    [updatingLabel setAlpha:1.0] ;
    [qaListTableView setFrame:frame] ;
    [UIView commitAnimations] ;
    currentPageNo = 1 ;
    [self performSelectorInBackground:@selector(updateQuestions) withObject:nil] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = [scrollView contentOffset].y ;
    //NSLog(@"scrollViewDidEndDragging offset = %f",offsetY) ;
    
    if((offsetY < -50) && !isUpdating){
        //NSLog(@"update") ;
        [self startUpdating] ;
    }
}

- (void)setSectionHeaderMask:(BOOL)masked
{
    if(masked){
        if(!sectionHeaderMasked){
            if(sectionHeaderView != nil){
                UIColor *color = [VeamUtil getQuestionHeaderColor] ;
                CGFloat red ;
                CGFloat green ;
                CGFloat blue ;
                CGFloat alpha ;
                [color getRed:&red green:&green blue:&blue alpha:&alpha] ;
                UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0] ;
                [sectionHeaderView setBackgroundColor:newColor] ;
                sectionHeaderMasked = YES ;
            }
        }
    } else {
        if(sectionHeaderMasked){
            if(sectionHeaderView != nil){
                [sectionHeaderView setBackgroundColor:[VeamUtil getQuestionHeaderColor]] ;
                sectionHeaderMasked = NO ;
            }
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = [scrollView contentOffset].y ;
    //NSLog(@"scrollViewDidScroll offset = %f",offsetY) ;
    
    if((offsetY < -50) && !isUpdating){
        [instructionLabel setAlpha:1.0] ;
    } else {
        [instructionLabel setAlpha:0.0] ;
    }
    
    if(QA_HEADER_HEIGHT < scrollView.contentOffset.y){
        [self setSectionHeaderMask:YES] ;
    } else {
        [self setSectionHeaderMask:NO] ;
    }
}

- (void)onActionButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onActionButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    Question *question = [[self getQuestionsForKind:currentKind] getQuestionAt:tag kind:currentKind] ;
    BOOL isFreeAnswer = [question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_FREE_VIDEO] || [question.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_FREE_AUDIO] ;
    
    if(isFreeAnswer || [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
        //NSLog(@"question answerkind=%@",question.answerKind) ;
        if([self getAnswerKind:question] == VEAM_ANSWER_KIND_VIDEO){
            Video *video = [VeamUtil getVideoForId:[question answerId]] ;
            //NSLog(@"video id=%@",video.videoId) ;
            //Video *video = [[self getQuestionsForKind:currentKind] getVideoForid:[question answerId]] ;
            if([VeamUtil videoExists:video]){
                    // play answer
                NSString *title = [VeamUtil getAnswerDateString:[question answeredAt]] ;
                [VeamUtil playVideo:video title:title] ;
            } else {
                // confirm download
                currentVideo = video ;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"download_this_video",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
                [alert setTag:ALERT_VIEW_TAG_DOWNLOAD] ;
                [alert show];
            }
        } else if([self getAnswerKind:question] == VEAM_ANSWER_KIND_AUDIO){
            //NSLog(@"audio") ;
            Audio *audio = [VeamUtil getAudioForId:question.answerId] ;
            if(audio != nil){
                NSString *title = [VeamUtil getAnswerDateString:[question answeredAt]] ;
                [VeamUtil playAudio:audio title:title] ;
            }
        }
    } else {
        SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
        [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
        [subscriptionPurchaseViewController setTitle:@"About Subscription"] ;
        [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
        /*
        QAPurchaseViewController *qaPurchaseViewController = [[QAPurchaseViewController alloc] init] ;
        [qaPurchaseViewController setTitleName:@"About Subscription"] ;
        [self.navigationController pushViewController:qaPurchaseViewController animated:YES] ;
         */
    }
}

- (void)onDeleteButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onDeleteButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    Question *question = [[self getQuestionsForKind:currentKind] getQuestionAt:tag kind:currentKind] ;
    Video *video = [VeamUtil getVideoForId:[question answerId]] ;
    //NSLog(@"remove video file") ;
    currentVideo = video ;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"eliminate file from internal storage?\n( no charge for re-downloading )" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:@"OK", nil] ;
    [alert setTag:ALERT_VIEW_TAG_REMOVE] ;
    [alert show] ;
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"clicked button index %d",buttonIndex) ;
    if([alertView tag] == ALERT_VIEW_TAG_DOWNLOAD){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
            {
                // OK
                // start downloading
                /*
                Video *downloadableVideo = [[Video alloc] init] ;
                [downloadableVideo setVideoId:[currentVideo videoId]] ;
                [downloadableVideo setVideoUrl:[currentVideo dataUrl]] ;
                [downloadableVideo setVideoSize:[currentVideo dataSize]] ;
                 */
                
                //NSLog(@"download video from %@",currentVideo.dataUrl) ;
                previewDownloader = [[PreviewDownloader alloc]
                                     initWithDownloadableVideo:currentVideo
                                     dialogTitle:NSLocalizedString(@"PreviewDownloadTitie", nil)
                                     dialogDescription:NSLocalizedString(@"PreviewDownloadDescription",nil)
                                     dialogCancelText:NSLocalizedString(@"cancel",nil)
                                     ] ;
                
                previewDownloader.delegate = self ;
            }
                break;
        }
    } else if([alertView tag] == ALERT_VIEW_TAG_REMOVE){
        switch (buttonIndex) {
            case 0:
                // cancel
                break;
            case 1:
                // OK
                [VeamUtil removeVideoFile:[currentVideo videoId]] ;
                [self reloadData] ;
                break;
        }
    }
}

-(void) previewDownloadCompleted:(Video *)downloadableVideo
{
    //NSLog(@"download completed. play movie") ;
    //[self trackEvent:[NSString stringWithFormat:@"PreviewDownloadComplete-%@",contentId]] ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
    [self reloadData] ;
}

-(void) previewDownloadCancelled:(Video *)downloadableVideo
{
    //NSLog(@"download cancelled.") ;
    //[self trackEvent:[NSString stringWithFormat:@"PreviewDownloadCancel-%@",contentId]] ;
    if(previewDownloader != nil){
        previewDownloader.delegate = nil ;
    }
}




- (void)onLikeButtonTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    NSInteger tag = [[singleTapGesture view] tag] ;
    //NSLog(@"onLikeButtonTap tag=%d",tag) ;
    
    if(tag < 0){
        return ;
    }
    
    if(![VeamUtil isConnected]){
        [VeamUtil dispNotConnectedError] ;
        return ;
    }
    
    if(isLikeSending){
        return ;
    }
    
    
    // 押されたらとりあえず変更する
    UIImageView *imageView = (UIImageView *)[singleTapGesture view] ;
    Question *question = [[self getQuestionsForKind:currentKind] getQuestionAt:tag kind:currentKind] ;
    if([[self getQuestionsForKind:currentKind] isLike:[question questionId]]){
        [imageView setImage:likeOffImage] ; // TODO use theme image
    } else {
        [imageView setImage:likeOnImage] ;
    }
    
    [self operateLikeButton:tag] ;
}

- (void)operateLikeButton:(NSInteger)tag
{
    if(![VeamUtil isLoggedIn]){
        pendingOperation = VEAM_PENDING_OPERATION_LIKE ;
        pendingTag = tag ;
        [[AppDelegate sharedInstance] setLoginPendingOperationDelegate:self] ;
        [VeamUtil login] ;
    } else {
        if([VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]]){
            currentQuestion = [[self getQuestionsForKind:currentKind] getQuestionAt:tag kind:currentKind] ;
            if([VeamUtil isConnected]){
                //NSLog(@"call likeCurrentPicture") ;
                [self performSelectorInBackground:@selector(likeCurrentQuestion) withObject:nil] ;
            } else {
                [VeamUtil dispNotConnectedError] ;
            }
        } else {
            SubscriptionPurchaseViewController *subscriptionPurchaseViewController = [[SubscriptionPurchaseViewController alloc] init] ;
            [subscriptionPurchaseViewController setTitleName:NSLocalizedString(@"about_subscription",nil)] ;
            [subscriptionPurchaseViewController setTitle:@"About Subscription"] ;
            [self.navigationController pushViewController:subscriptionPurchaseViewController animated:YES] ;
            /*
            QAPurchaseViewController *qaPurchaseViewController = [[QAPurchaseViewController alloc] init] ;
            [qaPurchaseViewController setTitleName:@"About Subscription"] ;
            [self.navigationController pushViewController:qaPurchaseViewController animated:YES] ;
             */
        }
    }
}

- (void)likeCurrentQuestion
{
    @autoreleasepool
    {
        isLikeSending = YES ;
        //NSLog(@"likeCurrentQuestion") ;
        Question *question = currentQuestion ;
        BOOL isLike = [[self getQuestionsForKind:currentKind] isLike:[question questionId]] ;
        NSInteger likeValue = 1 ;
        if(isLike){
            likeValue = 0 ;
        }
        
        NSString *questionId = [question questionId] ;
        NSInteger socialUserid = [VeamUtil getSocialUserId] ;
        
        NSURL *url = [VeamUtil getApiUrl:@"question/like"] ;
        NSString *signature = [VeamUtil sha1:[NSString stringWithFormat:@"VEAM_%d_%@_%d",socialUserid,questionId,likeValue]] ;
        NSString *urlString = [NSString stringWithFormat:@"%@&q=%@&sid=%d&l=%d&s=%@",[url absoluteString],questionId,socialUserid,likeValue,signature] ;
        url = [NSURL URLWithString:urlString] ;
        //NSLog(@"like url : %@",[url absoluteString]) ;
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        NSURLResponse *response = nil ;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0 == [error_str length]) {
            NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            //NSLog(@"resultString=%@",resultString) ;
            NSArray *results = [resultString componentsSeparatedByString:@"\n"];
            if([results count] >= 1){
                if([[results objectAtIndex:0] isEqualToString:@"OK"]){
                    [[self getQuestionsForKind:currentKind] setIsLike:!isLike questionId:[question questionId]] ;
                }
            }
        } else {
            NSLog(@"error=%@",error_str) ;
        }
        //NSLog(@"likeCurrentQuestion end") ;
        if(needUpdate){
            needUpdate = NO ;
            [self performSelectorOnMainThread:@selector(startUpdating) withObject:nil waitUntilDone:NO] ;
        } else {
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO] ;
        }
        isLikeSending = NO ;
    }
}

- (void)doPendingOperation
{
    if(pendingOperation == VEAM_PENDING_OPERATION_ASK){
        pendingOperation = 0 ;
        [self performSelectorOnMainThread:@selector(operatePostQuestion) withObject:nil waitUntilDone:NO] ;
        //[self operateCameraButton] ;
    } else if(pendingOperation == VEAM_PENDING_OPERATION_LIKE){
        pendingOperation = 0 ;
        needUpdate = YES ;
        [self operateLikeButton:pendingTag] ;
    }
}




@end
