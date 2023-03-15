package co.veam.veam31000287;

import java.util.ArrayList;

/**
 * Created by veam on 11/8/16.
 */
public class ConsoleUpdatePreparingSellVideoStatusHandler implements HandlePostResultInterface {
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
                    String[] values = valueString.split("\\|") ;
                    if(values.length >= 3){
                        String sellVideoId = values[0] ;
                        String status = values[1] ;
                        String statusText = values[2] ;
                        SellVideoObject sellVideo = contents.getSellVideoForId(sellVideoId) ;
                        if(sellVideo != null){
                            sellVideo.setStatus(status) ;
                            sellVideo.setStatusText(statusText) ;
                        }
                    } else {
                        //NSLog(@"%@ less than 3",valueString) ;
                    }
                }
            }
        }
    }
}
