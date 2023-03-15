package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class YoutubeSubCategoryObject {
	
	private SQLiteDatabase mDb ;
	
	private final String TABLE_NAME = "youtube_sub_category" ;
	
	private String id ;
	private String youtubeCategoryId ;
	private String name ;
	private String displayOrder ;
	private String updateTimeId ;

	private boolean mExistsRecord ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getYoutubeCategoryId() {
		return youtubeCategoryId;
	}

	public void setYoutubeCategoryId(String youtubeCategoryId) {
		this.youtubeCategoryId = youtubeCategoryId;
	}

	public String getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(String displayOrder) {
		this.displayOrder = displayOrder;
	}

	public YoutubeSubCategoryObject(SQLiteDatabase db,String id)
	{
		mExistsRecord = false ;
		
		mDb = db ;
		
    	String[] columns = new String[]{
    			"id",
    			"youtube_category_id",
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
			setYoutubeCategoryId(cursor.getString(1)) ;
			setName(cursor.getString(2)) ;
			setDisplayOrder(cursor.getString(3)) ;
			setUpdateTimeId(cursor.getString(4)) ;
    	}
		cursor.close() ;
	}
	
	public YoutubeSubCategoryObject(String id,String youtubeCategoryId,String name,String displayOrder,String updateTimeId){
		this.id = id ;
		this.youtubeCategoryId = youtubeCategoryId ;
		this.name = name ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
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
		//System.out.println("youtube_sub_category saved with updateTimeId=" + updateTimeId) ;
		if(this.mExistsRecord){
			// update
			VeamUtil.updateYoutubeSubCategory(mDb, id, youtubeCategoryId, name, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertYoutubeSubCategory(mDb, id, youtubeCategoryId, name, displayOrder, updateTimeId) ;
			this.mExistsRecord = true ;
		}
	}
}
