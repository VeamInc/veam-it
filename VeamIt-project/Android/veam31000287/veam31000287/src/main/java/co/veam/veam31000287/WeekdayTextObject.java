package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class WeekdayTextObject {
	
	private SQLiteDatabase mDb ;
	
	private final String TABLE_NAME = "weekday_text" ;
	
	private String id ;
    private String start ;
    private String end ;
    private String weekday ;
    private String action ;
    private String title ;
    private String description ;
    private String linkUrl ;
	private String displayOrder ;
	private String updateTimeId ;

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

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}
	
	public String getWeekday() {
		return weekday;
	}

	public void setWeekday(String weekday) {
		this.weekday = weekday;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getLinkUrl() {
		return linkUrl;
	}

	public void setLinkUrl(String linkUrl) {
		this.linkUrl = linkUrl;
	}

	public WeekdayTextObject(SQLiteDatabase db,String id)
	{
		mExistsRecord = false ;
		
		mDb = db ;
		
    	String[] columns = new String[]{
    			"id",
    			"start",
    			"end",
    			"weekday",
    			"action",
    			"title",
    			"description",
    			"link_url",
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
			setStart(cursor.getString(1)) ;
			setEnd(cursor.getString(2)) ;
			setWeekday(cursor.getString(3)) ;
			setAction(cursor.getString(4)) ;
			setTitle(cursor.getString(5)) ;
			setDescription(cursor.getString(6)) ;
			setLinkUrl(cursor.getString(7)) ;
			setDisplayOrder(cursor.getString(8)) ;
			setUpdateTimeId(cursor.getString(9)) ;
    	}
		cursor.close() ;
	}
	
	public WeekdayTextObject(String id,String start,String end,String weekday,String action,String title,String description,String linkUrl,String displayOrder,String updateTimeId){
		this.id = id ;
		this.start = start ;
		this.end = end ;
		this.weekday = weekday ;
		this.action = action ;
		this.title = title ;
		this.description = description ;
		this.linkUrl = linkUrl ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
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
		//System.out.println("weekday_text saved with updateTimeId=" + updateTimeId) ;
		if(this.mExistsRecord){
			// update
			VeamUtil.updateWeekdayText(mDb, id,start,end,weekday,action,title,description,linkUrl, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertWeekdayText(mDb, id,start,end,weekday,action,title,description,linkUrl, displayOrder, updateTimeId) ;
			this.mExistsRecord = true ;
		}
	}
}
