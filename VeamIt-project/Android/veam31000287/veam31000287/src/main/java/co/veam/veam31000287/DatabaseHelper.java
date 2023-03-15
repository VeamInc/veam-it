package co.veam.veam31000287;

import android.content.Context;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import org.xml.sax.SAXException;

import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class DatabaseHelper  extends SQLiteOpenHelper {

	private Context context ;

	private static DatabaseHelper sSingleton = null;

	public static synchronized DatabaseHelper getInstance(Context context) {
		if (sSingleton == null) {
			sSingleton = new DatabaseHelper(context);
		}
		return sSingleton;
	}

	public DatabaseHelper(Context context) {
		super(context, "VEAMSXSW", null, 5) ;
		this.context = context ;
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		//VeamUtil.log("debug","DatabaseHelper::onCreate") ;
		db.beginTransaction();
		try {
			this.createForVersion1(db) ;
			this.createForVersion2(db) ;
			this.createForVersion3(db) ;
			this.createForVersion4(db) ;
			this.createForVersion5(db) ;
			db.setTransactionSuccessful();
			//System.out.println("success") ;
		} finally {
			db.endTransaction();
		}

		// initial data
		this.setInitialData(db) ;
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		//VeamUtil.log("debug","DatabaseHelper::onUpgrade "+oldVersion+" to " + newVersion) ;

		VeamUtil.setPreferenceString(context, VeamUtil.PREFERENCE_KEY_LATEST_UPDATE_ID, "1") ;

		db.beginTransaction();
		try {
			if(oldVersion < 2){
				this.createForVersion2(db) ;
			}
			if(oldVersion < 3){
				this.createForVersion3(db) ;
			}
			if(oldVersion < 4){
				this.createForVersion4(db) ;
			}
			if(oldVersion < 5){
				this.createForVersion5(db) ;
			}
			db.setTransactionSuccessful();
		} finally {
			db.endTransaction();
		}

		//this.setInitialData(db) ;
	}



	private void createForVersion1(SQLiteDatabase db){
		//VeamUtil.log("debug","DatabaseHelper::createForVersion1") ;
		db.execSQL("create table youtube_category (display_order integer not null,updatetimeid integer not null,id integer not null,name text not null) ;") ;
		db.execSQL("create table youtube_sub_category (display_order integer not null,updatetimeid integer not null,id integer not null,youtube_category_id integer not null,name text not null) ;") ;
		db.execSQL("create table youtube (display_order integer not null,updatetimeid integer not null,id integer not null,duration integer not null,youtube_category_id integer not null,youtube_sub_category_id integer not null,title text not null,description text not null,youtube_video_id text not null,link text not null,is_new boolean not null,kind integer not null) ;") ;
		db.execSQL("create table forum (display_order integer not null,updatetimeid integer not null,id integer not null,name text not null,kind text not null) ;") ;
		db.execSQL("create table web (display_order integer not null,updatetimeid integer not null,id integer not null,title text not null,url text not null,web_category_id text not null) ;") ;
		db.execSQL("create table alternative_image (display_order integer not null,updatetimeid integer not null,id integer not null,file_name text not null,language text not null,url text not null) ;") ;
		db.execSQL("create table mixed (display_order integer not null,updatetimeid integer not null,id integer not null,kind text not null,mixed_category_id text not null,mixed_sub_category_id text not null,title text not null,content_id text not null,thumbnail_url text not null,created_at text not null,display_type text not null,display_name text not null) ;") ;
		db.execSQL("create table audio (display_order integer not null,updatetimeid integer not null,id integer not null,duration text not null,title text not null,audio_category_id text not null,audio_sub_category_id text not null,kind text not null,thumbnail_url text not null,data_url text not null,data_size text not null,link_url text not null,created_at text not null) ;") ;
		db.execSQL("create table video (display_order integer not null,updatetimeid integer not null,id integer not null,duration text not null,title text not null,video_category_id text not null,video_sub_category_id text not null,kind text not null,thumbnail_url text not null,data_url text not null,data_size text not null,video_key text not null,created_at text not null) ;") ;
	}

	private void createForVersion2(SQLiteDatabase db){
		//VeamUtil.log("debug","DatabaseHelper::createForVersion2") ;
		db.execSQL("create table video_category (display_order integer not null,updatetimeid integer not null,id integer not null,name text not null) ;") ;
		db.execSQL("create table sell_video (display_order integer not null,updatetimeid integer not null,id integer not null,video_id text not null,product_id text not null,price text not null,price_text text not null,description text not null,button_text text not null) ;") ;
	}

	private void createForVersion3(SQLiteDatabase db){
		//VeamUtil.log("debug","DatabaseHelper::createForVersion3") ;
		db.execSQL("create table sell_item_category (display_order integer not null,updatetimeid integer not null,id integer not null,kind text not null,target_category_id text not null) ;") ;
		db.execSQL("create table pdf_category (display_order integer not null,updatetimeid integer not null,id integer not null,name text not null) ;") ;
		db.execSQL("create table sell_pdf (display_order integer not null,updatetimeid integer not null,id integer not null,pdf_id text not null,product_id text not null,price text not null,price_text text not null,description text not null,button_text text not null) ;") ;
		db.execSQL("create table pdf (display_order integer not null,updatetimeid integer not null,id integer not null,title text not null,pdf_category_id text not null,pdf_sub_category_id text not null,kind text not null,thumbnail_url text not null,created_at text not null) ;") ;
	}

	private void createForVersion4(SQLiteDatabase db){
		//VeamUtil.log("debug","DatabaseHelper::createForVersion4") ;
		db.execSQL("create table audio_category (display_order integer not null,updatetimeid integer not null,id integer not null,name text not null) ;") ;
		db.execSQL("create table sell_audio (display_order integer not null,updatetimeid integer not null,id integer not null,audio_id text not null,product_id text not null,price text not null,price_text text not null,description text not null,button_text text not null) ;") ;
		db.execSQL("alter table audio add column rectangle_thumbnail_url text ;") ;
	}

	private void createForVersion5(SQLiteDatabase db){
		//VeamUtil.log("debug","DatabaseHelper::createForVersion5") ;
		db.execSQL("create table sell_section_category (display_order integer not null,updatetimeid integer not null,id integer not null,name text not null) ;") ;
		db.execSQL("create table sell_section_item (display_order integer not null,updatetimeid integer not null,id integer not null,sell_section_category_id text not null,sell_section_sub_category_id text not null,title text not null,kind text not null,content_id text not null,created_at text not null) ;") ;
		db.execSQL("alter table pdf add column data_url text ;") ;
		db.execSQL("alter table pdf add column data_size text ;") ;
		db.execSQL("alter table pdf add column token text ;") ;
	}

	private void setInitialData(SQLiteDatabase db){
		//VeamUtil.log("debug", "DatabaseHelper::setInitialData ") ;
		try {
			InputStream defaultXmlInputStream = context.getAssets().open("default_contents.xml");
			SAXParserFactory spfactory = SAXParserFactory.newInstance();
			SAXParser parser = spfactory.newSAXParser();
			SharedPreferences preferences = VeamUtil.getPreferences(context) ;
			SharedPreferences.Editor editor = preferences.edit();
			UpdateXmlHandler updateXmlHandler = new UpdateXmlHandler(context,db,editor,false,true,null) ;
			parser.parse(defaultXmlInputStream,updateXmlHandler) ;
			editor.commit();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
	}

}
