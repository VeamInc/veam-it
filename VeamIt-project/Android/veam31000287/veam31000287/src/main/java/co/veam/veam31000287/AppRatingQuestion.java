package co.veam.veam31000287;

import org.xml.sax.Attributes;

/**
 * Created by veam on 10/27/16.
 */
public class AppRatingQuestion {

    private String appRatingQuestionId ;
    private String question ;
    private String questionJa ;
    private String selections ;
    private String selectionsJa ;
    private String answer ;

    public String getAppRatingQuestionId() {
        return appRatingQuestionId;
    }

    public void setAppRatingQuestionId(String appRatingQuestionId) {
        this.appRatingQuestionId = appRatingQuestionId;
    }

    public String getQuestion() {
        String retValue ;
        if(VeamUtil.isLocaleJapanese()){
            retValue = questionJa ;
        } else {
            retValue = question ;
        }
        return retValue;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getQuestionJa() {
        return questionJa;
    }

    public void setQuestionJa(String questionJa) {
        this.questionJa = questionJa;
    }

    public String getSelections() {
        String retValue ;
        if(VeamUtil.isLocaleJapanese()){
            retValue = selectionsJa ;
        } else {
            retValue = selections ;
        }
        return retValue;
    }

    public void setSelections(String selections) {
        this.selections = selections;
    }

    public String getSelectionsJa() {
        return selectionsJa;
    }

    public void setSelectionsJa(String selectionsJa) {
        this.selectionsJa = selectionsJa;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }


//- (id)initWithAttributes:(NSDictionary *)attributeDict ;

    public String getQuestionString(){
        String retValue = question ;
        if(VeamUtil.isLocaleJapanese()){
            retValue = questionJa ;
        }
        return retValue ;
    }

    public String getSelectionString(){
        String retValue = selections ;
        if(VeamUtil.isLocaleJapanese()){
            retValue = selectionsJa ;
        }
        return retValue ;
    }

    public AppRatingQuestion(Attributes attributes){
        this.setAppRatingQuestionId(attributes.getValue("id")) ;
        this.setQuestion(attributes.getValue("q")) ;
        this.setQuestionJa(attributes.getValue("qj")) ;
        this.setSelections(attributes.getValue("s")) ;
        this.setSelectionsJa(attributes.getValue("sj")) ;
        this.setAnswer(attributes.getValue("a")) ;
    }

}
