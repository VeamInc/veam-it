package co.veam.veam31000287;

import java.util.ArrayList;

/**
 * Created by veam on 11/7/16.
 */
public class ConsoleUpdatePreparingVideoStatusHandler implements HandlePostResultInterface {
    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 2){
            //NSLog(@"count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                ConsoleContents contents = ConsoleUtil.getConsoleContents() ;
                String elementString = results.get(1) ;
                //NSLog(@"elementString=%@",elementString) ;
                String[] elements = elementString.split(",") ;
                int numberOfElements = elements.length ;
                for(int index = 0 ; index < numberOfElements ; index++){
                    String valueString = elements[index] ;
                    String[] values = valueString.split(":") ;
                    if(values.length >= 3){
                        String videoId = values[0] ;
                        String status = values[1] ;
                        String statusText = values[2] ;
                        VideoObject video = contents.getVideoForId(videoId) ;
                        if(video != null){
                            video.setStatus(status) ;
                            video.setStatusText(statusText) ;
                        }
                    }
                }
            }
        }
    }
}
