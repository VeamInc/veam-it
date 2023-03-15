package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class LoadFollowTask extends AsyncTask<String, Integer, FollowXml> {
	
	public static final int FOLLOW_KIND_FOLLOWINGS			= 0x0001 ;
	public static final int FOLLOW_KIND_FOLLOWERS			= 0x0002 ;
	public static final int FOLLOW_KIND_PICTURE_LIKERS		= 0x0003 ;
	public static final int FOLLOW_KIND_FIND_USER			= 0x0004 ;
	public static final int FOLLOW_KIND_FORUM_GROUP_MEMBERS	= 0x0005 ;
	
	final String TAG = "LoadFollowTask";
	private FollowAdapter.FollowAdapterActivityInterface profileActivity ;
	private Context context ;
	private int kind ;
	private String socialUserId ;
	private String pictureId ;
	private String forumGroupId ;
	private String userName ;
	private int pageNo ;
	

	// コンストラクタ  
    public LoadFollowTask(FollowAdapter.FollowAdapterActivityInterface activity,Context context,int kind,int pageNo,String socialUserId,String pictureId,String userName,String forumGroupId) {
    	profileActivity = activity ;
    	this.pageNo = pageNo ;
    	this.context = context ;
    	this.kind = kind ;
    	this.socialUserId = socialUserId ;
    	this.pictureId = pictureId ;
    	this.userName = userName ;
    	this.forumGroupId = forumGroupId ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected FollowXml doInBackground(String... urls) {
    	FollowXml followXml = null ;

        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
    	/*
    	String socialUserId = VeamUtil.getPreferenceString(veamActivity, VeamUtil.SOCIAL_USER_ID) ;
    	if(socialUserId == null){
    		socialUserId = "" ;
    	}
    	*/
    	String urlString = null ;
    	if(kind == FOLLOW_KIND_PICTURE_LIKERS){
			String signature = VeamUtil.sha1(String.format("VEAM_%d_%s",kind,socialUserId)) ;
			urlString = String.format("%s&k=%d&p=%d&sid=%s&s=%s&pid=%s",VeamUtil.getApiUrlString(context, "socialuser/followlist"),kind,pageNo,socialUserId,signature,pictureId) ;
		} else if(kind == FOLLOW_KIND_FIND_USER){
    		String signature = VeamUtil.sha1(String.format("VEAM_%s",userName)) ;
    		String encodedUserName = "" ;
    		try {
    			encodedUserName = URLEncoder.encode(userName,"utf-8");
    		} catch (UnsupportedEncodingException e1) {
    			e1.printStackTrace();
    		}

    		urlString = String.format("%s&n=%s&p=%d&s=%s",VeamUtil.getApiUrlString(context, "pagedfinduser"),encodedUserName,pageNo,signature) ;
    	} else if(kind == FOLLOW_KIND_FORUM_GROUP_MEMBERS){
    		String signature = VeamUtil.sha1(String.format("VEAM_%s",forumGroupId)) ; 
    		urlString = String.format("%s&p=%d&g=%s&s=%s",VeamUtil.getApiUrlString(context, "pagedforumgroupmember"),pageNo,forumGroupId,signature) ;
    	} else {
    		String signature = VeamUtil.sha1(String.format("VEAM_%d_%s",kind,socialUserId)) ; 
    		urlString = String.format("%s&k=%d&p=%d&sid=%s&s=%s",VeamUtil.getApiUrlString(context, "socialuser/followlist"),kind,pageNo,socialUserId,signature) ;
    	}
		
    	//VeamUtil.log("debug","follow url="+urlString) ;
    	
    	try {
			// HTTP経由でアクセスし、InputStreamを取得する
			URL url = new URL(urlString);
			InputStream is = url.openConnection().getInputStream();
    		
    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
    	    SAXParser parser = spfactory.newSAXParser();
    	    
    		followXml = new FollowXml() ; 
    	    parser.parse(is,followXml) ;
    	    
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("failed to load pictures") ;
		}
    	
		return followXml ;
    }
    
	@Override
	protected void onPostExecute(FollowXml result) {
		//VeamUtil.log(TAG, "onPostExecute - " + result);
		if(result == null){
			profileActivity.onFollowLoadFailed() ;
		} else {
			profileActivity.updateFollow(result,this.pageNo) ;
		}
	}
}
