package co.veam.veam31000287;

import java.util.ArrayList;
import java.util.HashMap;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

public class FollowXml extends DefaultHandler {
	
	ArrayList<FollowObject> follows ;
	
	public FollowXml(){
		super() ;
	}
	
	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("TweetXml startDocument");
		follows = new ArrayList<FollowObject>();
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
		
		if(tag.equals("user")){
			String imageUrl = attributes.getValue("u") ;
			String socialUserId = attributes.getValue("id") ;
			String socialUserName = attributes.getValue("n") ;
			
			FollowObject followObject = new FollowObject("0",imageUrl,socialUserId,socialUserName) ;
			follows.add(followObject) ;
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
	
	public int getNumberOfFollows()
	{
		return follows.size() ;
	}
	
	public ArrayList<FollowObject> getFollows(){
		return follows ;
	}
	
	public FollowObject getFollowAt(int index){
		FollowObject retFollow = null ;
		if(index < follows.size()){
			retFollow = follows.get(index) ;
		}
		return retFollow ;
	}
	
}    

