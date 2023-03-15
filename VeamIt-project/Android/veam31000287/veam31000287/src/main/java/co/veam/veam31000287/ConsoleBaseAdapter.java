package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by veam on 11/15/16.
 */
abstract class ConsoleBaseAdapter extends BaseAdapter implements View.OnClickListener, View.OnTouchListener {

    public static final int COLOR_TYPE_LEFT_BLACK       = 1 ;
    public static final int COLOR_TYPE_LEFT_RED         = 2 ;
    public static final int COLOR_TYPE_TOP_BLACK       = 3 ;
    public static final int COLOR_TYPE_TOP_RED         = 4 ;
    public static final int COLOR_TYPE_ALL_BLACK       = 5 ;

    public static final int VIEWID_RIGHT_EDIT_TEXT      = 1 ;
    public static final int VIEWID_STOP_BUTTON          = 2 ;
    public static final int VIEWID_REMOVE_BUTTON        = 3 ;

    protected ConsoleActivity consoleActivity ;
    protected int listWidth ;
    protected Context context ;
    protected float scaledDensity ;
    protected Typeface typefaceRobotoLight ;
    private EditText inputEditText ;
    protected boolean modified ;


    public ConsoleBaseAdapter(ConsoleActivity consoleActivity){
        this.context = AnalyticsApplication.getContext() ;
        this.consoleActivity = consoleActivity ;
        this.listWidth = consoleActivity.deviceWidth ;
        this.scaledDensity = consoleActivity.scaledDensity ;
        this.modified = false ;

    }

    public boolean isModified() {
        return modified;
    }

    public void setModified(boolean modified) {
        this.modified = modified;
    }

    public View getLeftRightTextView(String leftString,String rightString,int colorType){
        VeamUtil.log("debug", "getLeftRightTextView " + leftString + " : " + rightString) ;
        int leftColor = Color.BLACK ;
        int rightColor = Color.RED ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_LEFT_BLACK){
                leftColor = Color.BLACK ;
                rightColor = Color.RED ;
            } else  if(colorType == COLOR_TYPE_LEFT_RED){
                leftColor = Color.RED ;
                rightColor = Color.BLACK ;
            }
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;
        view.setOnClickListener(this);

