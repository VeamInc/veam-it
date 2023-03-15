package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class VideoObject implements HandlePostResultInterface {

    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "video" ;

    private String id ;

    private String duration ;
    private String title ;
    private String videoCategoryId ;
    private String videoSubCategoryId ;
    private String kind ;
    private String thumbnailUrl ;
    private String dataUrl ;
    private String dataSize ;
    private String videoKey ;
    private String createdAt ;

    private String sourceUrl ; // Console only
    private String status ; // Console only
    private String statusText ; // Console only

    private MixedObject mixed ;

    private String displayOrder ;
    private String updateTimeId ;

    private boolean mExistsRecord ;

    public VideoObject() {

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

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

    public String getVideoCategoryId() {
        return videoCategoryId;
    }

    public void setVideoCategoryId(String videoCategoryId) {
        this.videoCategoryId = videoCategoryId;
    }

    public String getVideoSubCategoryId() {
        return videoSubCategoryId;
    }

    public void setVideoSubCategoryId(String videoSubCategoryId) {
        this.videoSubCategoryId = videoSubCategoryId;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getDataUrl() {
        return dataUrl;
    }

    public void setDataUrl(String dataUrl) {
        this.dataUrl = dataUrl;
    }

    public String getDataSize() {
        return dataSize;
    }

    public void setDataSize(String dataSize) {
        this.dataSize = dataSize;
    }

    public String getVideoKey() {
        return videoKey;
    }

    public void setVideoKey(String videoKey) {
        this.videoKey = videoKey;
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

    public String getSourceUrl() {
        return sourceUrl;
    }

    public void setSourceUrl(String sourceUrl) {
        this.sourceUrl = sourceUrl;
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

    public MixedObject getMixed() {
        return mixed;
    }

    public void setMixed(MixedObject mixed) {
        this.mixed = mixed;
    }

    public VideoObject(SQLiteDatabase db, String id)
    {
        //VeamUtil.log("debug", "VideoObject(id)" + id) ;
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "duration",
                "title",
                "video_category_id",
                "video_sub_category_id",
                "kind",
                "thumbnail_url",
                "data_url",
                "data_size",
                "video_key",
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
            //VeamUtil.log("debug", "found") ;
            mExistsRecord = true ;
            setId(cursor.getString(0)) ;

            setDuration(cursor.getString(1)) ;
            setTitle(cursor.getString(2)) ;
            setVideoCategoryId(cursor.getString(3)) ;
            setVideoSubCategoryId(cursor.getString(4)) ;
            setKind(cursor.getString(5)) ;
            setThumbnailUrl(cursor.getString(6)) ;
            setDataUrl(cursor.getString(7)) ;
            setDataSize(cursor.getString(8)) ;
            setVideoKey(cursor.getString(9)) ;
            setCreatedAt(cursor.getString(10)) ;

            setDisplayOrder(cursor.getString(11)) ;
            setUpdateTimeId(cursor.getString(12)) ;
        }
        cursor.close() ;
    }

    public VideoObject(String id, String duration, String title, String videoCategoryId, String videoSubCategoryId, String kind, String thumbnailUrl, String dataUrl, String dataSize, String videoKey, String createdAt, String displayOrder, String updateTimeId){
        this.id = id ;

        this.duration = duration ;
        this.title = title ;
        this.videoCategoryId = videoCategoryId ;
        this.videoSubCategoryId = videoSubCategoryId ;
        this.kind = kind ;
        this.thumbnailUrl = thumbnailUrl ;
        this.dataUrl = dataUrl ;
        this.dataSize = dataSize ;
        this.videoKey = videoKey ;
        this.createdAt = createdAt ;

        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }


    public VideoObject(Attributes attributes){

        this.setId(attributes.getValue("id")) ;
        this.setDuration(attributes.getValue("d")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setKind(attributes.getValue("k")) ;
        this.setVideoCategoryId(attributes.getValue("c")) ;
        this.setVideoSubCategoryId(attributes.getValue("s")) ;
        this.setThumbnailUrl(attributes.getValue("i")) ;
        //this.setImageSize(attributes.getValue("is")) ;
        this.setDataUrl(attributes.getValue("v")) ;
        this.setDataSize(attributes.getValue("vs")) ;
        this.setVideoKey(attributes.getValue("vk")) ;
        //this.setLinkUrl(attributes.getValue("l")) ;
        this.setSourceUrl(attributes.getValue("su")) ;
        this.setCreatedAt(attributes.getValue("cr")) ;
        this.setStatus(attributes.getValue("st")) ;
        this.setStatusText(attributes.getValue("stt")) ;

        mixed = new MixedObject() ;
        mixed.setId(attributes.getValue("mi")) ;
        mixed.setTitle(attributes.getValue("t")) ;
        mixed.setMixedCategoryId(attributes.getValue("mc")) ;
        mixed.setMixedSubCategoryId(attributes.getValue("ms")) ;
        mixed.setKind(attributes.getValue("mk")) ;
        mixed.setThumbnailUrl(attributes.getValue("mt")) ;
        mixed.setCreatedAt(attributes.getValue("cr")) ;
        mixed.setContentId(this.getId()) ;
        mixed.setDisplayType(attributes.getValue("mdt")) ;
        mixed.setDisplayName(attributes.getValue("mdn")) ;

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
        //VeamUtil.log("debug","VideoObject.save()" + this.mExistsRecord) ;
        if(this.mExistsRecord){
            // update
            VeamUtil.updateVideo(mDb, id, duration, title, videoCategoryId, videoSubCategoryId, kind, thumbnailUrl, dataUrl, dataSize, videoKey, createdAt, displayOrder, updateTimeId) ;
        } else {
            // insert
            VeamUtil.insertVideo(mDb, id, duration, title, videoCategoryId, videoSubCategoryId, kind, thumbnailUrl, dataUrl, dataSize, videoKey, createdAt, displayOrder, updateTimeId) ;
            this.mExistsRecord = true ;
        }
    }

    @Override
    public void handlePostResult(ArrayList<String> results) {
        //NSLog(@"%@::handlePostResult",NSStringFromClass(this.class])) ;
        if(results.size()  >= 3){
            //NSLog(@"count >= 3") ;
            String result = results.get(0) ;
            if(result.equals("OK")){
                this.setId(results.get(1)) ;
                //NSLog(@"set videoId:%@",self.videoId) ;
                this.mixed.setId(results.get(2)) ;
                //NSLog(@"set mixedId:%@",self.mixed.mixedId) ;
                if(results.size()  >= 6){
                    this.setStatus(results.get(3)) ;
                    //NSLog(@"set status:%@",self.status) ;
                    this.setStatusText(results.get(4)) ;
                    //NSLog(@"set statusText:%@",self.statusText) ;
                    this.setThumbnailUrl(results.get(5)); ;
                    //NSLog(@"set imageUrl:%@",self.imageUrl) ;
                }
            }
        }

    }
}
