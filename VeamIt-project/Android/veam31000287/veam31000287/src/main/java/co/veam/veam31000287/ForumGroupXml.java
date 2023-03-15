package co.veam.veam31000287;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import android.content.Context;
import android.util.Log;

public class ForumGroupXml extends DefaultHandler {

	public final static String CACHE_URL_STRING = "veamcache://veam.co/ForumGroupXml" ;

	ArrayList<ForumGroupObject> forumGroups ;
	
	HashMap<String,String> entryMap ;
	
	public ForumGroupXml(){
		super() ;
		forumGroups = new ArrayList<ForumGroupObject>();
	}
	
	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("TweetXml startDocument");
		forumGroups = new ArrayList<ForumGroupObject>();
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
		
		if(tag.equals("forum_group")){
	        String id = attributes.getValue("id") ;
	        String forumGroupCategoryId = attributes.getValue("c") ;
	        String forumId = attributes.getValue("f") ;
			String forumName = attributes.getValue("n") ;
			String numberOfMembers = attributes.getValue("m") ;

			
			ForumGroupObject forumGroupObject = new ForumGroupObject(id,forumGroupCategoryId,forumId,forumName,numberOfMembers) ;
			forumGroups.add(forumGroupObject) ;
		} else if(tag.equals("forum_group_entry")){
			String value = attributes.getValue("value") ;
			String []entryIds = value.split(",") ;
			entryMap = new HashMap<String,String>() ;
			int count = entryIds.length ;
			for(int index = 0 ; index < count ; index++){
				//VeamUtil.log("debug","group entry:"+entryIds[index]) ;
				entryMap.put(entryIds[index], "y") ;
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
	
	public int getNumberOfForumGroups()
	{
		return forumGroups.size() ;
	}
	
	public ArrayList<ForumGroupObject> getForumGroups(){
		return forumGroups ;
	}
	
	public ForumGroupObject getForumGroupAt(int index){
		ForumGroupObject retForumGroup = null ;
		if(index < forumGroups.size()){
			retForumGroup = forumGroups.get(index) ;
		}
		return retForumGroup ;
	}
	
	public HashMap<String,String> getEntryMap(){
		return entryMap ;
	}
	
	public static ForumGroupXml getCachedInstance(Context context){
    	ForumGroupXml forumGroupXml = new ForumGroupXml() ; ;

    	FileInputStream fileInputStream = VeamUtil.getCachedFileInputStream(context, CACHE_URL_STRING, false) ;
    	
    	if(fileInputStream != null){
	    	//VeamUtil.log("debug","url="+urlString) ;
	    	try {
	    		SAXParserFactory spfactory = SAXParserFactory.newInstance();
	    	    SAXParser parser = spfactory.newSAXParser();
	    	    parser.parse(fileInputStream,forumGroupXml) ;
			} catch (Exception e) {
				e.printStackTrace();
				//VeamUtil.log("debug","failed to load cached groups") ;
			}
    	}
    	
		return forumGroupXml ;

	}
}    

