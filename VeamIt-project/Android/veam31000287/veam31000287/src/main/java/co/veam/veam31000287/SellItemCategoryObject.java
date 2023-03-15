package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class SellItemCategoryObject implements HandlePostResultInterface {

	private SQLiteDatabase mDb ;

	private final String TABLE_NAME = "sell_item_category" ;

	public static final String KIND_VIDEO_CATEGORY 	= "1" ;
	public static final String KIND_PDF_CATEGORY 	= "2" ;
	public static final String KIND_AUDIO_CATEGORY 	= "3" ;

	private String id ;
	private String kind ;
	private String targetCategoryId ;
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

	public SellItemCategoryObject() {
	}

	public SellItemCategoryObject(SQLiteDatabase db, String id)
	{
		mExistsRecord = false ;

		mDb = db ;

    	String[] columns = new String[]{
    			"id",
				"kind",
				"target_category_id",
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
			setKind(cursor.getString(1)); ;
			setTargetCategoryId(cursor.getString(2)); ;
			setDisplayOrder(cursor.getString(3)) ;
			setUpdateTimeId(cursor.getString(4)) ;
    	}
		cursor.close() ;
	}

	public SellItemCategoryObject(String id, String kind, String targetCategoryId, String displayOrder, String updateTimeId){
		this.id = id ;
		this.kind = kind ;
		this.targetCategoryId = targetCategoryId ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
	}

	public SellItemCategoryObject(Attributes attributes){
		this.setId(attributes.getValue("id")) ;
		this.setTargetCategoryId(attributes.getValue("target")) ;
		this.setKind(attributes.getValue("kind")) ;
	}


	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getTargetCategoryId() {
		return targetCategoryId;
	}

	public void setTargetCategoryId(String targetCategoryId) {
		this.targetCategoryId = targetCategoryId;
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
		//System.out.println("sell_item_category saved with updateTimeId=" + updateTimeId) ;
		if(this.mExistsRecord){
			// update
			VeamUtil.updateSellItemCategory(mDb, id, kind, targetCategoryId, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertSellItemCategory(mDb, id, kind, targetCategoryId, displayOrder, updateTimeId) ;
			this.mExistsRecord = true ;
		}
	}

	@Override
	public void handlePostResult(ArrayList<String> results) {
		//NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
		if(results.size()  >= 5){
			//NSLog(@"count >= 2") ;
			String result = results.get(0) ;
			if(result.equals("OK")){
				this.setId(results.get(1)) ;
				this.setKind(results.get(2)) ;
				this.setTargetCategoryId(results.get(3)) ;
				//NSLog(@"set videoCategoryId:%@",self.videoCategoryId) ;
			}
		}

	}
}
