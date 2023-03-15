package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class YoutubeObject implements HandlePostResultInterface {
	
	private SQLiteDatabase mDb ;
	
	private final String TABLE_NAME = "youtube" ;
	
	private String id ;
    private String duration ;
    private String title ;
    private String description ;
	private String youtubeCategoryId ;
    private String youtubeSubCategoryId ;
    private String youtubeVideoId ;
    private String isNew ;
    private String kind ;
    private String link ;
	
	
	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
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

	public String getYoutubeSubCategoryId() {
		return youtubeSubCategoryId;
	}

	public void setYoutubeSubCategoryId(String youtubeSubCategoryId) {
		this.youtubeSubCategoryId = youtubeSubCategoryId;
	}

	public String getYoutubeVideoId() {
		return youtubeVideoId;
	}

	public void setYoutubeVideoId(String youtubeVideoId) {
		this.youtubeVideoId = youtubeVideoId;
	}

	public String getIsNew() {
		return isNew;
	}

	public void setIsNew(String isNew) {
		this.isNew = isNew;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

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

	
	
	

	
	
	public YoutubeObject(SQLiteDatabase db,String id)
	{
		mExistsRecord = false ;
		
		mDb = db ;
		
    	String[] columns = new String[]{
    			"id",
    			"duration",
    			"title",
    			"description",
    			"youtube_category_id",
    			"youtube_sub_category_id",
    			"youtube_video_id",
    			"is_new",
    			"kind",
    			"link",
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
			
			setDuration(cursor.getString(1)) ;
			setTitle(cursor.getString(2)) ;
			setDescription(cursor.getString(3)) ;
			setYoutubeCategoryId(cursor.getString(4)) ;
			setYoutubeSubCategoryId(cursor.getString(5)) ;
			setYoutubeVideoId(cursor.getString(6)) ;
			setIsNew(cursor.getString(7)) ;
			setKind(cursor.getString(8)) ;
			setLink(cursor.getString(9)) ;
			
			setDisplayOrder(cursor.getString(10)) ;
			setUpdateTimeId(cursor.getString(11)) ;
    	}
		cursor.close() ;
	}
	
	
	public YoutubeObject(String id,String duration,String title,String description,String youtubeCategoryId,String youtubeSubCategoryId,
			String youtubeVideoId,String isNew,String kind,String link,String displayOrder,String updateTimeId){
		this.id = id ;
		this.duration = duration ;
		this.title = title ;
		this.description = description ;
		this.youtubeCategoryId = youtubeCategoryId ;
		this.youtubeSubCategoryId = youtubeSubCategoryId ;
		this.youtubeVideoId = youtubeVideoId ;
		this.isNew = isNew ;
		this.kind = kind ;
		this.link = link ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
	}

	public YoutubeObject(Attributes attributes){
		this.setId(attributes.getValue("id")) ;
		this.setKind(attributes.getValue("k")) ;
		this.setDuration(attributes.getValue("d")) ;
		this.setTitle(attributes.getValue("t")) ;
		this.setDescription(attributes.getValue("e")) ;
		this.setYoutubeCategoryId(attributes.getValue("c")) ;
		this.setYoutubeSubCategoryId(attributes.getValue("s")) ;
		this.setYoutubeVideoId(attributes.getValue("v")) ;
		this.setIsNew(attributes.getValue("n")) ;
		this.setLink(attributes.getValue("l")) ;
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
		//System.out.println("save youtube with updateTimeId=" + updateTimeId) ;
		if(this.mExistsRecord){
			// update
			VeamUtil.updateYoutube(mDb, id, duration,title,description,youtubeCategoryId,youtubeSubCategoryId,youtubeVideoId,isNew,kind,link, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertYoutube(mDb, id, duration,title,description,youtubeCategoryId,youtubeSubCategoryId,youtubeVideoId,isNew,kind,link, displayOrder, updateTimeId) ;
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
				//NSLog(@"set youtubeId:%@",self.youtubeId) ;
			}
		}

	}
}
