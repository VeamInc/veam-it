package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/**
 * Created by veam on 2015/06/03.
 */
public class SellSectionItemObject {

    public static final String KIND_VIDEO   	= "1" ;
    public static final String KIND_PDF   	    = "2" ;
    public static final String KIND_AUDIO       = "3" ;

    private VideoObject videoObject ;
    private PdfObject pdfObject ;
    private AudioObject audioObject ;

    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "sell_section_item" ;

    private String id ;

    private String kind ;
    private String sellSectionCategoryId ;
    private String sellSectionSubCategoryId ;
    private String title ;

    private String status ; // Console only
    private String statusText ; // Console only

    private String contentId ;
    private String createdAt ;

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

    public String getSellSectionCategoryId() {
        return sellSectionCategoryId;
    }

    public void setSellSectionCategoryId(String sellSectionCategoryId) {
        this.sellSectionCategoryId = sellSectionCategoryId;
    }

    public String getSellSectionSubCategoryId() {
        return sellSectionSubCategoryId;
    }

    public void setSellSectionSubCategoryId(String sellSectionSubCategoryId) {
        this.sellSectionSubCategoryId = sellSectionSubCategoryId;
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

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
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

    public SellSectionItemObject(SQLiteDatabase db, String id)
    {
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "kind",
                "sell_section_category_id",
                "sell_section_sub_category_id",
                "title",
                "content_id",
                "created_at",
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
            setSellSectionCategoryId(cursor.getString(2)) ;
            setSellSectionSubCategoryId(cursor.getString(3)) ;
            setTitle(cursor.getString(4)) ;
            setContentId(cursor.getString(5)) ;
            setCreatedAt(cursor.getString(6)) ;

            setDisplayOrder(cursor.getString(7)) ;
            setUpdateTimeId(cursor.getString(8)) ;
        }
        cursor.close() ;
    }

    public SellSectionItemObject(String id, String kind, String sellSectionCategoryId, String sellSectionSubCategoryId, String title, String contentId, String createdAt, String displayOrder, String updateTimeId){
        this.id = id ;

        this.kind = kind ;
        this.sellSectionCategoryId = sellSectionCategoryId ;
        this.sellSectionSubCategoryId = sellSectionSubCategoryId ;
        this.title = title ;
        this.contentId = contentId ;
        this.createdAt = createdAt ;

        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }

    public SellSectionItemObject(){
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
            VeamUtil.updateSellSectionItem(mDb, id, kind, sellSectionCategoryId, sellSectionSubCategoryId, title, contentId, createdAt, displayOrder, updateTimeId) ;
        } else {
            // insert
            VeamUtil.insertSellSectionItem(mDb, id, kind, sellSectionCategoryId, sellSectionSubCategoryId, title, contentId, createdAt, displayOrder, updateTimeId) ;
            this.mExistsRecord = true ;
        }
    }

    public String getDurationString(SQLiteDatabase db){
        String durationString = "" ;
        if(kind.equals(SellSectionItemObject.KIND_VIDEO)){
            if(videoObject == null){
                videoObject = VeamUtil.getVideoObject(db,contentId) ;
            }
            if(videoObject != null){
                Integer duration = VeamUtil.parseInt(videoObject.getDuration()) ;
                durationString = String.format("Video - %02d:%02d", duration/60,duration%60) ;
            } else {
                durationString = "Video" ;
            }
        } else if(kind.equals(SellSectionItemObject.KIND_PDF)){
            durationString = "PDF" ;
        } else if(kind.equals(SellSectionItemObject.KIND_AUDIO)){
            if(audioObject == null){
                audioObject = VeamUtil.getAudioObject(db, contentId) ;
            }
            if(audioObject != null){
                Integer duration = VeamUtil.parseInt(audioObject.getDuration()) ;
                durationString = String.format("Audio - %02d:%02d", duration/60,duration%60) ;
            } else {
                durationString = "Audio" ;
            }
        }
        return durationString ;
    }

    public String getThumbnailUrl(SQLiteDatabase db){
        String thumbnailUrl = "" ;
        if(kind.equals(SellSectionItemObject.KIND_VIDEO)){
            if(videoObject == null){
                videoObject = VeamUtil.getVideoObject(db,contentId) ;
            }
            if(videoObject != null){
                thumbnailUrl = videoObject.getThumbnailUrl() ;
            }
        } else if(kind.equals(SellSectionItemObject.KIND_PDF)){
            if(pdfObject == null){
                pdfObject = VeamUtil.getPdfObject(db,contentId) ;
            }
            if(pdfObject != null){
                thumbnailUrl = pdfObject.getThumbnailUrl() ;
            }
        } else if(kind.equals(SellSectionItemObject.KIND_AUDIO)){
            if(audioObject == null){
                audioObject = VeamUtil.getAudioObject(db, contentId) ;
            }
            if(audioObject != null){
                thumbnailUrl = audioObject.getRectangleThumbnailUrl() ;
            }
        }
        return thumbnailUrl ;
    }

}
