package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.InputType;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by veam on 12/13/16.
 */
public class ConsoleMessageActivity extends ConsoleActivity implements ConsoleMessageAdapter.ConsoleMessageAdapterActivityInterface/*, OverScrollListView.OnOverScrollListViewSizeChangedListener*/ {

    public static int VIEWID_USER_DESCRIPTION_TEXT = 0x10001;
    public static int VIEWID_POST_BUTTON = 0x10002;
    public static int VIEWID_USER_NAME = 0x10003;
    public static int VIEWID_USER_IMAGE = 0x10005;
    public static int VIEWID_ACTION_IMAGE = 0x10006;
    public static int VIEWID_ACTION_LABEL = 0x10007;
    public static int VIEWID_POSTS_NUM = 0x10008;
    public static int VIEWID_FOLLOWERS_NUM = 0x10009;
    public static int VIEWID_FOLLOWINGS_NUM = 0x1000A;
    public static int VIEWID_POSTS_BAR = 0x1000B;
    public static int VIEWID_FOLLOWERS_BAR = 0x1000C;
    public static int VIEWID_FOLLOWINGS_BAR = 0x1000D;
    public static int VIEWID_USER_DESCRIPTION_SCROLL = 0x1000F;
    public static int VIEWID_FIND_USER_BUTTON = 0x10010;
    public static int VIEWID_MAP_BUTTON = 0x10011;
    public static int VIEWID_MESSAGE_IMAGE = 0x10012;
    public static int VIEWID_MESSAGE_SEND_TEXT = 0x10013;
    public static int VIEWID_TOP_BAR_BLOCK_BUTTON = 0x10014;


    private ConsoleMessageAdapter messageAdapter;

    /*
    private RelativeLayout messageInputView;
    private EditText messageEditText;
    private ProgressBar sendMessageProgressBar;
    private ProgressBar messageProgressBar;
    */

    private boolean isSendingMessage;

    private int inputHeight;

