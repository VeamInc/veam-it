package co.veam.veam31000287;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.User;

public class SocialLoginTask extends AsyncTask<String, Integer, Integer> {
	
	final String TAG = "SocialLoginTask";
	private SocialLoginTaskActivityInterface socialLoginActivity ;
	private Context context ;
	private Twitter twitter ;
	private String twitterId ;
	private String twitterUser ;
	private String facebookId ;
	private String facebookName ;
	
    //private static final int BUFFER_SIZE = 10240;
	
	
	// コンストラクタ  
    public SocialLoginTask(SocialLoginTaskActivityInterface socialLoginActivity,Context context,Twitter twitter,String twitterId,String twitterUser) {
    	this.socialLoginActivity = socialLoginActivity ;
    	this.context = context ;
    	this.twitter = twitter ;
    	this.twitterId = twitterId ;
    	this.twitterUser = twitterUser ;
	}
    
	// コンストラクタ  
    public SocialLoginTask(SocialLoginTaskActivityInterface socialLoginActivity,Context context,String facebookId,String facebookName) {
    	this.socialLoginActivity = socialLoginActivity ;
    	this.context = context ;
    	this.facebookId = facebookId ;
    	this.facebookName = facebookName ;
	}
    
    // バックグラウンドで実行する処理  
    @Override  
    protected Integer doInBackground(String... urls) {
    	Integer resultCode = 0 ;

    	if(twitter != null){
	    	String userName = this.twitterUser ;
	    	String profileImageUrl = "" ;
	        try {
				User user = twitter.showUser(this.twitterUser) ;
				userName = user.getName() ;
				profileImageUrl = user.getProfileImageURLHttps() ;
				//System.out.println("profile image : " + profileImageUrl) ;
				profileImageUrl = profileImageUrl.replace("_normal.", "_bigger.") ;
		    	VeamUtil.setPreferenceString(context, VeamUtil.TWITTER_IMAGE_URL, profileImageUrl) ;
			} catch (TwitterException e2) {
				e2.printStackTrace();
			}
	
	
	        //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
	    	String encodedUserName = "" ;
	    	String encodedProfileImageUrl = "" ;
			try {
				encodedUserName = URLEncoder.encode(userName,"utf-8");
				encodedProfileImageUrl = URLEncoder.encode(profileImageUrl,"utf-8"); 
			} catch (UnsupportedEncodingException e1) {
				e1.printStackTrace();
			}
	    	
	    	String uid = VeamUtil.getUniqueId(context) ;
	    	String signature = VeamUtil.sha1(String.format("VEAM_%s_%s", uid,this.twitterId)) ;
	    	String urlString = String.format("%s&u=%s&t=%s&n=%s&tu=%s&s=%s&i=%s",
	    			VeamUtil.getApiUrlString(context, "socialuser/login"),
	    			uid,this.twitterId,encodedUserName,this.twitterUser,signature,encodedProfileImageUrl) ;
			//VeamUtil.log("debug", "url=" + urlString);
	    	
	    	try {
				// HTTP経由でアクセスし、InputStreamを取得する
				URL url = new URL(urlString);
				InputStream inputStream = url.openConnection().getInputStream();
				
				InputStreamReader streamReader = new InputStreamReader(inputStream);
				BufferedReader bufferedReader = new BufferedReader(streamReader);
				ArrayList<String> result = new ArrayList<String>() ; 
				String line = bufferedReader.readLine() ;
				while(line != null){
					result.add(line) ;
					line = bufferedReader.readLine() ;
				}
	
			    if(result.size() >= 2){
			    	if(result.get(0).equals("OK")){
			    		String socialUserId = result.get(1) ;
			    		VeamUtil.setPreferenceString(context, VeamUtil.SOCIAL_USER_ID, socialUserId) ;
			    		VeamUtil.setPreferenceString(context, VeamUtil.SOCIAL_USER_KIND, VeamUtil.SOCIAL_USER_KIND_TWITTER) ;
			    		//System.out.println("social id="+socialUserId) ;
			    		resultCode = 1 ;
			    		
			    		String registrationId = VeamUtil.getRegistrationId(context) ;
			        	VeamUtil.sendRegistration(context, registrationId, socialUserId) ;
			    	}
			    }
			} catch (Exception e) {
				e.printStackTrace();
				//System.out.println("failed to load tweet") ;
			}
    	} else if((facebookId != null) && !facebookId.equals("")){
            String userName = facebookName ;
            //String profileImageUrl = "" ;
            VeamUtil.setPreferenceString(context, VeamUtil.FACEBOOK_USER_NAME, userName) ;

            //NSLog(@"url=%@",[apiUrlWithParam absoluteString]) ;
            String encodedUserName = "" ;
            try {
                encodedUserName = URLEncoder.encode(userName,"utf-8");
            } catch (UnsupportedEncodingException e1) {
                e1.printStackTrace();
            }

            String uid = VeamUtil.getUniqueId(context) ;
            String signature = VeamUtil.sha1(String.format("VEAM_%s_%s", uid,this.facebookId)) ;
            String urlString = String.format("%s&u=%s&f=%s&t=&n=%s&tu=&s=%s&i=",
                    VeamUtil.getApiUrlString(context, "socialuser/login"),
                    uid,facebookId,encodedUserName,signature) ;
			//VeamUtil.log("debug", "url=" + urlString);

            try {
                // HTTP経由でアクセスし、InputStreamを取得する
                URL url = new URL(urlString);
                InputStream inputStream = url.openConnection().getInputStream();

                InputStreamReader streamReader = new InputStreamReader(inputStream);
                BufferedReader bufferedReader = new BufferedReader(streamReader);
                ArrayList<String> result = new ArrayList<String>() ;
                String line = bufferedReader.readLine() ;
                while(line != null){
                    result.add(line) ;
                    line = bufferedReader.readLine() ;
                }

                if(result.size() >= 2){
                    if(result.get(0).equals("OK")){
                        String socialUserId = result.get(1) ;
                        VeamUtil.setPreferenceString(context, VeamUtil.SOCIAL_USER_ID, socialUserId) ;
                        VeamUtil.setPreferenceString(context, VeamUtil.SOCIAL_USER_KIND, VeamUtil.SOCIAL_USER_KIND_FACEBOOK) ;
                        //System.out.println("social id="+socialUserId) ;
                        resultCode = 1 ;

                        String registrationId = VeamUtil.getRegistrationId(context) ;
                        VeamUtil.sendRegistration(context, registrationId, socialUserId) ;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                //System.out.println("failed to load tweet") ;
            }
    	}

    	
		return resultCode;
    }
    
	@Override
	protected void onPostExecute(Integer resultCode) {
		//VeamUtil.log(TAG, "onPostExecute - " + resultCode);
		socialLoginActivity.onLoginFinished(resultCode) ;
	}

	 public static String sha1(String string)
	 {
		 MessageDigest messageDigest = null ;
		 try {
			 messageDigest = MessageDigest.getInstance("SHA-1");
		 } catch (NoSuchAlgorithmException e) {
			 e.printStackTrace();
		 }
		 byte[] digest = messageDigest.digest(string.getBytes()) ;
		 String sha1String = asHex(digest) ;
		 return sha1String ;
	 }

	    /**
		 * バイト配列を16進数の文字列に変換する。
		 * 
		 * @param bytes バイト配列
		 * @return 16進数の文字列
		 */
		public static String asHex(byte bytes[]) {
			// バイト配列の２倍の長さの文字列バッファを生成。
			StringBuffer strbuf = new StringBuffer(bytes.length * 2);

			// バイト配列の要素数分、処理を繰り返す。
			for (int index = 0; index < bytes.length; index++) {
				// バイト値を自然数に変換。
				int bt = bytes[index] & 0xff;

				// バイト値が0x10以下か判定。
				if (bt < 0x10) {
					// 0x10以下の場合、文字列バッファに0を追加。
					strbuf.append("0");
				}

				// バイト値を16進数の文字列に変換して、文字列バッファに追加。
				strbuf.append(Integer.toHexString(bt));
			}

			/// 16進数の文字列を返す。
			return strbuf.toString();
		}
		
		
		public interface  SocialLoginTaskActivityInterface {
			public void onLoginFinished(Integer resultCode) ;
		}

		


}
