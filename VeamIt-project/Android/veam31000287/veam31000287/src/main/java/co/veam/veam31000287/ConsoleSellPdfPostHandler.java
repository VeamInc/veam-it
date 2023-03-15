package co.veam.veam31000287;

import java.util.ArrayList;

/**
 * Created by veam on 11/8/16.
 */
public class ConsoleSellPdfPostHandler implements HandlePostResultInterface {
    SellPdfObject sellPdf ;
    PdfObject pdf ;

    public SellPdfObject getSellPdf() {
        return sellPdf;
    }

    public void setSellPdf(SellPdfObject sellPdf) {
        this.sellPdf = sellPdf;
    }

    public PdfObject getPdf() {
        return pdf;
    }

    public void setPdf(PdfObject pdf) {
        this.pdf = pdf;
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 2){
            //NSLog(@"count >= 2") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                String sellPdfId = results.get(1) ;
                String pdfId = results.get(2) ;

                sellPdf.setId(sellPdfId) ;
                pdf.setId(pdfId) ;
            }
        }
    }
}
