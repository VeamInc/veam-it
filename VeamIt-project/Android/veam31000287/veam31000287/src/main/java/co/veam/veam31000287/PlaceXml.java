package co.veam.veam31000287;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

public class PlaceXml extends DefaultHandler {
	
	private String currentElementName ;
	private String locationName ;
	private String latitude ;
	private String longitude ;
	
	private ArrayList<String> locationNames ;
	private ArrayList<String> latitudes ;
	private ArrayList<String> longitudes ;
	
	boolean isInLocation = false ;
	
	private final int LOCATION_LIST_MAX = 20 ;
	private int numberOfLocations = 0 ;
	
	public PlaceXml(){
		super() ;
	}
	
	/**
	* ドキュメント開始時
	*/
	public void startDocument() {
		//System.out.println("PlaceXml startDocument");
		locationNames = new ArrayList<String>();
		latitudes = new ArrayList<String>();
		longitudes = new ArrayList<String>();
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
		
	    currentElementName = tag ;
	    if(tag.equals("result")){
	        locationName = "" ;
	        latitude = "" ;
	        longitude = "" ;
	    } else if(tag.equals("location")){
	        isInLocation = true ;
	    }
	}
	
	/**
	* テキストデータ読み込み時
	*/
	public void characters(char[] ch,int offset,int length) {
		//System.out.println("テキストデータ：" + new String(ch, offset, length));
	    if(currentElementName.equals("name")){
	        locationName = new String(ch,offset,length) ;
	    } else if(isInLocation && currentElementName.equals("lat")){
	        latitude = new String(ch,offset,length) ;
	    } else if(isInLocation && currentElementName.equals("lng")){
	        longitude = new String(ch,offset,length) ;
	    }
	}
	
	/**
	* 要素の終了タグ読み込み時
	*/
	public void endElement(String uri,String localName,String qName) {
		//System.out.println("要素終了:" + qName);
		String tag = "" ;
		if(localName.equals("")){
			tag = qName ;
		} else {
			tag = localName ;
		}

		if(tag.equals("result")){
	        // add to list
	        if(numberOfLocations < LOCATION_LIST_MAX){
	            locationNames.add(locationName) ;
	            latitudes.add(latitude) ;
	            longitudes.add(longitude) ;
	            //NSLog(@"add %@(%@,%@)",locationName,latitude,longitude) ;
	            numberOfLocations++ ;
	        }
	    } else if(tag.equals("location")){
	        isInLocation = false ;
	    }
	    currentElementName = "" ;
	}
	
	/**
	* ドキュメント終了時
	*/
	public void endDocument() {
		//System.out.println("endDocument num="+locationNames.size());
	}
	
	public int getNumberOfLocations()
	{
		return locationNames.size() ;
	}
	
	public String getLocationNameAt(int index){
		String retString = null ;
		if(index < locationNames.size()){
			retString = locationNames.get(index) ;
		}
		return retString ;
	}

	public String getLatitudeAt(int index){
		String retString = null ;
		if(index < latitudes.size()){
			retString = latitudes.get(index) ;
		}
		return retString ;
	}

	public String getLongitudeAt(int index){
		String retString = null ;
		if(index < longitudes.size()){
			retString = longitudes.get(index) ;
		}
		return retString ;
	}
}    

