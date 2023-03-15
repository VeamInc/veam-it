//
//  MovieView.h
//  veam31000014
//
//  Created by veam on 1/20/16.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol MovieViewDelegate;

/**
 * 動画再生をView
 */
@interface MovieView : UIView
{
    NSURL *targetUrl ;
    UIImageView *playButtonImageView ;
    UIActivityIndicatorView *indicatorView ;
}

@property (nonatomic,assign) id<MovieViewDelegate> delegate;

//リピート再生するか
@property (nonatomic,assign) BOOL repeat;


//動画の長さ（秒数）
@property (nonatomic,readonly) Float64 movieDuration;

//再生を開始する
-(void)playMovie:(NSURL*)url;

//再生の一時停止
-(void)pauseMovie;

//再生開始
-(void)playMovie;

//再生位置を移動させる
-(void)seekToSeconds:(Float64)seconds;

//ムービーのクリア
- (void)clear;

- (void)setTargetUrl:(NSURL *)url ;


@end


@protocol MovieViewDelegate <NSObject>

//動画の再生直前に呼び出される
-(void)movieView:(MovieView*)sender movieWillPlayItem:(AVPlayerItem*)playerItem duration:(Float64)duration;

//動画の再生中に一定の間隔で呼び出される
// time:再生位置（秒数）
// duration:動画全体の秒数
-(void)movieView:(MovieView*)sender moviePlayAtTime:(Float64)time duration:(Float64)duration;

@end
