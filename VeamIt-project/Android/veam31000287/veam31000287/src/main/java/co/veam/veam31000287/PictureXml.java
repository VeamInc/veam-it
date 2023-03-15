package co.veam.veam31000287;

import java.util.ArrayList;
import java.util.HashMap;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

public class PictureXml extends DefaultHandler {
	
	ArrayList<PictureObject> pictures ;
	HashMap<String,PictureObject> picturesMap ;
	HashMap<String,String> likeMap ;
	boolean forumUserPermission = false ;
	private int numberOfPicturesBetweenAds ;
	
	public PictureXml(int numberOfPicturesBetweenAds){
		super() ;
		this.numberOfPicturesBetweenAds = numberOfPicturesBetweenAds ;
	}

	public int getNumberOfPicturesBetweenAds() {
		return numberOfPicturesBetweenAds;
	}

	public void setNumberOfPicturesBetweenAds(int numberOfPicturesBetweenAds) {
		this.numberOfPicturesBetweenAds = numberOfPicturesBetweenAds;
	}

	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("TweetXml startDocument");
		pictures = new ArrayList<PictureObject>();
		picturesMap = new HashMap<String,PictureObject>();
	}
	
	/**
	* 要素の開始タグ読み込み時
	*/
	public void startElement(String uri,String localName,String qName,Attributes attributes) {
		VeamUtil.log("debug","startElement:" + qName + " localName=" + localName) ;
		String tag = "" ;
		if(localName.equals("")){
			tag = qName ;
		} else {
			tag = localName ;
		}
		
		
		if(tag.equals("picture")){
			
			/*
			<picture 
				id="65" 
				url="__URL__" user_id="20" 
				user_name="__USER_NAME__" 
				user_icon_url="__URL__" 
				is_like="0" 
				likes="3" 
				created_at="1379580614" 
				/>			
			*/
			String id = attributes.getValue("id") ;
			String imageUrl = attributes.getValue("url") ;
	        String forumId = attributes.getValue("forum_id") ;
	        String forumName = attributes.getValue("forum_name") ;
			String userId = attributes.getValue("user_id") ;
			String userName = attributes.getValue("user_name") ;
			String userIconUrl = attributes.getValue("user_icon_url") ;
			String isLike = attributes.getValue("is_like") ;
			String likes = attributes.getValue("likes") ;
			String createdAt = attributes.getValue("created_at") ;
			
			PictureObject pictureObject = new PictureObject( id, imageUrl, userId,userName, userIconUrl, isLike, likes, createdAt,forumId,forumName) ;
			pictures.add(pictureObject) ;
			picturesMap.put(id, pictureObject) ;
			if(numberOfPicturesBetweenAds > 0){
				int pictureCount = pictures.size() ;
				boolean addAd = (((pictureCount - numberOfPicturesBetweenAds) % (numberOfPicturesBetweenAds + 1)) == 0) ;
				if(addAd){
					PictureObject adPicture = new PictureObject("AD","","","","","","","","","") ;
					pictures.add(adPicture) ;
				}
			}
		} else if(tag.equals("comment")){
			String id = attributes.getValue("id") ;
			String pictureId = attributes.getValue("picture_id") ;
			String userId = attributes.getValue("user_id") ;
			String userName = attributes.getValue("user_name") ;
			String text = attributes.getValue("text") ;
			
			PictureCommentObject pictureCommentObject = new PictureCommentObject( id, pictureId, userId,userName, text) ;
			PictureObject pictureObject = picturesMap.get(pictureId) ;
			if(pictureObject != null){
				pictureObject.addComment(pictureCommentObject) ;
			}
		} else if(tag.equals("picture_like")){
			//<picture_like value="43,33,47,53,54,50,51,56,65" />
			String value = attributes.getValue("value") ;
			String []likeIds = value.split(",") ;
			likeMap = new HashMap<String,String>() ;
			int count = likeIds.length ;
			for(int index = 0 ; index < count ; index++){
				//VeamUtil.log("debug","like:"+likeIds[index]) ;
				likeMap.put(likeIds[index], "y") ;
			}
		} else if(tag.equals("forum_user_permission")){
			//<forum_user_permission value="1" />
			String value = attributes.getValue("value") ;
			if(!VeamUtil.isEmpty(value) && value.equals("1")){
				forumUserPermission = true ;
			}
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
	
	public int getNumberOfPictures()
	{
		return pictures.size() ;
	}
	
	public ArrayList<PictureObject> getPictures(){
		return pictures ;
	}
	
	public PictureObject getPictureAt(int index){
		PictureObject retPicture = null ;
		if(index < pictures.size()){
			retPicture = pictures.get(index) ;
		}
		return retPicture ;
	}
	
	public HashMap<String,String> getLikeMap(){
		return likeMap ;
	}

	public boolean getForumUserPermission(){
		return forumUserPermission ;
	}
}    

