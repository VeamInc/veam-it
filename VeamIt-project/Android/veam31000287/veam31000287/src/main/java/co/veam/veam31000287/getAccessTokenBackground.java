package co.veam.veam31000287;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import android.os.AsyncTask;

public class getAccessTokenBackground extends AsyncTask<Void, Void, AccessToken> {
	public interface getAuthUrlCallback{
		void returnAuthUrl(AccessToken accessToken);
	}
	
	private getAuthUrlCallback callback = null;
	private Twitter twitter = null;
	private String oAuthVerifier = null;
	private String pin = null;
	private RequestToken requestToken ;
	
	public getAccessTokenBackground(){
		
	}
	public getAccessTokenBackground(getAuthUrlCallback _callback){
		callback = _callback;
	}
	public getAccessTokenBackground(getAuthUrlCallback _callback,Twitter _twitter){
		callback = _callback;
		twitter = _twitter;
	}
	public getAccessTokenBackground(getAuthUrlCallback _callback,Twitter _twitter,RequestToken _requestToken,String _pin){
		callback = _callback;
		twitter = _twitter;
		pin = _pin;
		requestToken = _requestToken ;
	}

	public getAuthUrlCallback getCallback() {
		return callback;
	}
	public void setCallback(getAuthUrlCallback callback) {
		this.callback = callback;
	}
	public Twitter getTwitter() {
		return twitter;
	}
	public void setTwitter(Twitter twitter) {
		this.twitter = twitter;
	}
	public String getoAuthVerifier() {
		return oAuthVerifier;
	}
	public void setoAuthVerifier(String oAuthVerifier) {
		this.oAuthVerifier = oAuthVerifier;
	}
	
	@Override
	protected AccessToken doInBackground(Void... params) {
		try {
			//return twitter.getOAuthAccessToken(oAuthVerifier);
			return twitter.getOAuthAccessToken(requestToken, pin);
		} catch (TwitterException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	protected void onPostExecute(AccessToken result) {
		super.onPostExecute(result);
		callback.returnAuthUrl(result);
	}
}
