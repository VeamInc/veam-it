package co.veam.veam31000287;

import android.util.Log;

import java.util.ArrayList;

/**
 * Created by veam on 11/8/16.
 */
public class ConsoleUpdatePreparingMixedStatusHandler implements HandlePostResultInterface {
    @Override
    public void handlePostResult(ArrayList<String> results) {
        VeamUtil.log("debug", "ConsoleUpdatePreparingMixedStatusHandler::handlePostResult") ;
        if(results.size()  >= 2){
            VeamUtil.log("debug", "count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                ConsoleContents contents = ConsoleUtil.getConsoleContents() ;
                String elementString = results.get(1) ;
                VeamUtil.log("debug", "elementString="+elementString) ;
                String[] elements = elementString.split(",") ;
                int numberOfElements = elements.length ;
                for(int index = 0 ; index < numberOfElements ; index++){
                    String valueString = elements[index] ;
                    VeamUtil.log("debug", "valueString="+valueString) ;
                    String[] values = valueString.split("\\|") ;
                    if(values.length >= 4){
                        String mixedId = values[0] ;
                        String status = values[1] ;
                        String statusText = values[2] ;
                        String thumbnailUrl = values[3] ;
                        VeamUtil.log("debug", "mixedId="+mixedId) ;
                        VeamUtil.log("debug", "status="+status) ;
                        VeamUtil.log("debug", "statusText="+statusText) ;
                        MixedObject mixed = contents.getMixedForId(mixedId) ;
                        if(mixed != null){
                            mixed.setStatus(status) ;
                            mixed.setStatusText(statusText) ;
                            mixed.setThumbnailUrl(thumbnailUrl) ;
                            VeamUtil.log("debug", "set id=" + mixed.getId() + " status=" + mixed.getStatus()) ;
                        }
                    }
                }
            }
        }
    }
}
