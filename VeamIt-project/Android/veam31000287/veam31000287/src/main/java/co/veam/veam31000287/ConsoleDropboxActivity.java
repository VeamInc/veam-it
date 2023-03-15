package co.veam.veam31000287;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.RelativeLayout;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;
import com.dropbox.client2.session.AccessTokenPair;
import com.dropbox.client2.session.AppKeyPair;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by veam on 12/1/16.
 */
public class ConsoleDropboxActivity extends ConsoleActivity {

    ConsoleDropboxAdapter adapter ;

    final static private String APP_KEY = "__DROPBOX_KEY__";
    final static private String APP_SECRET = "__DROPBOX_SECRET__";

    private static final String ACCOUNT_PREFS_NAME = "prefs";
    private static final String ACCESS_KEY_NAME = "ACCESS_KEY";
    private static final String ACCESS_SECRET_NAME = "ACCESS_SECRET";

    private static final boolean USE_OAUTH1 = false;

    private DropboxAPI<AndroidAuthSession> mDBApi;

    private String dropboxPath ;
    private String acceptableExtensions ;

    private boolean listLoaded = false ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE) ;
        setContentView(R.layout.activity_console);

        Intent intent = this.getIntent() ;
        dropboxPath = intent.getStringExtra("DROPBOX_PATH") ;
        acceptableExtensions = intent.getStringExtra("DROPBOX_ACCEPTABLE_EXTENSIONS") ;
        if(VeamUtil.isEmpty(dropboxPath)){
            dropboxPath = "/" ;
        }

        // And later in some initialization function:
        //AppKeyPair appKeys = new AppKeyPair(APP_KEY, APP_SECRET);
        //AndroidAuthSession session = new AndroidAuthSession(appKeys);
        AndroidAuthSession session = buildSession() ;
        mDBApi = new DropboxAPI<AndroidAuthSession>(session);
        if(!mDBApi.getSession().isLinked()) {
            mDBApi.getSession().startOAuth2Authentication(ConsoleDropboxActivity.this);
        }

        this.showFullscreenProgress() ;
        /*
        ConsoleDropboxListTask consoleDropboxListTask = new ConsoleDropboxListTask(this,mDBApi,dropboxPath) ;
        consoleDropboxListTask.execute("") ;
        */

        rootLayout = (RelativeLayout)this.findViewById(R.id.rootLayout) ;
        this.setupViews();

        adapter = new ConsoleDropboxAdapter(this) ;
        this.addMainList(adapter);
    }

    protected void onResume() {
        super.onResume();

        if (mDBApi.getSession().authenticationSuccessful()) {
            VeamUtil.log("debug","authenticationSuccessful") ;
            try {
                // Required to complete auth, sets the access token on the session
                mDBApi.getSession().finishAuthentication();

                // Store it locally in our app for later use
                storeAuth(mDBApi.getSession());

                String accessToken = mDBApi.getSession().getOAuth2AccessToken();
            } catch (IllegalStateException e) {
                Log.i("DbAuthLog", "Error authenticating", e);
            }

        }
        if(!listLoaded){
            VeamUtil.log("debug","reload list") ;
            ConsoleDropboxListTask consoleDropboxListTask = new ConsoleDropboxListTask(this,mDBApi,dropboxPath) ;
            consoleDropboxListTask.execute("") ;
        }
    }

    @Override
    public void onClick(View view) {
        super.onClick(view);
        VeamUtil.log("debug", "ConsoleDropboxActivity::onClick") ;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        VeamUtil.log("debug", "ConsoleDropboxActivity::onItemClick " + position) ;
    }

    @Override
    public void onAdapterTitleClick(ConsoleAdapterElement element){
        VeamUtil.log("debug", "ConsoleDropboxActivity::onAdapterTitleClick") ;
        if(element != null){
            VeamUtil.log("debug", "element != null") ;
            if(element.getElementId() == ConsoleDropboxAdapter.ELEMENTID_DIRECTORY){
                VeamUtil.log("debug", "directory : " + element.getTitle()) ;
                this.launchDropboxActivity(element.getTitle(),dropboxPath + element.getTitle() + "/",acceptableExtensions);
            } else if(element.getElementId() == ConsoleDropboxAdapter.ELEMENTID_FILE){
                VeamUtil.log("debug", "file") ;
                final String fileName = element.getTitle() ;

                if(this.isAcceptableFile(fileName)){
                    //NSLog(@"select file") ;
                    AlertDialog.Builder builder = new AlertDialog.Builder(this);
                    builder.setTitle(fileName);
                    builder.setMessage("Select this file?") ;
                    builder.setPositiveButton("OK",
                            new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    showFullscreenProgress();
                                    ConsoleDropboxShareTask consoleDropboxShareTask = new ConsoleDropboxShareTask(ConsoleDropboxActivity.this,mDBApi,dropboxPath + fileName) ;
                                    consoleDropboxShareTask.execute("") ;
                                }
                            });

                    builder.setNegativeButton(getString(R.string.cancel), null);
                    AlertDialog dialog = builder.create();
                    dialog.show();

                } else {
                    VeamUtil.showMessage(this,String.format("Please select the file with following extensions %s",acceptableExtensions)) ;
                }
            }
        }
    }


    /**
     * Shows keeping the access keys returned from Trusted Authenticator in a local
     * store, rather than storing user name & password, and re-authenticating each
     * time (which is not to be done, ever).
     */
    private void loadAuth(AndroidAuthSession session) {
        SharedPreferences prefs = getSharedPreferences(ACCOUNT_PREFS_NAME, 0);
        String key = VeamUtil.getPreferenceString(this,ACCESS_KEY_NAME);
        String secret = VeamUtil.getPreferenceString(this, ACCESS_SECRET_NAME);
        if (key == null || secret == null || key.length() == 0 || secret.length() == 0) return;

        if (key.equals("oauth2:")) {
            // If the key is set to "oauth2:", then we can assume the token is for OAuth 2.
            session.setOAuth2AccessToken(secret);
            /*
        } else {
            // Still support using old OAuth 1 tokens.
            session.setAccessTokenPair(new AccessTokenPair(key, secret));
            */
        }
    }

    /**
     * Shows keeping the access keys returned from Trusted Authenticator in a local
     * store, rather than storing user name & password, and re-authenticating each
     * time (which is not to be done, ever).
     */
    private void storeAuth(AndroidAuthSession session) {
        // Store the OAuth 2 access token, if there is one.
        String oauth2AccessToken = session.getOAuth2AccessToken();
        if (oauth2AccessToken != null) {
            VeamUtil.setPreferenceString(this, ACCESS_KEY_NAME, "oauth2:");
            VeamUtil.setPreferenceString(this,ACCESS_SECRET_NAME, oauth2AccessToken);
        }
        return;
        /*
        // Store the OAuth 1 access token, if there is one.  This is only necessary if
        // you're still using OAuth 1.
        AccessTokenPair oauth1AccessToken = session.getAccessTokenPair();
        if (oauth1AccessToken != null) {
            SharedPreferences prefs = getSharedPreferences(ACCOUNT_PREFS_NAME, 0);
            SharedPreferences.Editor edit = prefs.edit();
            edit.putString(ACCESS_KEY_NAME, oauth1AccessToken.key);
            edit.putString(ACCESS_SECRET_NAME, oauth1AccessToken.secret);
            edit.commit();
            return;
        }
        */
    }

    private void clearKeys() {
        VeamUtil.setPreferenceString(this, ACCESS_KEY_NAME, "");
        VeamUtil.setPreferenceString(this, ACCESS_SECRET_NAME, "");
    }

    private AndroidAuthSession buildSession() {
        AppKeyPair appKeyPair = new AppKeyPair(APP_KEY, APP_SECRET);

        AndroidAuthSession session = new AndroidAuthSession(appKeyPair);
        loadAuth(session);
        return session;
    }

    public void onShareDropboxFile(String result) {
        if(!VeamUtil.isEmpty(result)){
            VeamUtil.log("debug", "shareUrl : " + result);
            this.finishWithShareUrl(result);
        } else {
            VeamUtil.log("debug", "shareUrl failed");
            VeamUtil.showMessage(this, "Failed to load URL");
        }
    }

    public void onLoadList(DropboxAPI.Entry result){
        VeamUtil.log("debug","list loaded") ;

        this.hideFullscreenProgress();

        if(result == null){
            //VeamUtil.showMessage(this,"Failed to load data") ;
            return ;
        }

        listLoaded = true ;

        if (!result.isDir || result.contents == null) {
            // It's not a directory, or there's nothing in it
            VeamUtil.showMessage(this,"File or empty directory") ;
            return ;
        }

        // Make a list of everything in it that we can get a thumbnail for
        ArrayList<DropboxAPI.Entry> thumbs = new ArrayList<DropboxAPI.Entry>();
        for (DropboxAPI.Entry entry: result.contents) {
            VeamUtil.log("debug","name="+entry.fileName() + " path=" + entry.path) ;
        }

        if(adapter != null){
            adapter.setEntry(result);
            adapter.notifyDataSetChanged();
        }
    }

    public boolean isAcceptableFile(String fileName){
        boolean retValue = false ;
        int periodIndex = fileName.lastIndexOf(".") ;
        int length = fileName.length() ;
        if((periodIndex >= 0) && (periodIndex < length-1)){
            String extension = fileName.substring(periodIndex+1) ;
            extension = extension.toLowerCase() ;
            VeamUtil.log("debug","extension="+extension) ;
            String[] extensionStrings = acceptableExtensions.split(",") ;
            int count = extensionStrings.length ;
            for(int index = 0 ; index < count ; index++){
                String workExtension = extensionStrings[index] ;
                if(extension.equals(workExtension)){
                    retValue = true ;
                    break ;
                }
            }
        }

        return retValue ;
    }

    public void finishWithShareUrl(String shareUrl){
        Intent retData = new Intent();
        Bundle retBundle = new Bundle();
        retBundle.putString("DROPBOX_SHARE_URL", shareUrl);
        retData.putExtras(retBundle);
        setResult(RESULT_OK, retData);
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == REQUEST_CODE_DROPBOX_ACTIVITY){
            if(resultCode == RESULT_OK) {
                if(data != null) {
                    Bundle bundle = data.getExtras();
                    String shareUrl = bundle.getString("DROPBOX_SHARE_URL");
                    if (!VeamUtil.isEmpty(shareUrl)) {
                        this.finishWithShareUrl(shareUrl);
                    }
                }
            }
        }
    }

}
