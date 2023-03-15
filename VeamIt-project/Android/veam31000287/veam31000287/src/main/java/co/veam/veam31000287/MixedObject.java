package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import org.xml.sax.Attributes;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Created by veam on 2015/06/03.
 */
public class MixedObject implements HandlePostResultInterface {

    public static final String KIND_FAVORITES 		= "FAVORITES" ;
    public static final String KIND_YEAR          	= "0" ;
    public static final String KIND_MESSAGE       	= "1" ;
    public static final String KIND_MUSIC         	= "2" ;
    public static final String KIND_SPECIAL       	= "3" ;
    public static final String KIND_FIXED_VIDEO   	        = "7" ;
    public static final String KIND_PERIODICAL_VIDEO   	= "8" ;
    public static final String KIND_FIXED_AUDIO         	= "9" ;
    public static final String KIND_PERIODICAL_AUDIO   	= "10" ;


    public static final String DISPLAY_TYPE_DEFAULT      = "0" ;
    public static final String DISPLAY_TYPE_TITLE       	= "1" ;


    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "mixed" ;

    private String id ;

    private String kind ;
    private String mixedCategoryId ;
    private String mixedSubCategoryId ;
    private String title ;
    private String contentId ;
    private String thumbnailUrl ;
    private String createdAt ;
    private String displayType ;
    private String displayName ;

    private String status ; // Console only
    private String statusText ; // Console only
    private String deadlineString ; // Console only

    private String displayOrder ;
    private String updateTimeId ;

    private boolean mExistsRecord ;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public String getMixedCategoryId() {
        return mixedCategoryId;
    }

    public void setMixedCategoryId(String mixedCategoryId) {
        this.mixedCategoryId = mixedCategoryId;
    }

    public String getMixedSubCategoryId() {
        return mixedSubCategoryId;
    }

    public void setMixedSubCategoryId(String mixedSubCategoryId) {
        this.mixedSubCategoryId = mixedSubCategoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContentId() {
        return contentId;
    }

    public void setContentId(String contentId) {
        this.contentId = contentId;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getDisplayType() {
        return displayType;
    }

    public void setDisplayType(String displayType) {
        this.displayType = displayType;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(String displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getUpdateTimeId() {
        return updateTimeId;
    }

    public void setUpdateTimeId(String updateTimeId) {
        this.updateTimeId = updateTimeId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public String getDeadlineString() {
        return deadlineString;
    }

    public void setDeadlineString(String deadlineString) {
        this.deadlineString = deadlineString;
    }

    public MixedObject(SQLiteDatabase db,String id)
    {
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "kind",
                "mixed_category_id",
                "mixed_sub_category_id",
                "title",
                "content_id",
                "thumbnail_url",
                "created_at",
                "display_type",
                "display_name",
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

            setKind(cursor.getString(1)) ;
            setMixedCategoryId(cursor.getString(2)) ;
            setMixedSubCategoryId(cursor.getString(3)) ;
            setTitle(cursor.getString(4)) ;
            setContentId(cursor.getString(5)) ;
            setThumbnailUrl(cursor.getString(6)) ;
            setCreatedAt(cursor.getString(7)) ;
            setDisplayType(cursor.getString(8)) ;
            setDisplayName(cursor.getString(9)) ;


            setDisplayOrder(cursor.getString(10)) ;
            setUpdateTimeId(cursor.getString(11)) ;
        }
        cursor.close() ;
    }

    public MixedObject(String id,String kind,String mixedCategoryId,String mixedSubCategoryId,String title,String contentId,String thumbnailUrl,String createdAt,String displayType,String displayName,String displayOrder,String updateTimeId){
        this.id = id ;

        this.kind = kind ;
        this.mixedCategoryId = mixedCategoryId ;
        this.mixedSubCategoryId = mixedSubCategoryId ;
        this.title = title ;
        this.contentId = contentId ;
        this.thumbnailUrl = thumbnailUrl ;
        this.createdAt = createdAt ;
        this.displayType = displayType ;
        this.displayName = displayName ;

        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }

    public MixedObject(Attributes attributes){
        this.setId(attributes.getValue("id")) ;
        this.setKind(attributes.getValue("k")) ;
        this.setMixedCategoryId(attributes.getValue("c")) ;
        this.setMixedSubCategoryId(attributes.getValue("s")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setContentId(attributes.getValue("ci")) ;
        this.setDisplayType(attributes.getValue("dt")) ;
        this.setStatus(attributes.getValue("st")) ;
        this.setStatusText(attributes.getValue("stt")) ;
        this.setThumbnailUrl(attributes.getValue("th")) ;
        this.setCreatedAt(attributes.getValue("ct")) ;
    }

    public MixedObject(){
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
            VeamUtil.updateMixed(mDb, id, kind, mixedCategoryId, mixedSubCategoryId, title, contentId, thumbnailUrl, createdAt, displayType, displayName, displayOrder, updateTimeId) ;
        } else {
            // insert
            VeamUtil.insertMixed(mDb, id, kind, mixedCategoryId, mixedSubCategoryId, title, contentId, thumbnailUrl, createdAt, displayType, displayName, displayOrder, updateTimeId) ;
            this.mExistsRecord = true ;
        }
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        VeamUtil.log("debug", "MixedObject::handlePostResult") ;
        if(results.size()  >= 3){
            VeamUtil.log("debug", "Count >= 3") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                VeamUtil.log("debug", "OK") ;
                this.setId(results.get(1)) ;
                this.setContentId(results.get(2)) ;
                VeamUtil.log("debug", "ContentId=" + this.getContentId()) ;
                if(results.size() >= 5) {
                    VeamUtil.log("debug", "Count >= 6");
                    this.setStatus(results.get(3));
                    //NSLog(@"set status:%@",self.status) ;
                    this.setStatusText(results.get(4));
                    //NSLog(@"set statusText:%@",self.statusText) ;
                    if (results.size() >= 6) {
                        this.setThumbnailUrl(results.get(5));
                        //NSLog(@"set imageUrl:%@",self.imageUrl) ;
                    }
                }
            }
        }
    }
}
