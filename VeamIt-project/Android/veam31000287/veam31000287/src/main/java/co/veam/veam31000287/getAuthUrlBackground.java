package co.veam.veam31000287;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.auth.RequestToken;
import android.os.AsyncTask;

public class getAuthUrlBackground extends AsyncTask<Void, Void, RequestToken> {
	public interface getAuthUrlCallback{
		void returnAuthUrl(RequestToken authUrl);
	}
	
	private getAuthUrlCallback callback = null;
	private Twitter twitter = null;
	
	public getAuthUrlBackground(){
	}

	public getAuthUrlBackground(getAuthUrlCallback _callback){
		callback = _callback;
	}
	
	public getAuthUrlBackground(getAuthUrlCallback _callback ,Twitter _twitter){
		callback = _callback;
		twitter = _twitter;
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
	
	@Override
	protected RequestToken doInBackground(Void... params) {
		try {
			//Twitterの認証を行うためのURLを取得して返す
			return twitter.getOAuthRequestToken();
		} catch (TwitterException e) {
			e.printStackTrace();
		}
		return null;
	}
	@Override
	protected void onPostExecute(RequestToken result) {
		super.onPostExecute(result);
		callback.returnAuthUrl(result);
	}
}

