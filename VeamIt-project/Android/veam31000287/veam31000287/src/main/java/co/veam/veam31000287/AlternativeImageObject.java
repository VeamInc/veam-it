package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

public class AlternativeImageObject {

    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "alternative_image" ;

    private String id ;
    private String fileName ;
    private String language ;
    private String url ;
    private String displayOrder ;
    private String updateTimeId ;

    private boolean mExistsRecord ;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(String displayOrder) {
        this.displayOrder = displayOrder;
    }

    public AlternativeImageObject(SQLiteDatabase db, String id)
    {
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "file_name",
                "language",
                "url",
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
            setFileName(cursor.getString(1)) ;
            setLanguage(cursor.getString(2)) ;
            setUrl(cursor.getString(3)) ;
            setDisplayOrder(cursor.getString(4)) ;
            setUpdateTimeId(cursor.getString(5)) ;
        }
        cursor.close() ;
    }

    public AlternativeImageObject(String id, String fileName, String language, String url, String displayOrder, String updateTimeId){
        this.id = id ;
        this.fileName = fileName ;
        this.language = language ;
        this.url = url ;
        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }

    public AlternativeImageObject(Attributes attributes){
        this.setId(attributes.getValue("id")) ;
        this.setFileName(attributes.getValue("f")) ;
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
            VeamUtil.updateAlternativeImage(mDb, id, fileName, language, url,  displayOrder, updateTimeId) ;
        } else {
            // insert
            VeamUtil.insertAlternativeImage(mDb, id, fileName, language, url,  displayOrder, updateTimeId) ;
            this.mExistsRecord = true ;
        }
    }
}
