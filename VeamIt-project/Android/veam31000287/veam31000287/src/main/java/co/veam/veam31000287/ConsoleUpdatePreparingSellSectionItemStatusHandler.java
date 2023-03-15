package co.veam.veam31000287;

import java.util.ArrayList;

/**
 * Created by veam on 11/8/16.
 */
public class ConsoleUpdatePreparingSellSectionItemStatusHandler implements HandlePostResultInterface {
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
                        String sellSectionItemId = values[0] ;
                        String status = values[1] ;
                        String statusText = values[2] ;
                        SellSectionItemObject sellSectionItem = contents.getSellSectionItemForId(sellSectionItemId) ;
                        if(sellSectionItem != null){
                            sellSectionItem.setStatus(status) ;
                            sellSectionItem.setStatusText(statusText) ;
                        }
                    } else {
                        //NSLog(@"%@ less than 3",valueString) ;
                    }
                }
            }
        }

    }
}