    private OverScrollListView messageListView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_console);

        rootLayout = (RelativeLayout) this.findViewById(R.id.rootLayout);
        this.setupViews();

        messageAdapter = new ConsoleMessageAdapter(this, this, null, deviceWidth, topBarHeight + ConsoleUtil.getStatusBarHeight(), scaledDensity);
        //this.addMainList(adapter);
        if (mainView != null) {
            VeamUtil.log("debug", "mainview exists");
            //inputHeight = deviceWidth * 98 / 640;
            inputHeight = 0 ;
            int listHeight = deviceHeight - ConsoleUtil.getStatusBarHeight() - topBarHeight - inputHeight;


            messageListView = new OverScrollListView(this, topBarHeight);
            messageListView.setSelector(new ColorDrawable(Color.argb(0x00, 0xFD, 0xD4, 0xDB)));
            //messageListView.setOnItemClickListener(this);
            messageListView.setBackgroundColor(Color.TRANSPARENT);
            messageListView.setCacheColorHint(Color.TRANSPARENT);
            messageListView.setVerticalScrollBarEnabled(false);
            //messageListView.setPadding(0, 0, 0, deviceWidth * 50 / 100);
            //messageListView.setClipToPadding(false);
            messageListView.setDivider(null);
            //messageListView.setOnOverScrollListViewSizeChangedListener(this);
            messageListView.setPadding(0, 0, 0, inputHeight);
            messageListView.setClipToPadding(false);
            messageListView.setAdapter(messageAdapter);

            mainView.addView(messageListView, ConsoleUtil.getRelativeLayoutPrams(0, topBarHeight, deviceWidth, listHeight));

            /*
            messageInputView = new RelativeLayout(this);
            messageInputView.setBackgroundColor(Color.WHITE); // FFD5D5D5
            messageInputView.setBackgroundResource(R.drawable.message_input_area);
            messageInputView.setVisibility(View.VISIBLE);
            mainView.addView(messageInputView, ConsoleUtil.getRelativeLayoutPrams(0, listHeight, deviceWidth, inputHeight));

            int editHeight = deviceWidth * 10 / 100;
            messageEditText = new EditText(this);
            messageEditText.setInputType(InputType.TYPE_CLASS_TEXT);
            messageEditText.setMaxLines(1);
            messageEditText.setBackgroundColor(Color.argb(0xFF, 0xFF, 0xFF, 0xFF));
            messageEditText.setBackgroundResource(R.drawable.message_send_text);
            messageEditText.setGravity(Gravity.TOP);
            messageEditText.setTypeface(typefaceRobotoLight);
            messageEditText.setTextSize((float) deviceWidth * 5.3f / 100 / scaledDensity);
            messageEditText.setOnFocusChangeListener(this);
            messageInputView.addView(messageEditText, ConsoleUtil.getRelativeLayoutPrams(deviceWidth * 3 / 100, (inputHeight - editHeight) / 2, deviceWidth * 80 / 100, editHeight));

            int messageTextHeight = inputHeight;
            int messageTextWidth = deviceWidth * 14 / 100;
            int messageTextX = deviceWidth * 86 / 100;

            TextView messageSendTextView = new TextView(this);
            messageSendTextView.setId(VIEWID_MESSAGE_SEND_TEXT);
            messageSendTextView.setOnClickListener(this);
            messageSendTextView.setText("Send");
            messageSendTextView.setTextColor(Color.GRAY);
            messageSendTextView.setGravity(Gravity.CENTER_VERTICAL);
            messageSendTextView.setTextSize((float) deviceWidth * 5.3f / 100 / scaledDensity);
            messageSendTextView.setTypeface(typefaceRobotoLight);
            messageInputView.addView(messageSendTextView, ConsoleUtil.getRelativeLayoutPrams(messageTextX, 0, messageTextWidth, messageTextHeight));

            sendMessageProgressBar = new ProgressBar(this);
            sendMessageProgressBar.setIndeterminate(true);
            sendMessageProgressBar.setVisibility(View.GONE);
            messageInputView.addView(sendMessageProgressBar, ConsoleUtil.getRelativeLayoutPrams(messageTextX + (messageTextWidth - messageTextHeight) / 2, 0, messageTextHeight, messageTextHeight));

            messageProgressBar = new ProgressBar(this);
            messageProgressBar.setIndeterminate(true);
            messageProgressBar.setVisibility(View.VISIBLE);
            mainView.addView(messageProgressBar, ConsoleUtil.getRelativeLayoutPrams(deviceWidth * 45 / 100, deviceHeight / 2, deviceWidth * 10 / 100, deviceWidth * 10 / 100));
            */
        }
        reloadMessage();
    }

    /*
    @Override
    public void onOverScrollListViewHeightChanged(int newHeight, int oldHeight) {
        //VeamUtil.log("debug","onOverScrollListViewHeightChanged h="+newHeight) ;
        final int targetHeight = newHeight;
        if (messageInputView != null) {
            RelativeLayout.LayoutParams relativeLayoutParams = (RelativeLayout.LayoutParams) messageInputView.getLayoutParams();
            relativeLayoutParams.setMargins(0, targetHeight, 0, 0);
            messageInputView.setLayoutParams(relativeLayoutParams);
            messageInputView.invalidate();
            messageInputView.requestLayout();
        }
    }
    */

    /*
    @Override
    public void onOverScrollListViewSizeChanged(int w, int h, int oldw, int oldh) {

    }
    */


    @Override
    public void onConsoleDataPostDone(String apiName) {
        VeamUtil.log("debug", "onConsoleDataPostDone " + apiName);
        hideFullscreenProgress();
        //this.finishHorizontal();
        if (messageAdapter != null) {
            messageAdapter.notifyDataSetChanged();
        }
    }

    @Override
    public void onConsoleDataPostFailed(String apiName) {
        VeamUtil.log("debug", "onConsoleDataPostFailed " + apiName);
        VeamUtil.showMessage(this, "Failed to send data");
        hideFullscreenProgress();
    }


    @Override
    public void updateMessage(ConsoleMessageXml messageXml, int pageNo) {
        /*
        if (messageProgressBar != null) {
            messageProgressBar.setVisibility(View.GONE);
        }
        */

        if (loadMoreArea != null) {
            loadMoreArea.setVisibility(View.GONE);
        }
        //VeamUtil.log("debug","updatemessage") ;

        if (pageNo == 1) {
            messageAdapter.setMessages(messageXml);
        } else {
            messageAdapter.addMessages(messageXml);
        }

        //messageListView.setScrollStateNormal() ;
        messageAdapter.notifyDataSetChanged();

        messageListView.setSelection(messageAdapter.getCount() - 1);

    }

    /*
    public void sendMessage(String message) {
        if (!isSendingMessage) {
            isSendingMessage = true;
            sendMessageProgressBar.setVisibility(View.VISIBLE);
            SendConsoleMessageTask sendConsoleMessageTask = new SendConsoleMessageTask(this, this, message);
            sendConsoleMessageTask.execute("");
        }
    }
    */

    public void executeLoadMessageTask() {
        LoadConsoleMessageTask loadConsoleMessageTask = new LoadConsoleMessageTask(this, this, currentPageNo);
        loadConsoleMessageTask.execute("");
    }

    @Override
    public void reloadMessage() {
        currentPageNo = 1;
        this.executeLoadMessageTask();
    }

    @Override
    public void onMessageSend(Integer result) {
        isSendingMessage = false;
        /*
        sendMessageProgressBar.setVisibility(View.GONE);
        if (result == 1) {
            messageEditText.setText("");
            messageListView.requestFocus();
            this.reloadMessage();
        }
        */
    }

    @Override
    public void loadMoreMessage() {
        if (loadMoreArea != null) {
            loadMoreArea.setVisibility(View.VISIBLE);
        }
        currentPageNo++;
        this.executeLoadMessageTask();
    }

    @Override
    public void onMessageLoadFailed() {

    }

    /*
    @Override
    public void onClick(View view) {
        super.onClick(view);
        //VeamUtil.log("debug","ProfileActivity::onClick "+view.getId()) ;
        if (view.getId() == VIEWID_MESSAGE_SEND_TEXT) {
            String message = this.messageEditText.getText().toString();
            if (!VeamUtil.isEmpty(message)) {
                this.sendMessage(message);
            }
        }
    }
    */
}
