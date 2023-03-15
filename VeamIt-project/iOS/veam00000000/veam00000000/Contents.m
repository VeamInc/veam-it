//
//  Contents.m
//  veam31000000
//
//  Created by veam on 7/10/13.
//  Copyright (c) 2013 veam. All rights reserved.
//

#import "Contents.h"
#import "VeamUtil.h"

@implementation Contents


- (id)initWithResourceFile
{
    // load content
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    NSString *contentsStorePath = [VeamUtil getFilePathAtCachesDirectory:VEAM_CONTENTS_FILE_NAME] ;
    if (![fileManager fileExistsAtPath:contentsStorePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:VEAM_DEFAULT_CONTENTS_FILE_NAME ofType:nil] ;
        if(defaultStorePath){
            //NSLog(@"copy contents") ;
            [fileManager copyItemAtPath:defaultStorePath toPath:contentsStorePath error:NULL];
        }
    }
    //NSLog(@"config url : %@",contentsStorePath) ;
    NSURL *contentsFileUrl = [NSURL fileURLWithPath:contentsStorePath] ;
    return [self initWithUrl:contentsFileUrl] ;
}

- (id)initWithUrl:(NSURL *)url ;
{
    self = [super init] ;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url] ;
    [self startParsing:parser] ;
    
    return self ;
}

- (id)initWithServerData
{
    NSString *urlString  = [NSString stringWithFormat:@"%@&c=%@",[VeamUtil getApiUrl:@"content/list"],[self getStoredContentId]] ;
	//NSLog(@"urlString String url = %@",urlString) ;
    NSURL *url = [NSURL URLWithString:urlString] ;
    //NSLog(@"update url : %@",[url absoluteString]) ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    NSURLResponse *response = nil ;
    NSError *error = nil ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] ;
    
    // error
    NSString *error_str = [error localizedDescription] ;
    if (0 == [error_str length]) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        if(![string isEqualToString:@"NO_UPDATE"]){
            return [self initWithData:data] ; // analyze sync
        }
    }
    
    return [self init] ;
}

- (id)init
{
    self = [super init] ;
    return self ;
}


- (id)initWithData:(NSData *)data
{
    self = [super init] ;
    
    xmlData = data ;

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data] ;
    [self startParsing:parser] ;

    return self ;
}

- (void)startParsing:(NSXMLParser *)parser
{
    [self setup] ;
    
    isParsing = YES ;
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError) {
        //NSLog(@"error: %@", parseError);
    }
}

- (void)setup
{
    
    dictionary = [NSMutableDictionary dictionary] ;
    
    // forum
    forums = [[NSMutableArray alloc] init] ;
    
    // youtube
    youtubeCategories = [[NSMutableArray alloc] init] ;
    youtubeSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    youtubesPerSubCategory = [NSMutableDictionary dictionary] ;
    youtubesForYoutubeId = [NSMutableDictionary dictionary] ;
    
    // question(answer)
    answers = [[NSMutableArray alloc] init] ;

    // mixed
    mixedCategories = [[NSMutableArray alloc] init] ;
    mixedSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    mixedsPerSubCategory = [NSMutableDictionary dictionary] ;
    mixedsForMixedId = [NSMutableDictionary dictionary] ;
    
    // video
    videoCategories = [[NSMutableArray alloc] init] ;
    videoSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    videosPerSubCategory = [NSMutableDictionary dictionary] ;
    videosForVideoId = [NSMutableDictionary dictionary] ;
    sellVideos = [[NSMutableArray alloc] init] ;
    
    // PDF
    pdfCategories = [[NSMutableArray alloc] init] ;
    pdfSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    pdfsPerSubCategory = [NSMutableDictionary dictionary] ;
    pdfsForPdfId = [NSMutableDictionary dictionary] ;
    sellPdfs = [[NSMutableArray alloc] init] ;
    
    
    // audio
    audioCategories = [[NSMutableArray alloc] init] ;
    audioSubCategoriesPerCategory = [NSMutableDictionary dictionary] ;
    audiosPerSubCategory = [NSMutableDictionary dictionary] ;
    audiosForAudioId = [NSMutableDictionary dictionary] ;
    sellAudios = [[NSMutableArray alloc] init] ;
    

    
    // recipe
    recipeCategories = [[NSMutableArray alloc] init] ;
    recipesPerCategory = [NSMutableDictionary dictionary] ;
    recipesForId = [NSMutableDictionary dictionary] ;
    
    // web
    webs = [[NSMutableArray alloc] init] ;
    websPerCategory = [NSMutableDictionary dictionary] ;
    
    // etc
    alternativeImages = [[NSMutableArray alloc] init] ;
    alternativeImagesForFileName = [NSMutableDictionary dictionary] ;

    sellItemCategories = [[NSMutableArray alloc] init] ;
    
    
    // sell section
    sellSectionCategories = [[NSMutableArray alloc] init] ;
    sellSectionItemsForSellSectionItemId = [NSMutableDictionary dictionary] ;
    sellSectionItems = [[NSMutableArray alloc] init] ;


    /*
     newYoutubeVideos = [[NSMutableArray alloc] init] ;
     downloadableVideosForYearMonth = [NSMutableDictionary dictionary] ;
     downloadableVideos = [[NSMutableArray alloc] init] ;
     bulletins = [[NSMutableArray alloc] init] ;
     weekdayTexts = [[NSMutableArray alloc] init] ;
     
     textlineCategories = [[NSMutableArray alloc] init] ;
     textlines = [[Textlines alloc] init] ;
     textlinesForYear = [NSMutableDictionary dictionary] ;
     latestTextline = nil ;
     latestTextlineTime = 0 ;
     
     textlinePackages = [[NSMutableArray alloc] init] ;
     */
}


