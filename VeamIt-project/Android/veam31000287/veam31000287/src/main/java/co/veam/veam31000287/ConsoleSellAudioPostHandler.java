package co.veam.veam31000287;

import java.util.ArrayList;

/**
 * Created by veam on 11/7/16.
 */
public class ConsoleSellAudioPostHandler implements HandlePostResultInterface {
    SellAudioObject sellAudio ;
    AudioObject audio ;

    public SellAudioObject getSellAudio() {
        return sellAudio;
    }

    public void setSellAudio(SellAudioObject sellAudio) {
        this.sellAudio = sellAudio;
    }

    public AudioObject getAudio() {
        return audio;
    }

    public void setAudio(AudioObject audio) {
        this.audio = audio;
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 2){
            //NSLog(@"count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                String sellAudioId = results.get(1) ;
                String audioId = results.get(2) ;

                sellAudio.setId(sellAudioId) ;
                audio.setId(audioId) ;
            }
        }
    }
}
