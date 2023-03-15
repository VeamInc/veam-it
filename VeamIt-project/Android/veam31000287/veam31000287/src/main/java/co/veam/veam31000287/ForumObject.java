package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class ForumObject implements HandlePostResultInterface {
	
	private SQLiteDatabase mDb ;
	
	private final String TABLE_NAME = "forum" ;
	
	private String id ;
    private String name ;
    private String kind ;
	private String displayOrder ;
	private String updateTimeId ;
	
	private boolean isForumGroup ;
	private int numberOfMembers ;

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
	
	

	public boolean isForumGroup() {
		return isForumGroup;
	}

	public void setForumGroup(boolean isForumGroup) {
		this.isForumGroup = isForumGroup;
	}

	public int getNumberOfMembers() {
		return numberOfMembers;
	}

	public void setNumberOfMembers(int numberOfMembers) {
		this.numberOfMembers = numberOfMembers;
	}

	public ForumObject(SQLiteDatabase db,String id)
	{
		mExistsRecord = false ;
		
		mDb = db ;
		
    	String[] columns = new String[]{
    			"id",
                "name",
                "kind",
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
            setKind(cursor.getString(2)) ;
			setDisplayOrder(cursor.getString(3)) ;
			setUpdateTimeId(cursor.getString(4)) ;
    	}
		cursor.close() ;
	}

	public ForumObject() {
	}

	public ForumObject(String id,String name,String kind,String displayOrder,String updateTimeId,boolean isForumGroup,int numberOfMembers){
		this.id = id ;
        this.name = name ;
        this.kind = kind ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
		this.isForumGroup = isForumGroup ;
		this.numberOfMembers = numberOfMembers ;
	}

	public ForumObject(Attributes attributes){
		this.setId(attributes.getValue("id")) ;
		this.setName(attributes.getValue("name")) ;
		this.setKind(attributes.getValue("kind")) ;
	}


	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
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
		//System.out.println("forum saved with updateTimeId=" + updateTimeId) ;
		if(this.mExistsRecord){
			// update
			VeamUtil.updateForum(mDb, id, name, kind, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertForum(mDb, id, name, kind, displayOrder, updateTimeId) ;
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
				//NSLog(@"set forumId:%@",self.forumId) ;
			}
		}

	}
}
