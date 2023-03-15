package co.veam.veam31000287;

import android.content.Context;
import android.util.Log;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

/**
 * Created by veam on 2015/06/18.
 */
public class VeamConfiguration {

    private static VeamConfiguration sSingleton = null ;

    private ConfigXmlHandler configXmlHandler ;

    public static synchronized VeamConfiguration getInstance(Context context) {
        if (sSingleton == null) {
            sSingleton = new VeamConfiguration(context);
        }
        return sSingleton;
    }

    public VeamConfiguration(Context context) {
        //VeamUtil.log("debug", "VeamConfiguration::VeamConfiguration") ;
        try {
            InputStream configXmlInputStream = context.getAssets().open("config.xml") ;
            SAXParserFactory spfactory = SAXParserFactory.newInstance() ;
            SAXParser parser = spfactory.newSAXParser() ;
            configXmlHandler = new ConfigXmlHandler() ;
            parser.parse(configXmlInputStream, configXmlHandler);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        }
    }

    public String getValue(String key){
        String value = "" ;
        if(configXmlHandler != null){
            value = configXmlHandler.getValue(key) ;
        }
        return value ;
    }

    public class ConfigXmlHandler extends DefaultHandler {

        private HashMap<String,String> values ;

        public ConfigXmlHandler(){
            super() ;
        }

        /**
         * ドキュメント開始時
         */
        public void startDocument() {
            //VeamUtil.log("debug", "ConfigXmlHandler::startDocument") ;
            values = new HashMap<String,String>() ;
        }

        /**
         * 要素の開始タグ読み込み時
         */
        public void startElement(String uri,String localName,String qName,Attributes attributes) {
            //VeamUtil.log("debug","startElement:" + qName + " localName=" + localName) ;

            String tag = "" ;
            if(localName.equals("")){
                tag = qName ;
            } else {
                tag = localName ;
            }

            String value = attributes.getValue("value") ;
            if(!VeamUtil.isEmpty(value)){
                //VeamUtil.log("debug","config : " + tag + "->" + value) ;
                values.put(tag,value) ;
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
            //VeamUtil.log("debug","ConfigXmlHandler::endDocument");
        }

        public String getValue(String key){
            String value = values.get(key) ;
            if(VeamUtil.isEmpty(value)){
                value = "" ;
            }
            return value ;
        }
    }


}
