//
//  MovieView.m
//  veam31000014
//
//  Created by veam on 1/20/16.
//
//

#import "MovieView.h"
#import "VeamUtil.h"

#define TIME_OVSERVER_INTERVAL  0.25f

@interface MovieView()
{
    bool _is_playing;     //ムービーが再生中である事を示す
}

@property (nonatomic,retain) AVPlayerItem* playerItem;
@property (nonatomic,retain) AVPlayer*     player;
@property (nonatomic,assign) id  playTimeObserver;

@end

@implementation MovieView


#pragma mark -
#pragma mark class method

//自身のレイヤーを動画再生用レイヤーを返すようにオーバライド
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}


#pragma mark -
#pragma mark instance management

-(void)dealloc
{
    _delegate = nil;
    [self clear];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _is_playing = false;
        _repeat = TRUE;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark property method
-(Float64)movieDuration
{
    if (self.playerItem)
    {
        Float64 duration = CMTimeGetSeconds( [self.player.currentItem duration] );
        return duration;
    } else {
        return 0;
    }
}


#pragma mark -
#pragma mark movie control

-(void)playMovie:(NSURL*)url
{
    
    //NSLog(@"playMovie:%@",url.absoluteString) ;
    //再生用アイテムを生成
    if (_playerItem)
    {
        //前回追加したムービー終了の通知を外す
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
        
        self.playerItem = nil;
    }
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url] ;
    if(self.playerItem == nil){
        NSLog(@"playerItem is nil") ;
    }
    
    //Itemにムービー終了の通知を設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    
    Float64 movieDuration = CMTimeGetSeconds( self.playerItem.duration );
    
    if (self.player)
    {
        
        //アイテムの切り替え
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        
        [_delegate movieView:self movieWillPlayItem:self.playerItem duration:movieDuration];
        
    } else {
        
        //AVPlayerを生成
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem] ;
        AVPlayerLayer* layer = ( AVPlayerLayer* )self.layer;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill ;
        layer.player       = self.player;
        
        
        /*
        //delegate呼び出し
        [_delegate movieView:self movieWillPlayItem:self.playerItem duration:movieDuration];
        
        // 再生時間とシークバー位置を連動させるためのタイマーを設定
        __block MovieView* weakSelf = self;
        const CMTime intervaltime     = CMTimeMakeWithSeconds( TIME_OVSERVER_INTERVAL, NSEC_PER_SEC );
        self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:intervaltime
                                                                          queue:NULL
                                                                     usingBlock:^( CMTime time ) {
                                                                         //再生時になにか動作させるのであればここで。
                                                                         [weakSelf moviePlaying:time];
                                                                     }];
         */
    }
    
    [self playMovie];
    
    //[self.player addObserver:self forKeyPath:@"status" options:0 context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"observeValueForKeyPath") ;
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self playMovie] ;
            
            
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}



-(void)playMovie
{
    if (self.player)
    {
        [self.player play];
        _is_playing = true;
    }
}

-(void)pauseMovie
{
    if (_is_playing)
    {
        [self.player pause];
        _is_playing = false;
    }
    
}

-(void)seekToSeconds:(Float64)seconds
{
    if (self.player)
    {
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC )];
    }
}



//再生中のムービーを停止し、プレイヤーなどをクリアする
- (void)clear
{
    if (self.player)
    {
        [self.player removeTimeObserver:self.playTimeObserver];
        [self.player pause];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        
        AVPlayerLayer* layer = ( AVPlayerLayer* )self.layer;
        layer.player  = nil;
        
        self.player = nil;
        self.playerItem = nil;
        self.playTimeObserver = nil;
    }
    
}

#pragma mark -
#pragma mark movie events

//　TIME_OVSERVER_INTERVALで指定された間隔で実行される
-(void)moviePlaying:(CMTime)time
{
    Float64 duration = CMTimeGetSeconds( [self.player.currentItem duration] );
    Float64 time1    = CMTimeGetSeconds(time);
    
    if (_delegate){
        
        [_delegate movieView:self moviePlayAtTime:time1 duration:duration];
        
    }
    
}

//　ムービー完了時に実行される
- (void) playerDidPlayToEndTime:(NSNotification*)notfication
{
    //NSLog(@"end") ;
    if (self.player)
    {
        if (self.repeat)
        {
            //リピート再生
            [self.player seekToTime:CMTimeMake(0, 600)];
            [self.player play];
        } else {
            [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO] ;
        }
        
    }
}


- (void)setTargetUrl:(NSURL *)url
{
    targetUrl = url ;
    [VeamUtil registerTapAction:self target:self selector:@selector(didTapView)] ;
    CGRect frame = self.frame ;
    CGFloat width = 140 ;
    CGFloat height = 132 ;
    frame.origin.x = (frame.size.width - width) / 2 ;
    frame.origin.y = (frame.size.height - height) / 2 ;
    frame.size.width = width ;
    frame.size.height = height ;
    playButtonImageView = [[UIImageView alloc] initWithFrame:frame] ;
    [playButtonImageView setImage:[UIImage imageNamed:@"p_play.png"]] ;
    [self addSubview:playButtonImageView] ;
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
    //[indicatorView startAnimating] ;
    frame = self.frame ;
    width = 100 ;
    height = 100 ;
    frame.origin.x = (frame.size.width - width) / 2 ;
    frame.origin.y = (frame.size.height - height) / 2 ;
    frame.size.width = width ;
    frame.size.height = height ;
    indicatorView.frame = frame ;
    [indicatorView setAlpha:0.0] ;
    [self addSubview:indicatorView] ;
        
}

- (void)hidePlayButton
{
    [playButtonImageView setAlpha:0.0] ;
}

- (void)showPlayButton
{
    [playButtonImageView setAlpha:1.0] ;
}

- (void)hideIndicagtor
{
    [indicatorView setAlpha:0.0] ;
    [indicatorView stopAnimating] ;
}

- (void)showIndicator
{
    [indicatorView startAnimating] ;
    [indicatorView setAlpha:1.0] ;
}


- (void)didTapView
{
    //NSLog(@"didTapView") ;
    [self performSelectorOnMainThread:@selector(hidePlayButton) withObject:nil waitUntilDone:NO] ;
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO] ;
    [self performSelectorInBackground:@selector(downloadAndPlay) withObject:nil] ;
    //[self downloadAndPlay] ;
}

/*
-(void)downloadAndPlay
{
    if(targetUrl != nil){
        NSString *urlString = targetUrl.absoluteString ;
        NSString *cacheFilePath = [VeamUtil getCachedSnapPath:urlString downloadIfNot:YES] ;
        NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",cacheFilePath]] ;
        NSLog(@"play local %@",videoUrl.absoluteString) ;
        [self performSelectorOnMainThread:@selector(hideIndicagtor) withObject:nil waitUntilDone:NO] ;
        [self performSelectorOnMainThread:@selector(playMovie:) withObject:videoUrl waitUntilDone:NO] ;
        //[self playMovie:videoUrl] ;
    }
}
*/


@end