        TextView leftText = new TextView(context) ;
        leftText.setText(leftString);
        leftText.setTextColor(leftColor);
        leftText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        leftText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        leftText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        leftText.setPadding(padding, 0, padding, 0);
        ConsoleUtil.setTextSizeWithin(listWidth * 70 / 100, leftText) ;
        view.addView(leftText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight));


        TextView rightText = new TextView(context) ;
        //EditText rightText = new EditText(context) ;
        rightText.setId(VIEWID_RIGHT_EDIT_TEXT) ;
        rightText.setText(rightString);
        rightText.setBackgroundColor(Color.TRANSPARENT);
        rightText.setTextColor(rightColor);
        rightText.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        rightText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        rightText.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT) ;
        rightText.setPadding(padding, 0, padding, 0);
        /*
        rightText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                VeamUtil.log("onFocusChanged1", "View : " + v + ", hasFocus : " + hasFocus);
                if (hasFocus) {
                    v.setTag(R.string.tag_key_focus, Integer.valueOf(1));
                } else {
                    v.setTag(R.string.tag_key_focus, Integer.valueOf(0));
                }
            }
        });
        */

        float orgSize = ((float) listWidth * 5.0f / 100 / scaledDensity) ;
        //VeamUtil.log("debug", "set org size=" + orgSize) ;


        int rightTextMaxWidth = listWidth - padding * 2 - ConsoleUtil.getTextWidth(leftText) - padding ;
        ConsoleUtil.setTextSizeWithin(rightTextMaxWidth, rightText) ;

        view.addView(rightText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight));

        view.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(listWidth * 5 / 100, cellHeight - 1, listWidth, 1));

        return view ;
    }

    public View getLineView(){
        View lineView = new View(context) ;
        lineView.setBackgroundColor(Color.BLACK);
        return lineView ;
    }

    public View getTopBottomTextView(String topString,String bottomString,int colorType){
        VeamUtil.log("debug", "getTopBottomTextView " + topString) ;
        int topColor = Color.BLACK ;
        int bottomColor = Color.RED ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_TOP_BLACK){
                topColor = Color.BLACK ;
                bottomColor = Color.RED ;
            } else  if(colorType == COLOR_TYPE_TOP_RED){
                topColor = Color.RED ;
                bottomColor = Color.BLACK ;
            }
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        LinearLayout view = new LinearLayout(context) ;
        view.setOrientation(LinearLayout.VERTICAL);
        view.setBackgroundColor(Color.TRANSPARENT) ;
        view.setOnClickListener(this);

        TextView topText = new TextView(context) ;
        topText.setText(topString);
        topText.setTextColor(topColor);
        topText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        topText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        topText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        topText.setPadding(padding, 0, padding, 0);
        view.addView(topText, new LinearLayout.LayoutParams(listWidth, cellHeight));


        TextView bottomText = new TextView(context) ;
        //EditText bottomText = new EditText(context) ;
        //bottomText.setId(VIEWID_RIGHT_EDIT_TEXT) ;
        bottomText.setText(bottomString);
        bottomText.setBackgroundColor(Color.TRANSPARENT);
        bottomText.setTextColor(bottomColor);
        bottomText.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        bottomText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        bottomText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        bottomText.setPadding(padding, 0, padding, 0);

        view.addView(bottomText, new LinearLayout.LayoutParams(listWidth, LinearLayout.LayoutParams.WRAP_CONTENT));

        LinearLayout.LayoutParams linearLayoutParamas = new LinearLayout.LayoutParams(listWidth, 1) ;
        linearLayoutParamas.setMargins(padding, padding, 0, 0);
        view.addView(getLineView(),linearLayoutParamas);

        return view ;
    }


    public View getTopAndSmallBottomTextView(String topString,String bottomString,int colorType){
        VeamUtil.log("debug", "getTopAndSmallBottomTextView " + topString + " : " + bottomString) ;
        int topColor = Color.BLACK ;
        int bottomColor = Color.RED ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_LEFT_BLACK){
                topColor = Color.BLACK ;
                bottomColor = Color.RED ;
            } else  if(colorType == COLOR_TYPE_LEFT_RED){
                topColor = Color.RED ;
                bottomColor = Color.BLACK ;
            } else  if(colorType == COLOR_TYPE_ALL_BLACK){
                topColor = Color.BLACK ;
                bottomColor = Color.BLACK ;
            }
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        int textMaxWidth = listWidth - padding * 2 ;
        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;
        view.setOnClickListener(this);

        TextView topText = new TextView(context) ;
        topText.setText(topString);
        topText.setTextColor(topColor);
        topText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        topText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        topText.setGravity(Gravity.BOTTOM | Gravity.LEFT) ;
        topText.setPadding(padding, 0, padding, 0);
        ConsoleUtil.setTextSizeWithin(listWidth * 70 / 100, topText) ;
        view.addView(topText, ConsoleUtil.getRelativeLayoutPrams(0, cellHeight*5/100, listWidth, cellHeight / 2));
        ConsoleUtil.setTextSizeWithin(textMaxWidth, topText) ;


        TextView bottomText = new TextView(context) ;
        bottomText.setText(bottomString);
        bottomText.setBackgroundColor(Color.TRANSPARENT);
        bottomText.setTextColor(bottomColor);
        bottomText.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        bottomText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        bottomText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        bottomText.setPadding(padding, 0, padding, 0);
        ConsoleUtil.setTextSizeWithin(textMaxWidth, bottomText) ;

        view.addView(bottomText, ConsoleUtil.getRelativeLayoutPrams(0, cellHeight/2, listWidth, cellHeight/2));

        view.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(listWidth * 5 / 100, cellHeight - 1, listWidth, 1));

        return view ;
    }

    /*
    public View getTopAndSmallBottomTextView(String topString,String bottomString,int colorType){
        VeamUtil.log("debug", "getTopAndSmallBottomTextView " + topString) ;
        int topColor = Color.BLACK ;
        int bottomColor = Color.RED ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_TOP_BLACK){
                topColor = Color.BLACK ;
                bottomColor = Color.RED ;
            } else  if(colorType == COLOR_TYPE_TOP_RED){
                topColor = Color.RED ;
                bottomColor = Color.BLACK ;
            } else  if(colorType == COLOR_TYPE_ALL_BLACK){
                topColor = Color.BLACK ;
                bottomColor = Color.BLACK ;
            }
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        int textWidth = listWidth - padding * 2 ;
        LinearLayout view = new LinearLayout(context) ;
        view.setOrientation(LinearLayout.VERTICAL);
        view.setBackgroundColor(Color.TRANSPARENT) ;
        view.setOnClickListener(this);

        TextView topText = new TextView(context) ;
        topText.setText(topString);
        topText.setTextColor(topColor);
        topText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        topText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        topText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        topText.setPadding(padding, 0, padding, 0);
        view.addView(topText, new LinearLayout.LayoutParams(listWidth, cellHeight/2));
        ConsoleUtil.setTextSizeWithin(textWidth, topText);


        TextView bottomText = new TextView(context) ;
        bottomText.setText(bottomString);
        bottomText.setBackgroundColor(Color.TRANSPARENT);
        bottomText.setTextColor(bottomColor);
        bottomText.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        bottomText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        bottomText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        bottomText.setPadding(padding, 0, padding, 0);
        view.addView(bottomText, new LinearLayout.LayoutParams(listWidth, cellHeight/2));
        ConsoleUtil.setTextSizeWithin(textWidth, bottomText);

        LinearLayout.LayoutParams linearLayoutParamas = new LinearLayout.LayoutParams(listWidth, 1) ;
        linearLayoutParamas.setMargins(padding, padding, 0, 0);
        view.addView(getLineView(),linearLayoutParamas);

        return view ;
    }
    */

    public View getTitleTextView(String leftString,int colorType){
        VeamUtil.log("debug", "getTitleTextView " + leftString) ;
        int leftColor = Color.BLACK ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_LEFT_BLACK){
                leftColor = Color.BLACK ;
            } else  if(colorType == COLOR_TYPE_LEFT_RED){
                leftColor = Color.RED ;
            }
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;
        //view.setOnClickListener(this);

        TextView leftText = new TextView(context) ;
        leftText.setText(leftString);
        leftText.setTextColor(leftColor);
        leftText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        leftText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        leftText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        leftText.setPadding(padding, 0, padding, 0);
        view.addView(leftText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight));
        ConsoleUtil.setTextSizeWithin(listWidth - padding * 3, leftText);

        view.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(listWidth * 5 / 100, cellHeight - 1, listWidth, 1));

        return view ;
    }

    public View getTitleClickableView(String leftString,int colorType){
        VeamUtil.log("debug", "getTitleClickableView " + leftString) ;

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        RelativeLayout view = (RelativeLayout)getTitleTextView(leftString,colorType) ;

        int arrowWidth = listWidth * 8 / 320 ;
        int arrowHeight = listWidth * 13 / 320 ;
        ImageView arrowImageView = new ImageView(consoleActivity) ;
        arrowImageView.setImageResource(R.drawable.setting_arrow);
        view.addView(arrowImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - padding - arrowWidth, (cellHeight - arrowHeight) / 2, arrowWidth, arrowHeight)) ;
        view.setOnClickListener(this);

        return view ;
    }

    public View getTextOrderStopView(String leftString,String stopString,int colorType){
        //VeamUtil.log("debug", "getTextOrderStopView " + leftString + " stop="+stopString) ;
        int leftColor = Color.BLACK ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_LEFT_BLACK){
                leftColor = Color.BLACK ;
            } else  if(colorType == COLOR_TYPE_LEFT_RED){
                leftColor = Color.RED ;
            }
        }

        int stopImageResourceId = R.drawable.list_disable_off ;
        if(stopString.equals("1")){
            leftColor = VeamUtil.getColorFromArgbString("FFC0C0C0") ;
            stopImageResourceId = R.drawable.list_disable_on ;
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;


        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;
        int stopWidth = listWidth * 27 / 320 ;
        int stopHeight = listWidth * 44 / 320 ;
        int orderWidth = listWidth * 27 / 320 ;
        int orderHeight = listWidth * 27 / 320 ;

        TextView leftText = new TextView(context) ;
        leftText.setText(leftString);
        leftText.setTextColor(leftColor);
        leftText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        leftText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        leftText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        leftText.setPadding(padding, 0, padding, 0);
        view.addView(leftText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight));
        ConsoleUtil.setTextSizeWithin(listWidth - padding * 3 - stopWidth - orderWidth, leftText);

        view.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(listWidth * 5 / 100, cellHeight - 1, listWidth, 1));

        ImageView stopImageView = new ImageView(consoleActivity) ;
        stopImageView.setId(VIEWID_STOP_BUTTON);
        stopImageView.setImageResource(stopImageResourceId);
        view.addView(stopImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - padding - stopWidth, (cellHeight - stopHeight) / 2, stopWidth, stopHeight)) ;
        //stopImageView.setOnClickListener(this) ;
        stopImageView.setOnTouchListener(this);


        ImageView orderImageView = new ImageView(consoleActivity) ;
        orderImageView.setImageResource(R.drawable.list_move_on);
        view.addView(orderImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - padding - stopWidth - orderWidth, (cellHeight - orderHeight) / 2, orderWidth, orderHeight)) ;
        //view.setOnClickListener(this);

        return view ;
    }

    public View getTextOrderRemoveView(String leftString,int colorType){
        //VeamUtil.log("debug", "getTextOrderRemoveView " + leftString) ;
        int leftColor = Color.BLACK ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_LEFT_BLACK){
                leftColor = Color.BLACK ;
            } else  if(colorType == COLOR_TYPE_LEFT_RED){
                leftColor = Color.RED ;
            }
        }

        int removeImageResourceId = R.drawable.list_delete_on ;

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;

        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;
        int removeWidth = listWidth * 27 / 320 ;
        int removeHeight = listWidth * 44 / 320 ;
        int orderWidth = listWidth * 27 / 320 ;
        int orderHeight = listWidth * 27 / 320 ;

        TextView leftText = new TextView(context) ;
        leftText.setText(leftString);
        leftText.setTextColor(leftColor);
        leftText.setTextSize((float) listWidth * 5.0f / 100 / scaledDensity);
        leftText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        leftText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        leftText.setPadding(padding, 0, padding, 0);
        view.addView(leftText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight));
        ConsoleUtil.setTextSizeWithin(listWidth - padding * 3 - removeWidth - orderWidth, leftText);

        view.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(listWidth * 5 / 100, cellHeight - 1, listWidth, 1));

        ImageView removeImageView = new ImageView(consoleActivity) ;
        removeImageView.setId(VIEWID_REMOVE_BUTTON);
        removeImageView.setImageResource(removeImageResourceId);
        view.addView(removeImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - padding - removeWidth, (cellHeight - removeHeight) / 2, removeWidth, removeHeight)) ;
        //stopImageView.setOnClickListener(this) ;
        removeImageView.setOnTouchListener(this);


        ImageView orderImageView = new ImageView(consoleActivity) ;
        orderImageView.setImageResource(R.drawable.list_move_on);
        view.addView(orderImageView, ConsoleUtil.getRelativeLayoutPrams(listWidth - padding - removeWidth - orderWidth, (cellHeight - orderHeight) / 2, orderWidth, orderHeight)) ;
        //view.setOnClickListener(this);

        return view ;
    }

    public View getSmallTitleTextView(String leftString,int colorType){
        VeamUtil.log("debug", "getSmallTitleTextView " + leftString) ;
        int leftColor = Color.BLACK ;
        if(colorType != 0){
            if(colorType == COLOR_TYPE_LEFT_BLACK){
                leftColor = Color.BLACK ;
            } else  if(colorType == COLOR_TYPE_LEFT_RED){
                leftColor = Color.RED ;
            }
        }

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;

        TextView leftText = new TextView(context) ;
        leftText.setText(leftString);
        leftText.setTextColor(leftColor);
        leftText.setTextSize((float) listWidth * 4.0f / 100 / scaledDensity);
        leftText.setTypeface(ConsoleUtil.getTypefaceRobotoLight());
        leftText.setGravity(Gravity.BOTTOM | Gravity.LEFT) ;
        leftText.setPadding(padding, 0, padding, 0);
        view.addView(leftText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight*90/100));

        view.addView(getLineView(), ConsoleUtil.getRelativeLayoutPrams(0, cellHeight - 1, listWidth, 1));

        return view ;
    }

    public View getSpacerView(){
        VeamUtil.log("debug", "getSpacerView ") ;

        int cellHeight = listWidth * 14 / 100 ;
        int padding = listWidth * 5 / 100 ;
        RelativeLayout view = new RelativeLayout(context) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;

        TextView leftText = new TextView(context) ;
        leftText.setText(" ");
        leftText.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT) ;
        view.addView(leftText, ConsoleUtil.getRelativeLayoutPrams(0, 0, listWidth, cellHeight));

        return view ;
    }

    protected View getDefaultView(int position,View convertView){
        View retView = null ;
        ConsoleAdapterElement item = (ConsoleAdapterElement)this.getItem(position) ;

        if (item != null) {
            int kind = item.getKind();
            if (kind == ConsoleAdapterElement.KIND_EDITABLE_TEXT) {
                retView = this.getLeftRightTextView(item.getTitle(), item.getValue(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT) {
                retView = this.getTopBottomTextView(item.getTitle(), item.getValue(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_EDITABLE_SELECT) {
                retView = this.getLeftRightTextView(item.getTitle(), item.getValue(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_TITLE_ONLY) {
                retView = this.getTitleTextView(item.getTitle(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_TITLE_CLICKABLE) {
                retView = this.getTitleClickableView(item.getTitle(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_SPACER) {
                retView = this.getSpacerView();
            } else if (kind == ConsoleAdapterElement.KIND_SMALL_TITLE) {
                retView = this.getSmallTitleTextView(item.getTitle(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_TITLE_AND_DESCRIPTION) {
                retView = this.getTopAndSmallBottomTextView(item.getTitle(), item.getValue(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_TEXT_CLICKABLE) {
                retView = this.getLeftRightTextView(item.getTitle(), item.getValue(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_TEXT_ORDER_STOP) {
                retView = this.getTextOrderStopView(item.getTitle(), item.getValue(), item.getColorType());
            } else if (kind == ConsoleAdapterElement.KIND_TEXT_ORDER_REMOVE) {
                retView = this.getTextOrderRemoveView(item.getTitle(), item.getColorType());
            } else {
                retView = new View(context);
            }
        } else {
            VeamUtil.log("debug","item==null position="+position) ;
            retView = new View(context);
        }

        retView.setTag(Integer.valueOf(position));

        return retView ;
    }

    @Override
    public void onClick(View v) {
        VeamUtil.log("debug", "ConsoleBaseAdapter::onClick") ;
        if(v != null) {
            Integer integer = (Integer) v.getTag() ;
            if(integer != null) {
                final int position = integer ;
                ConsoleAdapterElement item = (ConsoleAdapterElement) this.getItem(position);
                if (item != null) {
                    int kind = item.getKind();
                    if (kind == ConsoleAdapterElement.KIND_EDITABLE_TEXT) {
                        showEditText(position, item.getTitle(), item.getValue());
                    } else if (kind == ConsoleAdapterElement.KIND_EDITABLE_LONG_TEXT) {
                        showEditText(position, item.getTitle(), item.getValue());
                    } else if (kind == ConsoleAdapterElement.KIND_EDITABLE_SELECT) {
                        showSelection(position, item.getTitle(), item.getValue(), item.getValues());
                    } else if (kind == ConsoleAdapterElement.KIND_TITLE_CLICKABLE) {
                        onTitleClick(position, item.getTitle());
                    } else if (kind == ConsoleAdapterElement.KIND_TITLE_AND_DESCRIPTION) {
                        onTitleClick(position, item.getTitle());
                    } else if (kind == ConsoleAdapterElement.KIND_TEXT_CLICKABLE) {
                        onTextClick(position, item.getTitle());
                    }
                }
            } else {
                VeamUtil.log("debug","integer == null") ;
            }
        } else {
            VeamUtil.log("debug","view == null") ;
        }
    }

    public void showEditText(int position,String title,String value){
        final int workPosition = position ;
        final String workTitle = title ;
        final String workValue = value ;
        inputEditText = new EditText(consoleActivity) ;
        if(!VeamUtil.isEmpty(value)){
            inputEditText.setText(value) ;
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(consoleActivity);
        builder.setTitle(workTitle);
        //builder.setMessage(this.getString(R.string.why_are_you_reporting_this_photo)) ;
        builder.setView(inputEditText);
        builder.setPositiveButton("OK",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //VeamUtil.log("debug","report "+currentPictureObject.getId()+" "+reportEditText.getText().toString()) ;
                        String newText = inputEditText.getText().toString();
                        if(!newText.equals(workValue)) {
                            setNewValue(workPosition, newText);
                            notifyDataSetChanged();
                            modified = true;
                        }
                    }
                });

        builder.setNegativeButton(context.getString(R.string.cancel), null);
        final AlertDialog dialog = builder.create();
        dialog.show();

        inputEditText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
                }
            }
        });
    }

    public void showSelection(int position,String title,String value,String[] values){
        final int workPosition = position ;
        final String workTitle = title ;
        final String workValue = value ;
        final String[] workValues = values ;
        final List<Integer> checkedItems = new ArrayList<>();

        int defaultItem = -1 ;
        int count = values.length ;
        for(int index = 0 ; index < count ; index++){
            VeamUtil.log("debug","value compare " + value + ":" + values[index]) ;
            if(value.equals(values[index])){
                defaultItem = index ;
                checkedItems.add(defaultItem);
                break ;
            }
        }
        new AlertDialog.Builder(consoleActivity)
            .setTitle(title)
            .setSingleChoiceItems(values, defaultItem, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    checkedItems.clear();
                    checkedItems.add(which);
                }
            })
            .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (!checkedItems.isEmpty()) {
                        int index = checkedItems.get(0);
                        VeamUtil.log("checkedItem:", "" + index);
                        String newText = workValues[index];
                        if (!newText.equals(workValue)) {
                            setNewValue(workPosition, newText);
                            notifyDataSetChanged();
                            modified = true;
                        }
                    }
                }
            })
            .setNegativeButton("Cancel", null)
            .show();
    }

    public void onTitleClick(int position,String title){
        VeamUtil.log("debug", "onTitleClicked should be overridden : " + position + " : " + title) ;
    }

    public void onTextClick(int position,String title){
        VeamUtil.log("debug", "onTextClick should be overridden : " + position + " : " + title) ;
    }


    public void setNewValue(int position,String newValue){
        VeamUtil.log("debug", "ConsoleBaseAdapter::setNewValue " + position + " " + newValue) ;
    }

    @Override
    public int getItemViewType(int position){
        int itemType = 0 ;
        Object object = this.getItem(position) ;
        if(object instanceof ConsoleAdapterElement) {
            ConsoleAdapterElement item = (ConsoleAdapterElement) this.getItem(position);
            if (item != null) {
                itemType = item.getKind();
            }
        }

        return itemType ;
    }

    @Override
    public int getViewTypeCount(){
        return ConsoleAdapterElement.NUMBER_OF_KINDS ;
    }

    @Override
    public int getCount() {
        return 0;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //VeamUtil.log("debug", "getView:" + position) ;
        View retView = getDefaultView(position,convertView) ;
        return retView ;
    }


    @Override
    public boolean onTouch(View view, MotionEvent event) {
        //VeamUtil.log("debug","ConsoleActivity::onTouch") ;
        boolean consume = false ;
        if(event.getAction() == MotionEvent.ACTION_DOWN){
            VeamUtil.log("debug","ACTION_DOWN") ;
            if(view.getId() == VIEWID_STOP_BUTTON) {
                VeamUtil.log("debug", "VIEWID_STOP_BUTTON");
                View viewParent = (View) view.getParent();
                Integer integer = (Integer) viewParent.getTag();
                if (integer != null) {
                    int position = integer;
                    consoleActivity.onClickStopButton(position);
                    consume = true;
                }
            } else if(view.getId() == VIEWID_REMOVE_BUTTON){
                VeamUtil.log("debug","VIEWID_REMOVE_BUTTON") ;
                View viewParent = (View)view.getParent() ;
                Integer integer = (Integer)viewParent.getTag() ;
                if(integer != null){
                    int position = integer ;
                    consoleActivity.onClickRemoveButton(position) ;
                    consume = true ;
                }
            }
        }
        return consume;
    }

    public int getCellHeight(){
        return listWidth * 14 / 100 ;
    }

    public boolean isDraggable(){
        return false ;
    }

    public int getDraggableX1(){
        int padding = listWidth * 5 / 100 ;
        int stopWidth = listWidth * 27 / 320 ;
        int orderWidth = listWidth * 27 / 320 ;
        int x1 = listWidth - padding - stopWidth - orderWidth ;
        return x1 ;
    }

    public int getDraggableX2(){
        int padding = listWidth * 5 / 100 ;
        int stopWidth = listWidth * 27 / 320 ;
        int x2 = listWidth - padding - stopWidth ;
        return x2 ;
    }
}
