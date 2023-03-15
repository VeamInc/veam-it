package co.veam.veam31000287;

import android.provider.MediaStore;

import java.util.ArrayList;

/**
 * Created by veam on 11/7/16.
 */
public class ConsoleSellVideoPostHandler implements HandlePostResultInterface {

    SellVideoObject sellVideo ;
    VideoObject video ;

    public SellVideoObject getSellVideo() {
        return sellVideo;
    }

    public void setSellVideo(SellVideoObject sellVideo) {
        this.sellVideo = sellVideo;
    }

    public VideoObject getVideo() {
        return video;
    }

    public void setVideo(VideoObject video) {
        this.video = video;
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 2){
            //NSLog(@"count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                String sellVideoId = results.get(1) ;
                String videoId = results.get(2) ;

                sellVideo.setId(sellVideoId) ;
                video.setId(videoId) ;
            }
        }
    }
}
