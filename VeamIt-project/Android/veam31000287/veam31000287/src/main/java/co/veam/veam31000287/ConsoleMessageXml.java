package co.veam.veam31000287;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import java.util.ArrayList;

/**
 * Created by veam on 12/14/16.
 */
public class ConsoleMessageXml extends DefaultHandler {
    public static final String MESSAGES_KEY_IS_BLOCKED = "is_blocked" ;


    private ArrayList<ConsoleMessageObject> messages ;
    private ArrayList<MessageUserObject> messageUsers ;
    private boolean shouldReverseOrder = false ;
    private String previousDateString ;
    private int latestAddCount ;
    private boolean lastPageLoaded = false ;

    private String appCreatorName ;
    private String mcnName ;

    public boolean isshouldReverseOrder() {
        return shouldReverseOrder;
    }

    public void setShouldReverseOrder(boolean shouldReverseOrder) {
        this.shouldReverseOrder = shouldReverseOrder;
    }

    public ConsoleMessageXml(){
        super() ;
    }

    /**
     * ドキュメント開始時
     */
    public void startDocument() {
        //System.out.println("TweetXml startDocument");
        messages = new ArrayList<ConsoleMessageObject>();
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
            String appCreatorId = attributes.getValue("cid") ;
            String mcnId = attributes.getValue("mid") ;
            String createdAt = attributes.getValue("c") ;
            String text = attributes.getValue("t") ;
            String direction = attributes.getValue("d") ;
            ConsoleMessageObject messageObject = new ConsoleMessageObject(id,appCreatorId,mcnId,createdAt, text, direction) ;

            /*
            if(shouldGenerateDateElement){
                NSString *dateString = [VeamUtil getMessageDateString:message.createdAt] ;
                if(![dateString isEqualToString:previousDateString]){
                    if(previousDateString != nil){
                        AppCreatorMessage *dateMessage = [[AppCreatorMessage alloc] init] ;
                        [dateMessage setAppCreatorMessageId:previousDateString] ;
                        [dateMessage setAppCreatorId:@"0"] ;
                        [dateMessage setMcnId:@"0"] ;
                        [dateMessage setCreatedAt:message.createdAt] ;
                        [dateMessage setText:previousDateString] ;
                        [dateMessage setKind:MESSAGE_KIND_DATE] ;
                        [messages insertObject:dateMessage atIndex:0] ;
                        latestAddCount++ ;
                    }

                    previousDateString = dateString ;
                }
                [messages insertObject:message atIndex:0] ;
            } else {
                [messages addObject:message] ;
            }

            //[messages addObject:message] ;
            latestAddCount++ ;
            */


            if(shouldReverseOrder){
	        	/*
	            String dateString = VeamUtil.getMessageDateString(createdAt) ;
	            if(!dateString.equals(previousDateString)){
	                if(previousDateString != null){
	                    ConsoleMessageObject dateConsoleMessageObject = new ConsoleMessageObject(previousDateString,"0", "0",createdAt, previousDateString, "", ConsoleMessageObject.MESSAGE_KIND_DATE) ;
	                    messages.add(0,dateConsoleMessageObject) ;
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
        } else if(tag.equals("user_name")){
            appCreatorName = attributes.getValue("creator") ;
            mcnName = attributes.getValue("mcn") ;

        } else if(tag.equals("page")){
            String isLastPage = attributes.getValue("is_last_page") ;
            if(VeamUtil.parseInt(isLastPage) == 1){
                lastPageLoaded = true ;
            } else {
                lastPageLoaded = false ;
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

    public ArrayList<ConsoleMessageObject> getMessages(){
        return messages ;
    }

    public ConsoleMessageObject getMessageAt(int index){
        ConsoleMessageObject retMessage = null ;
        if(index < messages.size()){
            retMessage = messages.get(index) ;
        }
        return retMessage ;
    }

    public String getAppCreatorName() {
        return appCreatorName;
    }

    public void setAppCreatorName(String appCreatorName) {
        this.appCreatorName = appCreatorName;
    }

    public String getMcnName() {
        return mcnName;
    }

    public void setMcnName(String mcnName) {
        this.mcnName = mcnName;
    }
}

