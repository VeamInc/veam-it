package co.veam.veam31000287;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import java.util.ArrayList;

public class AudioDataXml extends DefaultHandler {

	int numberOfLikes ;
	String audioId ;
	boolean isLike = false ;
	ArrayList<AudioCommentObject> comments ;

	public AudioDataXml(){
		super() ;
	}
	
	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("TweetXml startDocument");
		comments = new ArrayList<AudioCommentObject>();
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
		
		/*
		 * <?xml version="1.0" encoding="UTF-8"?><list>
		 * <audio id="1" like="1" />
		 * <comment id="1" user_id="24" user_name="__USER_NAME__" text="Message comment" />
		 * <check value="OK" /></list>
		 * */
		if(tag.equals("audio")){
	    	audioId = attributes.getValue("id") ;
	        String likeString = attributes.getValue("like") ;
	        numberOfLikes = VeamUtil.parseInt(likeString) ;
	        //NSLog(@"number of likes : %d",numberOfLikes) ;
	    } else if(tag.equals("comment")){
	        String id = attributes.getValue("id") ;
	        String socialUserId = attributes.getValue("user_id") ;
	        String userName = attributes.getValue("user_name") ;
	        String text = attributes.getValue("text") ;
	        AudioCommentObject comment = new AudioCommentObject(id,audioId,socialUserId,userName,text) ;
	        comments.add(comment) ;
	    } else if(tag.equals("audio_like")){
	        String value = attributes.getValue("value");
	        //NSLog(@"value=%@",value) ;
	        if(value != null){
	        	String[] likes = value.split(",") ;
	            Integer count = likes.length ;
	            for(int index = 0 ; index < count ; index++){
	                String likeId = likes[index] ;
	                if(!VeamUtil.isEmpty(likeId)){
	                    if(likeId.equals(audioId)){
	                        isLike = true ;
	                    }
	                }
	            }
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
	
	public int getNumberOfComments()
	{
		return comments.size() ;
	}
	
	public ArrayList<AudioCommentObject> getComments(){
		return comments ;
	}
	
	public AudioCommentObject getCommentAt(int index){
		AudioCommentObject retComment = null ;
		if(index < comments.size()){
			retComment = comments.get(index) ;
		}
		return retComment ;
	}
}    

