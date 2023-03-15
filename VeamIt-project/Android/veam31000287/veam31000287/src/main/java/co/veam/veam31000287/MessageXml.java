package co.veam.veam31000287;

import java.util.ArrayList;
import java.util.HashMap;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

public class MessageXml extends DefaultHandler {
	public static final String MESSAGES_KEY_IS_BLOCKED = "is_blocked" ;
	

	private ArrayList<MessageObject> messages ;
	private ArrayList<MessageUserObject> messageUsers ;
	private boolean shouldReverseOrder = false ;
	private String previousDateString ;
	private int latestAddCount ;
	private boolean lastPageLoaded = false ;
	
	boolean isBlocked ;

	
	public boolean isshouldReverseOrder() {
		return shouldReverseOrder;
	}

	public void setShouldReverseOrder(boolean shouldReverseOrder) {
		this.shouldReverseOrder = shouldReverseOrder;
	}

	public MessageXml(){
		super() ;
	}
	
	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("TweetXml startDocument");
		messages = new ArrayList<MessageObject>();
		messageUsers = new ArrayList<MessageUserObject>();
		latestAddCount = 0 ;
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
		
		
		
	    if(tag.equals("message")){
			String id = attributes.getValue("id") ;
			String fromUserId = attributes.getValue("fid") ;
			String toUserId = attributes.getValue("tid") ;
			String createdAt = attributes.getValue("c") ;
			String text = attributes.getValue("t") ;
			String readFlag = attributes.getValue("r") ;
            MessageObject messageObject = new MessageObject(id,fromUserId,toUserId,createdAt, text,readFlag,MessageObject.MESSAGE_KIND_MESSAGE) ;
	        
	        if(shouldReverseOrder){
	        	/*
	            String dateString = VeamUtil.getMessageDateString(createdAt) ;
	            if(!dateString.equals(previousDateString)){
	                if(previousDateString != null){
	                    MessageObject dateMessageObject = new MessageObject(previousDateString,"0", "0",createdAt, previousDateString, "", MessageObject.MESSAGE_KIND_DATE) ;
	                    messages.add(0,dateMessageObject) ;
	                    latestAddCount++ ;
	                }
	                
	                previousDateString = dateString ;
	            }
	            */
	            messages.add(0,messageObject) ;
	        } else {
	        	messages.add(messageObject) ;
	        }

	        latestAddCount++ ;
	        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
	    } else if(tag.equals("user")){
	        String socialUserId = attributes.getValue("id") ;
	        String name = attributes.getValue("n") ;
	        String imageUrl = attributes.getValue("u") ;
	        
            MessageUserObject messageUserObject = new MessageUserObject(socialUserId,name,imageUrl) ;
	        messageUsers.add(messageUserObject) ;
	        //NSLog(@"add picture : %@ %@",[picture pictureId],[picture pictureUrl]) ;
	        
	    } else if(tag.equals("page")){
	        String isLastPage = attributes.getValue("is_last_page") ;
	        if(VeamUtil.parseInt(isLastPage) == 1){
	            lastPageLoaded = true ;
	        } else {
	            lastPageLoaded = false ;
	        }
		} else if(tag.equals(MESSAGES_KEY_IS_BLOCKED)){
			String isBlockedString = attributes.getValue("value") ;
		    if(!VeamUtil.isEmpty(isBlockedString) && isBlockedString.equals("1")){
		    	this.isBlocked = true ;
		    }
	    } else {
	    	/*
	        String value = [attributeDict objectForKey:@"value"];
	        if(value != null){
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
	
	public int getNumberOfMessages()
	{
		return messages.size() ;
	}
	
	public ArrayList<MessageObject> getMessages(){
		return messages ;
	}
	
	public ArrayList<MessageUserObject> getMessageUsers(){
		return messageUsers ;
	}
	
	public MessageObject getMessageAt(int index){
		MessageObject retMessage = null ;
		if(index < messages.size()){
			retMessage = messages.get(index) ;
		}
		return retMessage ;
	}

	public boolean isBlocked() {
		return isBlocked;
	}

	public void setBlocked(boolean isBlocked) {
		this.isBlocked = isBlocked;
	}

}    

