package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class YoutubeCategoryObject implements HandlePostResultInterface {
	
	private SQLiteDatabase mDb ;
	
	private final String TABLE_NAME = "youtube_category" ;
	
	private String id ;
	private String name ;
	private String displayOrder ;
	private String updateTimeId ;
	private String disabled ; // Console only

	private boolean mExistsRecord ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(String displayOrder) {
		this.displayOrder = displayOrder;
	}

	public YoutubeCategoryObject(SQLiteDatabase db,String id)
	{
		mExistsRecord = false ;
		
		mDb = db ;
		
    	String[] columns = new String[]{
    			"id",
    			"name",
    			"display_order",
    			"updatetimeid",
    			} ;
    	
    	String where = "id=?" ;
    	String[] params = new String[]{id} ;
		Cursor cursor = db.query(this.TABLE_NAME, columns, where, params, null, null, null);
		cursor.moveToFirst();
		
		int length = cursor.getCount() ;
		if(length > 0){
			mExistsRecord = true ;
			setId(cursor.getString(0)) ;
			setName(cursor.getString(1)) ;
			setDisplayOrder(cursor.getString(2)) ;
			setUpdateTimeId(cursor.getString(3)) ;
    	}
		cursor.close() ;
	}
	
	public YoutubeCategoryObject(String id,String name,String displayOrder,String updateTimeId){
		this.id = id ;
		this.name = name ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
	}

	public YoutubeCategoryObject(Attributes attributes){
		this.setId(attributes.getValue("id")) ;
		this.setName(attributes.getValue("name")) ;
		/*
		this.setKind(attributes.getValue("kind")) ;
		this.setEmbed(attributes.getValue("e")) ;
		this.setEmbedUrl(attributes.getValue("u")) ;
		*/
		this.setDisabled(attributes.getValue("d")) ;
	}

	public String getDisabled() {
		return disabled;
	}

	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUpdateTimeId() {
		return updateTimeId;
	}

	public void setUpdateTimeId(String updateTimeId) {
		this.updateTimeId = updateTimeId;
	}

	public void updateValue(String columnName,String value){
    	String where = "id=?" ;
    	String[] params = new String[]{this.id} ;
    	ContentValues cv = new ContentValues();
    	cv.put(columnName, value);
		mDb.update(this.TABLE_NAME, cv,where, params) ;
	}
	
	public void save()
	{
		//System.out.println("youtube_category saved with updateTimeId=" + updateTimeId) ;
		if(this.mExistsRecord){
			// update
			VeamUtil.updateYoutubeCategory(mDb, id, name, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertYoutubeCategory(mDb, id, name, displayOrder, updateTimeId) ;
			this.mExistsRecord = true ;
		}
	}

	@Override
	public void handlePostResult(ArrayList<String> results) {
		//NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
		if(results.size()  >= 2){
			//NSLog(@"count >= 2") ;
			String result = results.get(0) ;
			if(result.equals("OK")){
				this.setId(results.get(1)) ;
				//NSLog(@"set youtubeCategoryId:%@",self.youtubeCategoryId) ;
			}
		}
	}
}