- (BOOL)isValid
{
    BOOL retValue = NO ;
    NSString *checkValue = [self getValueForKey:@"check"] ;
    if(![VeamUtil isEmpty:checkValue] && [checkValue isEqualToString:@"OK"]){
        retValue = YES ;
    }
    return retValue ;
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Contents::parserDidStartDocument") ;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    //NSLog(@"elementName=%@",elementName) ;
    
    if([elementName isEqualToString:@"content"]){
        contentId = [attributeDict objectForKey:@"id"] ;
        //////// forum
    } else if([elementName isEqualToString:@"forum"]){
        Forum *forum = [[Forum alloc] initWithAttributes:attributeDict] ;
        [forums addObject:forum] ;
        //NSLog(@"add forum : %@ %@",[forum forumId],[forum forumName]) ;
        
        //// subscription
    } else if([elementName isEqualToString:@"template_subscription"]){
        templateSubscription = [[TemplateSubscription alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_subscription : %@ %@",[templateSubscription title],templateSubscription.kind) ;
        
        //// youtube
    } else if([elementName isEqualToString:@"template_youtube"]){
        templateYoutube = [[TemplateYoutube alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_youtube : %@",[templateYoutube title]) ;
        
    } else if([elementName isEqualToString:@"youtube_category"]){
        YoutubeCategory *youtubeCategory = [[YoutubeCategory alloc] initWithAttributes:attributeDict] ;
        [youtubeCategories addObject:youtubeCategory] ;
        //NSLog(@"add category : %@",[category name]) ;
        
    } else if([elementName isEqualToString:@"youtube_sub_category"]){
        YoutubeSubCategory *youtubeSubCategory = [[YoutubeSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *youtubeCategoryId = [youtubeSubCategory youtubeCategoryId] ;
        
        NSMutableArray *subCategories = [youtubeSubCategoriesPerCategory objectForKey:youtubeCategoryId] ;
        if(subCategories == nil){
            subCategories = [[NSMutableArray alloc] init] ;
            [youtubeSubCategoriesPerCategory setObject:subCategories forKey:youtubeCategoryId] ;
        }
        [subCategories addObject:youtubeSubCategory] ;
        //NSLog(@"add sub category : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
        
    } else if([elementName isEqualToString:@"youtube"]){
        Youtube *youtube = [[Youtube alloc] initWithAttributes:attributeDict] ;
        
        NSString *youtubeSubCategoryId = [attributeDict objectForKey:@"s"] ;
        
        NSMutableArray *youtubes = [youtubesPerSubCategory objectForKey:youtubeSubCategoryId] ;
        if(youtubes == nil){
            youtubes = [[NSMutableArray alloc] init] ;
            [youtubesPerSubCategory setObject:youtubes forKey:youtubeSubCategoryId] ;
        }
        [youtubes addObject:youtube] ;
        [youtubesForYoutubeId setObject:youtube forKey:[youtube youtubeId]] ;
        //NSLog(@"add youtube video : %@ %@ %@",[youtube youtubeId],[youtube categoryId],[youtube subCategoryId]) ;
        
        
        //// mixed
    } else if([elementName isEqualToString:@"template_mixed"]){
        templateMixed = [[TemplateMixed alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_mixed : %@",[templateMixed title]) ;
        
    } else if([elementName isEqualToString:@"mixed_category"]){
        MixedCategory *mixedCategory = [[MixedCategory alloc] initWithAttributes:attributeDict] ;
        [mixedCategories addObject:mixedCategory] ;
        //NSLog(@"add category : %@",[category name]) ;
        
    } else if([elementName isEqualToString:@"mixed_sub_category"]){
        MixedSubCategory *mixedSubCategory = [[MixedSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *mixedCategoryId = [mixedSubCategory mixedCategoryId] ;
        
        NSMutableArray *subCategories = [mixedSubCategoriesPerCategory objectForKey:mixedCategoryId] ;
        if(subCategories == nil){
            subCategories = [[NSMutableArray alloc] init] ;
            [mixedSubCategoriesPerCategory setObject:subCategories forKey:mixedCategoryId] ;
        }
        [subCategories addObject:mixedSubCategory] ;
        //NSLog(@"add sub category : %@ %@",[subCategory subCategoryId],[subCategory name]) ;
        
        /*
    } else if([elementName isEqualToString:@"mixed"]){
        Mixed *mixed = [[Mixed alloc] initWithAttributes:attributeDict] ;
        
        NSString *mixedSubCategoryId = [attributeDict objectForKey:@"s"] ;
        
        NSMutableArray *mixeds = [mixedsPerSubCategory objectForKey:mixedSubCategoryId] ;
        if(mixeds == nil){
            mixeds = [[NSMutableArray alloc] init] ;
            [mixedsPerSubCategory setObject:mixeds forKey:mixedSubCategoryId] ;
        }
        [mixeds addObject:mixed] ;
        [mixedsForMixedId setObject:mixed forKey:[mixed mixedId]] ;
        //NSLog(@"add mixed video : %@ %@ %@",[mixed mixedId],[mixed categoryId],[mixed subCategoryId]) ;
        */
        
        //// sell item category
    } else if([elementName isEqualToString:@"sell_item_category"]){
        SellItemCategory *sellItemCategory = [[SellItemCategory alloc] initWithAttributes:attributeDict] ;
        [sellItemCategories addObject:sellItemCategory] ;
        //NSLog(@"add sell item category : %@ %@",[sellItemCategory kind],[sellItemCategory targetCategoryId]) ;
        
    } else if([elementName isEqualToString:@"sell_section_category"]){
        SellSectionCategory *sellSectionCategory = [[SellSectionCategory alloc] initWithAttributes:attributeDict] ;
        [sellSectionCategories addObject:sellSectionCategory] ;
        //NSLog(@"add sell Section category : %@ %@",[sellSectionCategory kind],[sellSectionCategory name]) ;
        
    } else if([elementName isEqualToString:@"sell_section_item"]){
        SellSectionItem *sellSectionItem = [[SellSectionItem alloc] init] ;
        [sellSectionItem setSellSectionItemId:[attributeDict objectForKey:@"id"]] ;
        [sellSectionItem setContentId:[attributeDict objectForKey:@"v"]] ;
        [sellSectionItem setSellSectionCategoryId:[attributeDict objectForKey:@"c"]] ;
        [sellSectionItem setSellSectionSubCategoryId:[attributeDict objectForKey:@"s"]] ;
        [sellSectionItem setKind:[attributeDict objectForKey:@"k"]] ;
        [sellSectionItem setTitle:[attributeDict objectForKey:@"t"]] ;
        
        [sellSectionItemsForSellSectionItemId setObject:sellSectionItem forKey:sellSectionItem.sellSectionItemId] ;
        [sellSectionItems addObject:sellSectionItem] ;
        
        //NSLog(@"add sell section item : %@ %@",[sellSectionItem sellSectionCategoryId],[sellSectionItem title]) ;
        
        //// video
    } else if([elementName isEqualToString:@"video_category"]){
        VideoCategory *videoCategory = [[VideoCategory alloc] initWithAttributes:attributeDict] ;
        [videoCategories addObject:videoCategory] ;
        //NSLog(@"add video category : %@ %@",[videoCategory categoryId],[videoCategory name]) ;
        
    } else if([elementName isEqualToString:@"video_sub_category"]){
        VideoSubCategory *videoSubCategory = [[VideoSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *videoCategoryId = [videoSubCategory videoCategoryId] ;
        
        NSMutableArray *videoSubCategories = [videoSubCategoriesPerCategory objectForKey:videoCategoryId] ;
        if(videoSubCategories == nil){
            videoSubCategories = [[NSMutableArray alloc] init] ;
            [videoSubCategoriesPerCategory setObject:videoSubCategories forKey:videoCategoryId] ;
        }
        [videoSubCategories addObject:videoSubCategory] ;
        //NSLog(@"add video sub category : %@ %@",[videoSubCategory subCategoryId],[videoSubCategory name]) ;
        
    } else if([elementName isEqualToString:@"video"]){
        Video *video = [[Video alloc] initWithAttributes:attributeDict] ;
        NSString *videoSubCategoryId = [video videoSubCategoryId] ;
        [self addMixed:video.mixed] ;
        
        NSMutableArray *videos = [videosPerSubCategory objectForKey:videoSubCategoryId] ;
        if(videos == nil){
            videos = [[NSMutableArray alloc] init] ;
            [videosPerSubCategory setObject:videos forKey:videoSubCategoryId] ;
        }
        [videos addObject:video] ;
        [videosForVideoId setObject:video forKey:[video videoId]] ;
        //NSLog(@"add video : %@ createdAt=%@ %@",video.title,video.createdAt,video.dataUrl) ;

        //// audio
    } else if([elementName isEqualToString:@"sell_video"]){
        SellVideo *sellVideo = [[SellVideo alloc] init] ;
        [sellVideo setSellVideoId:[attributeDict objectForKey:@"id"]] ;
        [sellVideo setVideoId:[attributeDict objectForKey:@"v"]] ;
        [sellVideo setProductId:[attributeDict objectForKey:@"pro"]] ;
        [sellVideo setPrice:[attributeDict objectForKey:@"pri"]] ;
        [sellVideo setPriceText:[attributeDict objectForKey:@"ptx"]] ;
        NSString *description = [attributeDict objectForKey:@"des"] ;
        
        if([VeamUtil isEmpty:description]){
            description = @"" ;
        }
        [sellVideo setDescription:description] ;
        
        NSString *button = [attributeDict objectForKey:@"but"] ;
        if([VeamUtil isEmpty:button]){
            button = @"" ;
        }
        [sellVideo setButtonText:button] ;
        
        [sellVideos addObject:sellVideo] ;
        
       //NSLog(@"add sell video : %@ %@",[sellVideo videoId],[sellVideo buttonText]) ;
        
        //// PDF
    } else if([elementName isEqualToString:@"pdf_category"]){
        PdfCategory *pdfCategory = [[PdfCategory alloc] initWithAttributes:attributeDict] ;
        [pdfCategories addObject:pdfCategory] ;
        //NSLog(@"add pdf category : %@ %@",[pdfCategory categoryId],[pdfCategory name]) ;
        
    } else if([elementName isEqualToString:@"pdf_sub_category"]){
        PdfSubCategory *pdfSubCategory = [[PdfSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *pdfCategoryId = [pdfSubCategory pdfCategoryId] ;
        
        NSMutableArray *pdfSubCategories = [pdfSubCategoriesPerCategory objectForKey:pdfCategoryId] ;
        if(pdfSubCategories == nil){
            pdfSubCategories = [[NSMutableArray alloc] init] ;
            [pdfSubCategoriesPerCategory setObject:pdfSubCategories forKey:pdfCategoryId] ;
        }
        [pdfSubCategories addObject:pdfSubCategory] ;
        //NSLog(@"add video sub category : %@ %@",[videoSubCategory subCategoryId],[videoSubCategory name]) ;
        
    } else if([elementName isEqualToString:@"pdf"]){
        Pdf *pdf = [[Pdf alloc] initWithAttributes:attributeDict] ;
        NSString *pdfSubCategoryId = [pdf pdfSubCategoryId] ;
        //[self addMixed:pdf.mixed] ;
        
        NSMutableArray *pdfs = [pdfsPerSubCategory objectForKey:pdfSubCategoryId] ;
        if(pdfs == nil){
            pdfs = [[NSMutableArray alloc] init] ;
            [pdfsPerSubCategory setObject:pdfs forKey:pdfSubCategoryId] ;
        }
        [pdfs addObject:pdf] ;
        [pdfsForPdfId setObject:pdf forKey:[pdf pdfId]] ;
        //NSLog(@"add pdf : %@ createdAt=%@ %@",pdf.title,pdf.createdAt,pdf.dataUrl) ;
        
        //// audio
    } else if([elementName isEqualToString:@"sell_pdf"]){
        SellPdf *sellPdf = [[SellPdf alloc] init] ;
        [sellPdf setSellPdfId:[attributeDict objectForKey:@"id"]] ;
        [sellPdf setPdfId:[attributeDict objectForKey:@"v"]] ;
        [sellPdf setProductId:[attributeDict objectForKey:@"pro"]] ;
        [sellPdf setPrice:[attributeDict objectForKey:@"pri"]] ;
        [sellPdf setPriceText:[attributeDict objectForKey:@"ptx"]] ;
        NSString *description = [attributeDict objectForKey:@"des"] ;
        
        if([VeamUtil isEmpty:description]){
            description = @"" ;
        }
        [sellPdf setDescription:description] ;
        
        NSString *button = [attributeDict objectForKey:@"but"] ;
        if([VeamUtil isEmpty:button]){
            button = @"" ;
        }
        [sellPdf setButtonText:button] ;
        
        [sellPdfs addObject:sellPdf] ;
        
        //NSLog(@"add sell Pdf : %@ %@",[sellPdf pdfId],[sellPdf buttonText]) ;

    } else if([elementName isEqualToString:@"sell_audio"]){
        SellAudio *sellAudio = [[SellAudio alloc] init] ;
        [sellAudio setSellAudioId:[attributeDict objectForKey:@"id"]] ;
        [sellAudio setAudioId:[attributeDict objectForKey:@"v"]] ;
        [sellAudio setProductId:[attributeDict objectForKey:@"pro"]] ;
        [sellAudio setPrice:[attributeDict objectForKey:@"pri"]] ;
        [sellAudio setPriceText:[attributeDict objectForKey:@"ptx"]] ;
        NSString *description = [attributeDict objectForKey:@"des"] ;
        
        if([VeamUtil isEmpty:description]){
            description = @"" ;
        }
        [sellAudio setDescription:description] ;
        
        NSString *button = [attributeDict objectForKey:@"but"] ;
        if([VeamUtil isEmpty:button]){
            button = @"" ;
        }
        [sellAudio setButtonText:button] ;
        
        [sellAudios addObject:sellAudio] ;
        
        //NSLog(@"add sell Audio : %@ %@",[sellAudio audioId],[sellAudio buttonText]) ;
        
    } else if([elementName isEqualToString:@"audio_category"]){
        AudioCategory *audioCategory = [[AudioCategory alloc] initWithAttributes:attributeDict] ;
        [audioCategories addObject:audioCategory] ;
        //NSLog(@"add audio category : %@ %@",audioCategory.audioCategoryId,audioCategory.name) ;
        
    } else if([elementName isEqualToString:@"audio_sub_category"]){
        AudioSubCategory *audioSubCategory = [[AudioSubCategory alloc] initWithAttributes:attributeDict] ;
        NSString *audioCategoryId = [audioSubCategory audioCategoryId] ;
        
        NSMutableArray *audioSubCategories = [audioSubCategoriesPerCategory objectForKey:audioCategoryId] ;
        if(audioSubCategories == nil){
            audioSubCategories = [[NSMutableArray alloc] init] ;
            [audioSubCategoriesPerCategory setObject:audioSubCategories forKey:audioCategoryId] ;
        }
        [audioSubCategories addObject:audioSubCategory] ;
        //NSLog(@"add audio sub category : %@ %@",[audioSubCategory subCategoryId],[audioSubCategory name]) ;
        
    } else if([elementName isEqualToString:@"audio"]){
        Audio *audio = [[Audio alloc] initWithAttributes:attributeDict] ;
        NSString *audioSubCategoryId = [audio audioSubCategoryId] ;
        [self addMixed:audio.mixed] ;
        
        NSMutableArray *audios = [audiosPerSubCategory objectForKey:audioSubCategoryId] ;
        if(audios == nil){
            audios = [[NSMutableArray alloc] init] ;
            [audiosPerSubCategory setObject:audios forKey:audioSubCategoryId] ;
        }
        [audios addObject:audio] ;
        [audiosForAudioId setObject:audio forKey:[audio audioId]] ;
        //NSLog(@"add audio : %@ rectangleImage=%@ %@",audio.title,audio.rectangleImageUrl,audio.dataUrl) ;
        
    } else if([elementName isEqualToString:@"recipe_category"]){
        RecipeCategory *recipeCategory = [[RecipeCategory alloc] initWithAttributes:attributeDict] ;
        [recipeCategories addObject:recipeCategory] ;
        //NSLog(@"add recipe category : %@ %@",[recipeCategory recipeCategoryId],[recipeCategory name]) ;
        
    } else if([elementName isEqualToString:@"recipe"]){
        Recipe *recipe = [[Recipe alloc] initWithAttributes:attributeDict] ;
        [self addMixed:recipe.mixed] ;
        NSString *recipeCategoryId = [recipe recipeCategoryId] ;
        
        NSMutableArray *recipes = [recipesPerCategory objectForKey:recipeCategoryId] ;
        if(recipes == nil){
            recipes = [[NSMutableArray alloc] init] ;
            [recipesPerCategory setObject:recipes forKey:recipeCategoryId] ;
        }
        [recipes addObject:recipe] ;
        [recipesForId setObject:recipe forKey:[recipe recipeId]] ;
        //NSLog(@"add recipe : %@ %@",[recipe recipeCategoryId],[recipe title]) ;

        // web
    } else if([elementName isEqualToString:@"template_web"]){
        templateWeb = [[TemplateWeb alloc] initWithAttributes:attributeDict] ;
        //NSLog(@"add template_web : %@",[templateWeb title]) ;
        
    } else if([elementName isEqualToString:@"web"]){
        Web *web = [[Web alloc] initWithAttributes:attributeDict] ;
        [webs addObject:web] ;
        
        NSString *webCategoryId = [web webCategoryId] ;
        if(webCategoryId != nil){
            NSMutableArray *workWebs = [websPerCategory objectForKey:webCategoryId] ;
            if(workWebs == nil){
                workWebs = [[NSMutableArray alloc] init] ;
                [websPerCategory setObject:workWebs forKey:webCategoryId] ;
            }
            [workWebs addObject:web] ;
        }
        
        //NSLog(@"add web : %@ %@",[web webId],[web title]) ;
        
    } else if([elementName isEqualToString:@"alternative_image"]){
        AlternativeImage *alternativeImage = [[AlternativeImage alloc] initWithAttributes:attributeDict] ;
        if(![VeamUtil isStoredAlternativeImage:alternativeImage.alternativeImageId]){
            [alternativeImages addObject:alternativeImage] ;
            [alternativeImagesForFileName setObject:alternativeImage forKey:[alternativeImage fileName]] ;
            //NSLog(@"add alternative image : %@ %@ %@",[alternativeImage alternativeImageId],[alternativeImage fileName],[alternativeImage url]) ;
        }
        
        
    } else if([elementName isEqualToString:@"question"]){
        // <question id="3" kind="2" u="22" n="veam03" q="Test3" l="2" ak="0" aid="0" at="0" ct="1398154755" />
        Question *question = [[Question alloc] initWithAttributes:attributeDict] ;
        [answers addObject:question] ;
        
    } else if([elementName isEqualToString:@"free_answer"]){
        // <question id="3" kind="2" u="22" n="veam03" q="Test3" l="2" ak="0" aid="0" at="0" ct="1398154755" />
        Question *question = [[Question alloc] initWithAttributes:attributeDict] ;
        [answers addObject:question] ;
        
        /*
        //// textline
    } else if([elementName isEqualToString:@"textline_category"]){
        TextlineCategory *textlineCategory = [[TextlineCategory alloc] init] ;
        [textlineCategory setCategoryId:[attributeDict objectForKey:@"id"]] ;
        [textlineCategory setName:[attributeDict objectForKey:@"name"]] ;
        [textlineCategory setPrefix:[attributeDict objectForKey:@"pre"]] ;
        [textlineCategories addObject:textlineCategory] ;
        //NSLog(@"add textline category : %@ %@",[textlineCategory categoryId],[textlineCategory prefix]) ;
        
    } else if([elementName isEqualToString:@"monthly_video"]){
        DownloadableVideo *downloadableVideo = [[DownloadableVideo alloc] init] ;
        NSString *yearMonth = [attributeDict objectForKey:@"ym"] ;
        if(yearMonth == nil){
            yearMonth = @"" ;
        }
        [downloadableVideo setDownloadableVideoId:[attributeDict objectForKey:@"id"]] ;
        [downloadableVideo setDuration:[attributeDict objectForKey:@"d"]] ;
        [downloadableVideo setTitle:[attributeDict objectForKey:@"t"]] ;
        [downloadableVideo setImageUrl:[attributeDict objectForKey:@"i"]] ;
        [downloadableVideo setImageSize:[attributeDict objectForKey:@"is"]] ;
        [downloadableVideo setVideoUrl:[attributeDict objectForKey:@"v"]] ;
        [downloadableVideo setVideoSize:[attributeDict objectForKey:@"vs"]] ;
        [downloadableVideo setVideoKey:[attributeDict objectForKey:@"vk"]] ;
        [downloadableVideo setYearMonth:yearMonth] ;
        
        [downloadableVideos addObject:downloadableVideo] ;
        
        NSMutableArray *array = [downloadableVideosForYearMonth objectForKey:yearMonth] ;
        if(array == nil){
            array = [[NSMutableArray alloc] init] ;
            [downloadableVideosForYearMonth setObject:array forKey:yearMonth] ;
        }
        [array addObject:downloadableVideo] ;
        
        //NSLog(@"add downloadable video : %@ %@",[downloadableVideo downloadableVideoId],[downloadableVideo title]) ;
    } else if([elementName isEqualToString:@"bulletin"]){
        Bulletin *bulletin = [[Bulletin alloc] init] ;
        [bulletin setBulletinId:[attributeDict objectForKey:@"id"]] ;
        [bulletin setKind:[attributeDict objectForKey:@"k"]] ;
        [bulletin setIndex:[attributeDict objectForKey:@"i"]] ;
        [bulletin setBackgroundColor:[attributeDict objectForKey:@"b"]] ;
        [bulletin setTextColor:[attributeDict objectForKey:@"t"]] ;
        [bulletin setMessage:[attributeDict objectForKey:@"m"]] ;
        [bulletin setImageUrl:[attributeDict objectForKey:@"u"]] ;
        [bulletin setStartAt:[attributeDict objectForKey:@"s"]] ;
        [bulletin setEndAt:[attributeDict objectForKey:@"e"]] ;
        [bulletins addObject:bulletin] ;
        //NSLog(@"add bulletin : %@ %@",[bulletin bulletinId],[bulletin message]) ;
    } else if([elementName isEqualToString:@"wdtext"]){
        WeekdayText *weekdayText = [[WeekdayText alloc] init] ;
        [weekdayText setWeekdayTextId:[attributeDict objectForKey:@"id"]] ;
        [weekdayText setStartAt:[attributeDict objectForKey:@"s"]] ;
        [weekdayText setEndAt:[attributeDict objectForKey:@"e"]] ;
        [weekdayText setWeekday:[attributeDict objectForKey:@"w"]] ;
        [weekdayText setAction:[attributeDict objectForKey:@"a"]] ;
        [weekdayText setTitle:[attributeDict objectForKey:@"t"]] ;
        [weekdayText setDescription:[attributeDict objectForKey:@"d"]] ;
        [weekdayText setLinkUrl:[attributeDict objectForKey:@"l"]] ;
        [weekdayTexts addObject:weekdayText] ;
        //NSLog(@"add weekdayText : %@ %@",[weekdayText weekdayTextId],[weekdayText title]) ;
        
    } else if([elementName isEqualToString:@"textline"]){
        Textline *textline = [[Textline alloc] initWithAttributes:attributeDict] ;
        [textlines addTextline:textline] ;
        
        NSInteger textlineTime = [[textline createdAt] integerValue] ;
        if(latestTextlineTime <= textlineTime){
            latestTextlineTime = textlineTime ;
            latestTextline = textline ;
        }
    } else if([elementName isEqualToString:@"textline_package"]){
        TextlinePackage *textlinePackage = [[TextlinePackage alloc] initWithAttributes:attributeDict] ;
        [textlinePackages addObject:textlinePackage ] ;
        //NSLog(@"add TextlinePackage : %@ %@",[textlinePackage textlinePackageId],[textlinePackage title]) ;
        */
    } else {
        //NSLog(@"elementName=%@",elementName) ;
        /*
        NSArray *keys = [attributeDict allKeys] ;
        NSInteger count = [keys count] ;
        for(int index = 0 ; index < count ; index++){
            NSString *key = [keys objectAtIndex:index] ;
           //NSLog(@"%@:%@",key,[attributeDict objectForKey:key]) ;
        }
        */
        NSString *value = [attributeDict objectForKey:@"value"];
        if(value != nil){
            //NSLog(@"elementName=%@ value=%@",elementName,value) ;
            [dictionary setObject:value forKey:elementName] ;
        }
    }
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Contents::didEndElement") ;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Contents::parserDidEndDocument") ;
    [parser setDelegate:nil] ;
    
    if([self isValid]){
        BOOL shouldStoreContentId = YES ;
        if(xmlData != nil){
            NSFileManager *fileManager = [NSFileManager defaultManager] ;
            NSString *workFilePath = [VeamUtil getFilePathAtCachesDirectory:VEAM_WORK_CONTENTS_FILE_NAME] ;
            [fileManager createFileAtPath:workFilePath contents:[NSData data] attributes:nil] ;
            NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:workFilePath] ;
            [file writeData:xmlData] ;
            [file closeFile] ;
            BOOL moved = [VeamUtil moveFile:workFilePath toPath:[VeamUtil getFilePathAtCachesDirectory:VEAM_CONTENTS_FILE_NAME]] ;
            if(!moved){
                shouldStoreContentId = NO ;
            }
        }
        
        if(shouldStoreContentId){
            [self storeContentId] ;
        }
    }

    isParsing = NO ;
}

- (void)storeContentId
{
    if(![VeamUtil isEmpty:contentId]){
        [VeamUtil setUserDefaultString:VEAM_USER_DEFAULT_KEY_CURRENT_CONTENT_ID value:contentId] ;
    }
}

- (NSString *)getStoredContentId
{
    return [VeamUtil getUserDefaultString:VEAM_USER_DEFAULT_KEY_CURRENT_CONTENT_ID] ;
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // エレメントの文字データを string で取得
}

- (NSString *)getValueForKey:(NSString *)key
{
    //NSLog(@"key=%@",key) ;
    NSString *value = [dictionary objectForKey:key] ;
    return value ;
}

- (void)setValueForKey:(NSString *)key value:(NSString *)value
{
    //NSLog(@"setValueForKey %@ %@",key,value) ;
    [dictionary setObject:value forKey:key] ;
}

- (NSInteger)getNumberOfForums
{
    return [forums count] ;
}

- (Forum *)getForumAt:(NSInteger)index
{
    Forum *retValue = nil ;
    if(index < [forums count]){
        retValue = [forums objectAtIndex:index] ;
    }
    return retValue ;
}

- (Forum *)getForumForId:(NSString *)forumId
{
    NSInteger count = [forums count] ;
    Forum *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        Forum *forum = [forums objectAtIndex:index] ;
        if([[forum forumId] isEqualToString:forumId]){
            retValue = forum ;
            break ;
        }
    }
    return retValue ;
}

- (NSInteger)getNumberOfYoutubeCategories
{
    return [youtubeCategories count] ;
}

- (TemplateYoutube *)getTemplateYoutube
{
    return templateYoutube ;
}

- (NSMutableArray *)getYoutubeCategories
{
    return youtubeCategories ;
}

- (YoutubeCategory *)getYoutubeCategoryAt:(NSInteger)index
{
    YoutubeCategory *retValue = nil ;
    if(index < [youtubeCategories count]){
        retValue = [youtubeCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (YoutubeCategory *)getYoutubeCategoryForId:(NSString *)youtubeCategoryId
{
    NSInteger count = [youtubeCategories count] ;
    YoutubeCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        YoutubeCategory *youtubeCategory = [youtubeCategories objectAtIndex:index] ;
        if([[youtubeCategory youtubeCategoryId] isEqualToString:youtubeCategoryId]){
            retValue = youtubeCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSArray *)getYoutubeSubCategories:(NSString *)youtubeCategoryId
{
    NSArray *retValue = [youtubeSubCategoriesPerCategory objectForKey:youtubeCategoryId] ;
    return retValue ;
}






- (NSInteger)getNumberOfMixedCategories
{
    return [mixedCategories count] ;
}

- (TemplateMixed *)getTemplateMixed
{
    return templateMixed ;
}

- (NSMutableArray *)getMixedCategories
{
    return mixedCategories ;
}

- (MixedCategory *)getMixedCategoryAt:(NSInteger)index
{
    MixedCategory *retValue = nil ;
    if(index < [mixedCategories count]){
        retValue = [mixedCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (MixedCategory *)getMixedCategoryForId:(NSString *)mixedCategoryId
{
    NSInteger count = [mixedCategories count] ;
    MixedCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        MixedCategory *mixedCategory = [mixedCategories objectAtIndex:index] ;
        if([[mixedCategory mixedCategoryId] isEqualToString:mixedCategoryId]){
            retValue = mixedCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSArray *)getMixedSubCategories:(NSString *)mixedCategoryId
{
    NSArray *retValue = [mixedSubCategoriesPerCategory objectForKey:mixedCategoryId] ;
    return retValue ;
}

- (NSArray *)getMixedsForCategory:(NSString *)mixedCategoryId
{
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    if([mixedCategoryId isEqualToString:VEAM_MIXED_CATEGORY_ID_FAVORITES]){
        // favorite videos
        NSString *favoriteString = [VeamUtil getFavoritesForKind:VEAM_FAVORITE_KIND_MIXED] ;
        NSArray *favoriteIds = [favoriteString componentsSeparatedByString:@"_"] ;
        int count = (int)[favoriteIds count] ;
        for(int index = 0 ; index < count ; index++){
            Mixed *mixed = [mixedsForMixedId objectForKey:[favoriteIds objectAtIndex:index]] ;
            if(mixed != nil){
                [retValue addObject:mixed] ;
            }
        }
    } else {
        NSArray *candidates = [mixedsPerSubCategory objectForKey:@"0"] ;
        NSInteger count = [candidates count] ;
        for(int index = 0 ; index < count ; index++){
            Mixed *mixed = [candidates objectAtIndex:index] ;
            if([[mixed mixedCategoryId] isEqualToString:mixedCategoryId]){
                [retValue addObject:mixed] ;
            }
        }
    }
    return retValue ;
}

- (NSArray *)getMixedsForSubCategory:(NSString *)mixedSubCategoryId
{
    NSArray *retValue = [mixedsPerSubCategory objectForKey:mixedSubCategoryId] ;
    return retValue ;
}

- (Mixed *)getMixedForId:(NSString *)mixedId
{
    Mixed *retValue = nil ;
    retValue = [mixedsForMixedId objectForKey:mixedId] ;
    return retValue ;
}

- (NSArray *)getMixedsForSubscription:(BOOL)includeYearObject
{
    //NSLog(@"getMixedsForSubscription") ;
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    
    NSMutableArray *mixeds = [NSMutableArray arrayWithArray:[self getMixedsForCategory:@"0"]] ;
    
    [mixeds sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Mixed *mixed1 = (Mixed *)obj1 ;
        Mixed *mixed2 = (Mixed *)obj2 ;
        
        NSInteger createdAt1 = [[mixed1 createdAt] integerValue] ;
        NSInteger createdAt2 = [[mixed2 createdAt] integerValue] ;
        return createdAt1 < createdAt2 ;
    }];
    
    
    // insert year object
    NSInteger currentYear = 0 ;
    int count = [mixeds count] ;
    
    //NSLog(@"Mixeds::sortMixeds count=%d",count) ;
    
    NSMutableArray *workMixeds = [NSMutableArray array] ;
    for(int index = 0 ; index < count ; index++){
        Mixed *mixed = [mixeds objectAtIndex:index] ;
        BOOL shouldInclude = YES ;
        if((
           [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_VIDEO] ||
           [[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO]
            ) &&
           ([mixed.createdAt integerValue] < subscriptionStartTime)){
            shouldInclude = NO ;
        }

        if(shouldInclude){
            if(![[mixed kind] isEqualToString:VEAM_CONSOLE_MIXED_KIND_YEAR]){
                if(includeYearObject){
                    NSInteger year = [VeamUtil getYear:[NSNumber numberWithInteger:[[mixed createdAt] integerValue]]] ;
                    if(year != currentYear){
                        currentYear = year ;
                        NSString *yearString = [NSString stringWithFormat:@"%d",year] ;
                        Mixed *yearMixed = [[Mixed alloc] init] ;
                        [yearMixed setMixedId:@"0"] ;
                        [yearMixed setKind:VEAM_CONSOLE_MIXED_KIND_YEAR] ;
                        [yearMixed setTitle:yearString] ;
                        [yearMixed setCreatedAt:[mixed createdAt]] ;
                        [workMixeds addObject:yearMixed] ;
                        //NSLog(@"add year : %@",yearString) ;
                    }
                }
                [workMixeds addObject:mixed] ;
            }
        }
    }
    
    return workMixeds ;
}






- (TemplateSubscription *)getTemplateSubscription
{
    //NSLog(@"getTemplateSubscription") ;
    return templateSubscription ;
}



// Sell Item Category
- (NSInteger)getNumberOfSellItemCategories
{
    NSInteger retValue = [sellItemCategories count] ;
    return retValue ;
}

- (SellItemCategory *)getSellItemCategoryAt:(NSInteger)index
{
    SellItemCategory *retValue = nil ;
    if(index < [sellItemCategories count]){
        retValue = [sellItemCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (SellItemCategory *)getSellItemCategoryForId:(NSString *)sellItemCategoryId
{
    NSInteger count = [sellItemCategories count] ;
    SellItemCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        SellItemCategory *sellItemCategory = [sellItemCategories objectAtIndex:index] ;
        if([[sellItemCategory sellItemCategoryId] isEqualToString:sellItemCategoryId]){
            retValue = sellItemCategory ;
            break ;
        }
    }
    return retValue ;
}



// Sell Section Category
- (NSInteger)getNumberOfSellSectionCategories
{
    NSInteger retValue = [sellSectionCategories count] ;
    return retValue ;
}

- (SellSectionCategory *)getSellSectionCategoryAt:(NSInteger)index
{
    SellSectionCategory *retValue = nil ;
    if(index < [sellSectionCategories count]){
        retValue = [sellSectionCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (SellSectionCategory *)getSellSectionCategoryForId:(NSString *)sellSectionCategoryId
{
    NSInteger count = [sellSectionCategories count] ;
    SellSectionCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        SellSectionCategory *sellSectionCategory = [sellSectionCategories objectAtIndex:index] ;
        if([[sellSectionCategory sellSectionCategoryId] isEqualToString:sellSectionCategoryId]){
            retValue = sellSectionCategory ;
            break ;
        }
    }
    return retValue ;
}



// Video
- (NSInteger)getNumberOfVideoCategories
{
    NSInteger retValue = [videoCategories count] ;
    return retValue ;
}

- (VideoCategory *)getVideoCategoryAt:(NSInteger)index
{
    VideoCategory *retValue = nil ;
    if(index < [videoCategories count]){
        retValue = [videoCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (VideoCategory *)getVideoCategoryForId:(NSString *)videoCategoryId
{
    NSInteger count = [videoCategories count] ;
    VideoCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        VideoCategory *videoCategory = [videoCategories objectAtIndex:index] ;
        if([[videoCategory videoCategoryId] isEqualToString:videoCategoryId]){
            retValue = videoCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSArray *)getVideoSubCategories:(NSString *)videoCategoryId
{
    NSArray *retValue = [videoSubCategoriesPerCategory objectForKey:videoCategoryId] ;
    return retValue ;
}

- (Video *)getVideoForId:(NSString *)videoId
{
    return [videosForVideoId objectForKey:videoId] ;
}

- (NSArray *)getVideosForCategory:(NSString *)videoCategoryId
{
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    //NSLog(@"subscriptionStartTime=%d",subscriptionStartTime) ;
    if(subscriptionStartTime == 0){
        subscriptionStartTime = NSIntegerMax ;
    }
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    if([videoCategoryId isEqualToString:@"FAVORITES"]){
        // favorite videos
        NSString *favoriteString = [VeamUtil getFavoritesForKind:VEAM_FAVORITE_KIND_VIDEO] ;
        NSArray *favoriteIds = [favoriteString componentsSeparatedByString:@"_"] ;
        int count = (int)[favoriteIds count] ;
        for(int index = 0 ; index < count ; index++){
            Video *video = [videosForVideoId objectForKey:[favoriteIds objectAtIndex:index]] ;
            if(video != nil){
                [retValue addObject:video] ;
            }
        }
    } else {
        NSArray *candidates = [videosPerSubCategory objectForKey:@"0"] ;
        NSInteger count = [candidates count] ;
        for(int index = 0 ; index < count ; index++){
            Video *video = [candidates objectAtIndex:index] ;
            //NSLog(@"video %@ %d %@",video.title,subscriptionStartTime,video.createdAt) ;
            if([[video videoCategoryId] isEqualToString:videoCategoryId]){
                if(![video.kind isEqualToString:VEAM_VIDEO_KIND_PERIODICAL] || (subscriptionStartTime <= [video.createdAt integerValue])){
                    [retValue addObject:video] ;
                }
            }
        }
    }
    
    return retValue ;
}

- (NSArray *)getVideosForSubCategory:(NSString *)videoSubCategoryId
{
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    NSArray *candidates = [videosPerSubCategory objectForKey:videoSubCategoryId] ;
    NSInteger count = [candidates count] ;
    for(int index = 0 ; index < count ; index++){
        Video *video = [candidates objectAtIndex:index] ;
        //NSLog(@"video %@ %d %@",video.title,subscriptionStartTime,video.createdAt) ;
        if(![video.kind isEqualToString:VEAM_VIDEO_KIND_PERIODICAL] || (subscriptionStartTime <= [video.createdAt integerValue])){
            [retValue addObject:video] ;
        }
    }
    
    return retValue ;
}







// PDF
- (NSInteger)getNumberOfPdfCategories
{
    NSInteger retValue = [pdfCategories count] ;
    return retValue ;
}

- (PdfCategory *)getPdfCategoryAt:(NSInteger)index
{
    PdfCategory *retValue = nil ;
    if(index < [pdfCategories count]){
        retValue = [pdfCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (PdfCategory *)getPdfCategoryForId:(NSString *)pdfCategoryId
{
    NSInteger count = [pdfCategories count] ;
    PdfCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        PdfCategory *pdfCategory = [pdfCategories objectAtIndex:index] ;
        if([[pdfCategory pdfCategoryId] isEqualToString:pdfCategoryId]){
            retValue = pdfCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSArray *)getPdfSubCategories:(NSString *)pdfCategoryId
{
    NSArray *retValue = [pdfSubCategoriesPerCategory objectForKey:pdfCategoryId] ;
    return retValue ;
}

- (Pdf *)getPdfForId:(NSString *)pdfId
{
    return [pdfsForPdfId objectForKey:pdfId] ;
}

- (NSArray *)getPdfsForCategory:(NSString *)pdfCategoryId
{
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    //NSLog(@"subscriptionStartTime=%d",subscriptionStartTime) ;
    if(subscriptionStartTime == 0){
        subscriptionStartTime = NSIntegerMax ;
    }
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    NSArray *candidates = [pdfsPerSubCategory objectForKey:@"0"] ;
    NSInteger count = [candidates count] ;
    for(int index = 0 ; index < count ; index++){
        Pdf *pdf = [candidates objectAtIndex:index] ;
        //NSLog(@"pdf %@ %d %@",Pdf.title,subscriptionStartTime,Pdf.createdAt) ;
        if([[pdf pdfCategoryId] isEqualToString:pdfCategoryId]){
            [retValue addObject:pdf] ;
        }
    }
    
    return retValue ;
}

- (NSArray *)getPdfsForSubCategory:(NSString *)pdfSubCategoryId
{
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    NSArray *candidates = [pdfsPerSubCategory objectForKey:pdfSubCategoryId] ;
    NSInteger count = [candidates count] ;
    for(int index = 0 ; index < count ; index++){
        Pdf *pdf = [candidates objectAtIndex:index] ;
        //NSLog(@"pdf %@ %d %@",pdf.title,subscriptionStartTime,pdf.createdAt) ;
        [retValue addObject:pdf] ;
    }
    
    return retValue ;
}











// question(answer)
- (NSMutableArray *)getAnswers
{
    BOOL isBought = [VeamUtil isSubscriptionBought:[VeamUtil getSubscriptionIndex]] ;
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    NSInteger count = [answers count] ;
    for(int index = 0 ; index < count ; index++){
        Question *answer = [answers objectAtIndex:index] ;
        //NSLog(@"answer %@ %d %@",answer.text,subscriptionStartTime,answer.createdAt) ;
        if(![answer.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_PERIODICAL_VIDEO] &&
           ![answer.answerKind isEqualToString:VEAM_QUESTION_ANSWER_KIND_PERIODICAL_AUDIO] ){
            [retValue addObject:answer] ;
        } else if(isBought && (subscriptionStartTime <= [answer.answeredAt integerValue])) {
            [retValue addObject:answer] ;
        }
    }

    return retValue ;
}

- (NSInteger)getNumberOfAnswers
{
    return [[self getAnswers] count] ;
}

- (Question *)getAnswerAt:(NSInteger)index
{
    Question *retValue = nil ;
    NSMutableArray *workAnswers = [self getAnswers] ;
    
    if(index < [workAnswers count]){
        retValue = [workAnswers objectAtIndex:index] ;
    }
    return retValue ;
}









// audio
- (NSInteger)getNumberOfAudioCategories
{
    NSInteger retValue = [audioCategories count] ;
    return retValue ;
}

- (AudioCategory *)getAudioCategoryAt:(NSInteger)index
{
    AudioCategory *retValue = nil ;
    if(index < [audioCategories count]){
        retValue = [audioCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (AudioCategory *)getAudioCategoryForId:(NSString *)audioCategoryId
{
    NSInteger count = [audioCategories count] ;
    AudioCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        AudioCategory *audioCategory = [audioCategories objectAtIndex:index] ;
        if([[audioCategory audioCategoryId] isEqualToString:audioCategoryId]){
            retValue = audioCategory ;
            break ;
        }
    }
    return retValue ;
}

- (NSArray *)getAudioSubCategories:(NSString *)audioCategoryId
{
    NSArray *retValue = [audioSubCategoriesPerCategory objectForKey:audioCategoryId] ;
    return retValue ;
}

- (Audio *)getAudioForId:(NSString *)audioId
{
    return [audiosForAudioId objectForKey:audioId] ;
}

- (NSArray *)getAudiosForCategory:(NSString *)audioCategoryId
{
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    if([audioCategoryId isEqualToString:@"FAVORITES"]){
        // favorite audios
        NSString *favoriteString = [VeamUtil getFavoritesForKind:VEAM_FAVORITE_KIND_VIDEO] ;
        NSArray *favoriteIds = [favoriteString componentsSeparatedByString:@"_"] ;
        int count = (int)[favoriteIds count] ;
        for(int index = 0 ; index < count ; index++){
            Audio *audio = [audiosForAudioId objectForKey:[favoriteIds objectAtIndex:index]] ;
            if(audio != nil){
                [retValue addObject:audio] ;
            }
        }
    } else {
        NSArray *candidates = [audiosPerSubCategory objectForKey:@"0"] ;
        NSInteger count = [candidates count] ;
        for(int index = 0 ; index < count ; index++){
            Audio *audio = [candidates objectAtIndex:index] ;
            //NSLog(@"audio %@ %d %@",audio.title,subscriptionStartTime,audio.createdAt) ;
            if([[audio audioCategoryId] isEqualToString:audioCategoryId]){
                if(![audio.mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] || (subscriptionStartTime <= [audio.createdAt integerValue])){
                    [retValue addObject:audio] ;
                }
            }
        }
    }
    
    return retValue ;
}

- (NSArray *)getAudiosForSubCategory:(NSString *)audioSubCategoryId
{
    NSInteger subscriptionStartTime = [[VeamUtil getSubscriptionStartTime:[VeamUtil getSubscriptionIndex]] integerValue] ;
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    
    NSArray *candidates = [audiosPerSubCategory objectForKey:audioSubCategoryId] ;
    NSInteger count = [candidates count] ;
    for(int index = 0 ; index < count ; index++){
        Audio *audio = [candidates objectAtIndex:index] ;
        //NSLog(@"audio %@ %d %@",audio.title,subscriptionStartTime,audio.createdAt) ;
        if(![audio.mixed.kind isEqualToString:VEAM_CONSOLE_MIXED_KIND_SUBSCRIPTION_PERIODICAL_AUDIO] || (subscriptionStartTime <= [audio.createdAt integerValue])){
            [retValue addObject:audio] ;
        }
    }
    
    return retValue ;
}





/*

- (NSInteger)getNumberOfTextlinePackages
{
    NSInteger retValue = [textlinePackages count] ;
    return retValue ;
}

- (TextlinePackage *)getTextlinePackageAt:(NSInteger)index
{
    TextlinePackage *retValue = nil ;
    if(index < [textlinePackages count]){
        retValue = [textlinePackages objectAtIndex:index] ;
    }
    return retValue ;
}

- (TextlinePackage *)getTextlinePackageForId:(NSString *)textlinePackageId
{
    NSInteger count = [textlinePackages count] ;
    TextlinePackage *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        TextlinePackage *textlinePackage = [textlinePackages objectAtIndex:index] ;
        if([[textlinePackage textlinePackageId] isEqualToString:textlinePackageId]){
            retValue = textlinePackage ;
            break ;
        }
    }
    return retValue ;
}


- (NSInteger)getNumberOfTextlineCategories
{
    NSInteger retValue = [textlineCategories count] ;
    return retValue ;
}

- (TextlineCategory *)getTextlineCategoryAt:(NSInteger)index
{
    TextlineCategory *retValue = nil ;
    if(index < [textlineCategories count]){
        retValue = [textlineCategories objectAtIndex:index] ;
    }
    return retValue ;
}

- (TextlineCategory *)getTextlineCategoryForId:(NSString *)categoryId
{
    NSInteger count = [textlineCategories count] ;
    TextlineCategory *retValue = nil ;
    for(int index = 0 ; index < count ; index++){
        TextlineCategory *textlineCategory = [textlineCategories objectAtIndex:index] ;
        //NSLog(@"[textlineCategory categoryId] compare %@ %@",[textlineCategory categoryId],categoryId) ;
        if([[textlineCategory categoryId] isEqualToString:categoryId]){
            retValue = textlineCategory ;
            break ;
        }
    }
    return retValue ;
}

- (Textline *)getLatestTextline
{
    return latestTextline ;
}

- (Textlines *)getTextlines
{
    return textlines ;
}

- (NSArray *)getTextlineSubCategories:(NSString *)categoryId
{
    NSArray *retValue = [textlineSubCategoriesPerCategory objectForKey:categoryId] ;
    return retValue ;
}
*/









- (NSArray *)getYoutubesForCategory:(NSString *)youtubeCategoryId
{
    NSMutableArray *retValue = [[NSMutableArray alloc] init] ;
    if([youtubeCategoryId isEqualToString:VEAM_YOUTUBE_CATEGORY_ID_FAVORITES]){
        // favorite videos
        NSString *favoriteString = [VeamUtil getFavoritesForKind:VEAM_FAVORITE_KIND_YOUTUBE] ;
        NSArray *favoriteIds = [favoriteString componentsSeparatedByString:@"_"] ;
        int count = (int)[favoriteIds count] ;
        for(int index = 0 ; index < count ; index++){
            Youtube *youtube = [youtubesForYoutubeId objectForKey:[favoriteIds objectAtIndex:index]] ;
            if(youtube != nil){
                [retValue addObject:youtube] ;
            }
        }
    } else {
        NSArray *candidates = [youtubesPerSubCategory objectForKey:@"0"] ;
        NSInteger count = [candidates count] ;
        for(int index = 0 ; index < count ; index++){
            Youtube *youtube = [candidates objectAtIndex:index] ;
            if([[youtube youtubeCategoryId] isEqualToString:youtubeCategoryId]){
                [retValue addObject:youtube] ;
            }
        }
    }
    return retValue ;
}

- (NSArray *)getYoutubesForSubCategory:(NSString *)youtubeSubCategoryId
{
    NSArray *retValue = [youtubesPerSubCategory objectForKey:youtubeSubCategoryId] ;
    return retValue ;
}

- (Youtube *)getYoutubeForId:(NSString *)youtubeId
{
    Youtube *retValue = nil ;
    retValue = [youtubesForYoutubeId objectForKey:youtubeId] ;
    return retValue ;
}






- (NSArray *)getRecipeCategories
{
    return recipeCategories ;
}

- (Recipe *)getRecipeForId:(NSString *)recipeId
{
    return [recipesForId objectForKey:recipeId] ;
}

- (NSArray *)getRecipes:(NSString *)recipeCategoryId
{
    
    NSMutableArray *retValue = nil ;
    
    if([recipeCategoryId isEqualToString:@"FAVORITES"]){
        retValue = [[NSMutableArray alloc] init] ;
        // favorite recipes
        NSString *favoriteString = [VeamUtil getFavoritesForKind:VEAM_FAVORITE_KIND_RECIPE] ;
        NSArray *favoriteIds = [favoriteString componentsSeparatedByString:@"_"] ;
        int count = [favoriteIds count] ;
        for(int index = 0 ; index < count ; index++){
            Recipe *recipe = [recipesForId objectForKey:[favoriteIds objectAtIndex:index]] ;
            if(recipe != nil){
                [retValue addObject:recipe] ;
            }
        }
    } else {
        retValue = [recipesPerCategory objectForKey:recipeCategoryId] ;
    }
    
    return retValue ;
}


- (NSArray *)getAlternativeImages
{
    return alternativeImages ;
}

- (AlternativeImage *)getAlternativeImageForFileName:(NSString *)fileName
{
    return [alternativeImagesForFileName objectForKey:fileName] ;
}

- (NSInteger)getNumberOfWebs:(NSString *)categoryId
{
    return [[websPerCategory objectForKey:categoryId] count] ;
}

- (NSArray *)getWebs:(NSString *)categoryId
{
    return [websPerCategory objectForKey:categoryId] ;
}


/*

- (NSInteger)getNumberOfNewYoutubeVideos
{
    NSInteger retValue = [newYoutubeVideos count] ;
    return retValue ;
}

- (NSArray *)getNewYoutubeVideos
{
    return newYoutubeVideos ;
}

- (NSInteger)getNumberOfDownloadableVideos
{
    return [downloadableVideos count] ;
}

- (NSArray *)getDownloadableVideos
{
    return downloadableVideos ;
}


- (NSInteger)getNumberOfDownloadableVideosForYearMonth:(NSString *)yearMonth
{
    NSInteger retValue = 0 ;
    NSArray *videos = [downloadableVideosForYearMonth objectForKey:yearMonth] ;
    if(videos != nil){
        retValue = [videos count] ;
    }
    return retValue ;
}

- (NSArray *)getDownloadableVideosForYearMonth:(NSString *)yearMonth
{
    //NSLog(@"getDownloadableVideosForYearMonth:%@",yearMonth) ;
    NSArray *videos = [downloadableVideosForYearMonth objectForKey:yearMonth] ;
    return videos ;
}


- (Bulletin *)getCurrentBulletin:(NSInteger)index
{
    NSDate *currentDate = [NSDate date] ;
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone] ;
    NSInteger seconds = [timeZone secondsFromGMTForDate:currentDate] ;
    NSDate *localDate = [currentDate dateByAddingTimeInterval:seconds] ;

    NSTimeInterval currentTime = [localDate timeIntervalSince1970] ;
    
    Bulletin *retValue = nil ;
    NSInteger count = [bulletins count] ;
    for(int bulletinIndex = 0 ; bulletinIndex < count ; bulletinIndex++){
        Bulletin *bulletin = [bulletins objectAtIndex:bulletinIndex] ;
        if([[bulletin index] integerValue] == index){
            NSInteger start = [[bulletin startAt] integerValue] ;
            NSInteger end = [[bulletin endAt] integerValue] ;
            if((start <= currentTime) && (currentTime < end)){
                retValue = bulletin ;
                break ;
            }
        }
    }
    return retValue ;
}

- (WeekdayText *)getWeekdayText:(NSInteger)targetTime weekday:(NSInteger)weekday
{
    WeekdayText *retValue = nil ;
    NSInteger count = [weekdayTexts count] ;
    for(int index = 0 ; index < count ; index++){
        WeekdayText *weekdayText = [weekdayTexts objectAtIndex:index] ;
        if([[weekdayText weekday] integerValue] == weekday){
            NSInteger start = [[weekdayText startAt] integerValue] ;
            NSInteger end = [[weekdayText endAt] integerValue] ;
            if((start <= targetTime) && (targetTime < end)){
                retValue = weekdayText ;
                break ;
            }
        }
    }
    return retValue ;
}
*/

- (void)addMixed:(Mixed *)mixed
{
    
    NSString *mixedSubCategoryId = mixed.mixedSubCategoryId ;
    if((mixed != nil) && ![VeamUtil isEmpty:mixedSubCategoryId]){
        NSMutableArray *mixeds = [mixedsPerSubCategory objectForKey:mixedSubCategoryId] ;
        if(mixeds == nil){
            mixeds = [[NSMutableArray alloc] init] ;
            [mixedsPerSubCategory setObject:mixeds forKey:mixedSubCategoryId] ;
        }
        [mixeds addObject:mixed] ;
        [mixedsForMixedId setObject:mixed forKey:[mixed mixedId]] ;

        //NSLog(@"add mixed : %@ %@ %@ displayType=%@ displayName=%@",[mixed mixedId],[mixed mixedCategoryId],[mixed mixedSubCategoryId],mixed.displayType,mixed.displayName) ;
    }
}


- (NSInteger)getNumberOfSellVideos
{
    return [sellVideos count] ;
}

- (SellVideo *)getSellVideoAt:(NSInteger)index
{
    SellVideo *retValue = nil ;
    if(index < [sellVideos count]){
        retValue = [sellVideos objectAtIndex:index] ;
    }
    return retValue ;
}

- (NSArray *)getSellVideos
{
    return sellVideos ;
}

- (NSArray *)getSellVideosForCategory:(NSString *)videoCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellVideos count] ;
    for(int index = 0 ; index < count ; index++){
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        if(sellVideo){
            Video *video = [self getVideoForId:sellVideo.videoId] ;
            if(video){
                if([video.videoCategoryId isEqualToString:videoCategoryId]){
                    [retValue addObject:sellVideo] ;
                }
            }
        }
    }
    
    return retValue ;
}




- (SellVideo *)getSellVideoForProduct:(NSString *)productId
{
    SellVideo *retValue = nil ;
    NSInteger count = [sellVideos count] ;
    for(int index = 0 ; index < count ; index++){
        SellVideo *sellVideo = [sellVideos objectAtIndex:index] ;
        if([sellVideo.productId isEqualToString:productId]){
            retValue = sellVideo ;
            break ;
        }
    }
    return retValue ;
}

- (BOOL)isSellVideoProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    SellVideo *sellVideo = [self getSellVideoForProduct:productId] ;
    if(sellVideo){
        retValue = YES ;
    }
    return retValue ;
}




// Sell Pdf
- (NSInteger)getNumberOfSellPdfs
{
    return [sellPdfs count] ;
}

- (SellPdf *)getSellPdfAt:(NSInteger)index
{
    SellPdf *retValue = nil ;
    if(index < [sellPdfs count]){
        retValue = [sellPdfs objectAtIndex:index] ;
    }
    return retValue ;
}

- (NSArray *)getSellPdfs
{
    return sellPdfs ;
}

- (NSArray *)getSellPdfsForCategory:(NSString *)pdfCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellPdfs count] ;
    for(int index = 0 ; index < count ; index++){
        SellPdf *sellPdf = [sellPdfs objectAtIndex:index] ;
        if(sellPdf){
            Pdf *pdf = [self getPdfForId:sellPdf.pdfId] ;
            if(pdf){
                if([pdf.pdfCategoryId isEqualToString:pdfCategoryId]){
                    [retValue addObject:sellPdf] ;
                }
            }
        }
    }
    
    return retValue ;
}




- (SellPdf *)getSellPdfForProduct:(NSString *)productId
{
    SellPdf *retValue = nil ;
    NSInteger count = [sellPdfs count] ;
    for(int index = 0 ; index < count ; index++){
        SellPdf *sellPdf = [sellPdfs objectAtIndex:index] ;
        if([sellPdf.productId isEqualToString:productId]){
            retValue = sellPdf ;
            break ;
        }
    }
    return retValue ;
}

- (BOOL)isSellPdfProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    SellPdf *sellPdf = [self getSellPdfForProduct:productId] ;
    if(sellPdf){
        retValue = YES ;
    }
    return retValue ;
}














// Sell Audio
- (NSInteger)getNumberOfSellAudios
{
    return [sellAudios count] ;
}

- (SellAudio *)getSellAudioAt:(NSInteger)index
{
    SellAudio *retValue = nil ;
    if(index < [sellAudios count]){
        retValue = [sellAudios objectAtIndex:index] ;
    }
    return retValue ;
}

- (NSArray *)getSellAudios
{
    return sellAudios ;
}

- (NSArray *)getSellAudiosForCategory:(NSString *)audioCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellAudios count] ;
    for(int index = 0 ; index < count ; index++){
        SellAudio *sellAudio = [sellAudios objectAtIndex:index] ;
        if(sellAudio){
            Audio *audio = [self getAudioForId:sellAudio.audioId] ;
            if(audio){
                if([audio.audioCategoryId isEqualToString:audioCategoryId]){
                    [retValue addObject:sellAudio] ;
                }
            }
        }
    }
    
    return retValue ;
}




- (SellAudio *)getSellAudioForProduct:(NSString *)productId
{
    SellAudio *retValue = nil ;
    NSInteger count = [sellAudios count] ;
    for(int index = 0 ; index < count ; index++){
        SellAudio *sellAudio = [sellAudios objectAtIndex:index] ;
        if([sellAudio.productId isEqualToString:productId]){
            retValue = sellAudio ;
            break ;
        }
    }
    return retValue ;
}

- (BOOL)isSellAudioProduct:(NSString *)productId
{
    BOOL retValue = NO ;
    SellAudio *sellAudio = [self getSellAudioForProduct:productId] ;
    if(sellAudio){
        retValue = YES ;
    }
    return retValue ;
}






- (NSArray *)getSellSectionItems
{
    return sellSectionItems ;
}

- (NSArray *)getSellSectionItemsForCategory:(NSString *)sellSectionCategoryId
{
    NSMutableArray *retValue = [NSMutableArray array] ;
    int count = [sellSectionItems count] ;
    for(int index = 0 ; index < count ; index++){
        SellSectionItem *sellSectionItem = [sellSectionItems objectAtIndex:index] ;
        if(sellSectionItem){
            if([sellSectionItem.sellSectionCategoryId isEqualToString:sellSectionCategoryId]){
                [retValue addObject:sellSectionItem] ;
            }
        }
    }
    
    return retValue ;
}

- (SellSectionItem *)getSellSectionItemForId:(NSString *)sellsectionItemId
{
    return [sellSectionItemsForSellSectionItemId objectForKey:sellsectionItemId] ;
}





@end
