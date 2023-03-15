package co.veam.veam31000287;

import java.util.ArrayList;
import java.util.HashMap;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

public class ProfileDataXml extends DefaultHandler {

	String socialUserId ;
	String name ;
	String description ;
	String imageUrl ;
	int numberOfPosts ;
	int numberOfFollowers ;
	int numberOfFollowings ;
	String latitude ;
	String longitude ;
	String unreadMessageCount = "" ;
	
	ArrayList<UserNotificationObject> userNotifications ;
	ArrayList<MessageUserObject> messageUsers ;

	boolean isFollowing = false ;
	
	

	public String getUnreadMessageCount() {
		return unreadMessageCount;
	}

	public void setUnreadMessageCount(String unreadMessageCount) {
		this.unreadMessageCount = unreadMessageCount;
	}

	public ArrayList<UserNotificationObject> getUserNotifications() {
		return userNotifications;
	}

	public void setUserNotifications(
			ArrayList<UserNotificationObject> userNotifications) {
		this.userNotifications = userNotifications;
	}

	public ArrayList<MessageUserObject> getMessageUsers() {
		return messageUsers;
	}

	public void setMessageUsers(ArrayList<MessageUserObject> messageUsers) {
		this.messageUsers = messageUsers;
	}

	public ProfileDataXml(){
		super() ;
	}
	
	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("ProfileDataXml startDocument");
		userNotifications = new ArrayList<UserNotificationObject>() ;
		messageUsers = new ArrayList<MessageUserObject>() ;
		unreadMessageCount = "" ;
	}
	
	/**
	* 要素の開始タグ読み込み時
	*/
	public void startElement(String uri,String localName,String qName,Attributes attributes) {
		//System.out.println("startElement:" + qName + " localName=" + localName) ;
		String tag = "" ;
		if(localName.equals("")){
			tag = qName ;
		} else {
			tag = localName ;
		}
		
	    // <?xml version="1.0" encoding="UTF-8"?><list>
	    // <youtube id="496" like="0" />
	    // <comment id="1" user_id="6" user_name="veam03" text="hoge" />
	    // <check value="OK" /></list>
		
		
	    if(tag.equals("profile")){
	        socialUserId = attributes.getValue("id") ;
	        name = attributes.getValue("n") ;
	        description = attributes.getValue("d") ;
	        imageUrl = attributes.getValue("u") ;
	        String postsString = attributes.getValue("p") ;
	        numberOfPosts = VeamUtil.parseInt(postsString) ;
	        String followersString = attributes.getValue("fers") ;
	        numberOfFollowers = VeamUtil.parseInt(followersString) ;
	        String followingsString = attributes.getValue("fing") ;
	        numberOfFollowings = VeamUtil.parseInt(followingsString) ;
	        latitude = attributes.getValue("lat") ;
	        longitude = attributes.getValue("lng") ;

	        //NSLog(@"number of likes : %d",numberOfLikes) ;
	    } else if(tag.equals("following")){
	        String isFollowingString = attributes.getValue("value") ;
	        if(isFollowingString.equals("1")){
	            isFollowing = true ;
	        } else {
	            isFollowing = false ;
	        }
	    } else if(tag.equals("notification")){
	        String id = attributes.getValue("id") ;
	        String fromUserId = attributes.getValue("fid") ;
	        String createdAt = attributes.getValue("c") ;
	        String message = attributes.getValue("m") ;
	        String text = attributes.getValue("t") ;
	        String readFlag = attributes.getValue("r") ;
	        String kind = attributes.getValue("k") ;
	        String pictureId = attributes.getValue("pid") ;
	        UserNotificationObject userNotificationObject = new UserNotificationObject(id, fromUserId,createdAt, message, text, kind,readFlag, pictureId) ;
	        userNotifications.add(userNotificationObject) ;
	        
	        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
	    } else if(tag.equals("user")){
	        String socialUserId = attributes.getValue("id") ;
	        String name = attributes.getValue("n") ;
	        String imageUrl = attributes.getValue("u") ;
	        
            MessageUserObject messageUserObject = new MessageUserObject(socialUserId,name,imageUrl) ;
	        messageUsers.add(messageUserObject) ;

	    } else if(tag.equals("unread_message_count")){
	        unreadMessageCount = attributes.getValue("value") ;
	    	
	    } else {
	    	/*
	        String value = attributes.getValue("value") ;
	        if(!VeamUtil.isEmpty(value)){
	            //NSLog(@"elementName=%@ value=%@",elementName,value) ;
	            [dictionary setObject:value forKey:elementName] ;
	        }
	        */
	    }
	}
	
	/**
	* テキストデータ読み込み時
	*/
	public void characters(char[] ch,int offset,int length) {
		//System.out.println("テキストデータ：" + new String(ch, offset, length));
	}
	
	/**
	* 要素の終了タグ読み込み時
	*/
	public void endElement(String uri,String localName,String qName) {
		//System.out.println("要素終了:" + qName);
	}
	
	/**
	* ドキュメント終了時
	*/
	public void endDocument() {
		//System.out.println("endDocument num="+tweets.size());
	}

	public String getSocialUserId() {
		return socialUserId;
	}

	public void setSocialUserId(String socialUserId) {
		this.socialUserId = socialUserId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public int getNumberOfPosts() {
		return numberOfPosts;
	}

	public void setNumberOfPosts(int numberOfPosts) {
		this.numberOfPosts = numberOfPosts;
	}

	public int getNumberOfFollowers() {
		return numberOfFollowers;
	}

	public void setNumberOfFollowers(int numberOfFollowers) {
		this.numberOfFollowers = numberOfFollowers;
	}

	public int getNumberOfFollowings() {
		return numberOfFollowings;
	}

	public void setNumberOfFollowings(int numberOfFollowings) {
		this.numberOfFollowings = numberOfFollowings;
	}

	public boolean isFollowing() {
		return isFollowing;
	}

	public void setFollowing(boolean isFollowing) {
		this.isFollowing = isFollowing;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	
	
	
	
	
}    

