package co.veam.veam31000287;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by veam on 11/24/16.
 */
public class ConsoleEditRatingAdapter extends ConsoleBaseAdapter {

    private int questionCount ;

    public ConsoleEditRatingAdapter(ConsoleActivity consoleActivity)
    {
        super(consoleActivity) ;

        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents();
        this.questionCount = consoleContents.getNumberOfAppRatingQuestions() ;
    }

    @Override
    public int getCount() {
        return questionCount + 1;
    }

    @Override
    public Object getItem(int position) {
        ConsoleAdapterElement item = null ;
        if(position == 0) {
            item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_TITLE_ONLY, ConsoleBaseAdapter.COLOR_TYPE_LEFT_BLACK, context.getString(R.string.app_info_rating), " ", null);
        } else {
            int index = position - 1 ;
            ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
            AppRatingQuestion appRatingQuestion = consoleContents.getAppRatingQuestionAt(index) ;
            String[] values = appRatingQuestion.getSelectionString().split("\\|") ;
            item = new ConsoleAdapterElement(0,ConsoleAdapterElement.KIND_EDITABLE_SELECT, ConsoleBaseAdapter.COLOR_TYPE_LEFT_RED,appRatingQuestion.getQuestionString(),appRatingQuestion.getAnswer(),values);
        }
        return item ;
    }

    @Override
    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleEditRatingAdapter::setNewValue " + position + " " + newValue) ;
        int index = position - 1 ;
        ConsoleContents consoleContents = ConsoleUtil.getConsoleContents() ;
        AppRatingQuestion appRatingQuestion = consoleContents.getAppRatingQuestionAt(index) ;
        appRatingQuestion.setAnswer(newValue) ;
        consoleContents.setAppRatingQuestion(appRatingQuestion) ;
    }

}
