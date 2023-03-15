package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class WebObject implements HandlePostResultInterface {

    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "web" ;

    private String id ;
    private String title ;
    private String url ;
    private String webCategoryId ;
    private String displayOrder ;
    private String updateTimeId ;

    private boolean mExistsRecord ;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getWebCategoryId() {
        return webCategoryId;
    }

    public void setWebCategoryId(String webCategoryId) {
        this.webCategoryId = webCategoryId;
    }

    public String getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(String displayOrder) {
        this.displayOrder = displayOrder;
    }

    public WebObject(SQLiteDatabase db,String id)
    {
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "title",
                "url",
                "web_category_id",
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
            setTitle(cursor.getString(1)) ;
            setUrl(cursor.getString(2)) ;
            setWebCategoryId(cursor.getString(3)); ;
            setDisplayOrder(cursor.getString(4)) ;
            setUpdateTimeId(cursor.getString(5)) ;
        }
        cursor.close() ;
    }

    public WebObject() {
    }

    public WebObject(String id, String title, String url, String webCategoryId, String displayOrder, String updateTimeId){
        this.id = id ;
        this.title = title ;
        this.url = url ;
        this.webCategoryId = webCategoryId ;
        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }

    public WebObject(Attributes attributes){
        this.setId(attributes.getValue("id")) ;
        this.setWebCategoryId(attributes.getValue("c")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setUrl(attributes.getValue("u")) ;
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
        if(this.mExistsRecord){
            // update
            VeamUtil.updateWeb(mDb, id, title, url, webCategoryId, displayOrder, updateTimeId) ;
        } else {
            // insert
            VeamUtil.insertWeb(mDb, id, title, url, webCategoryId, displayOrder, updateTimeId) ;
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
                //NSLog(@"set webId:%@",self.webId) ;
            }
        }

    }
}
