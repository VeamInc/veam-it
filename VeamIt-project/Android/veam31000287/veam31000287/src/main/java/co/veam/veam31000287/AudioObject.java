package co.veam.veam31000287;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.io.Serializable;

public class AudioObject implements Serializable {

    public static final String VEAM_AUDIO_KIND_FAVORITES    ="FAVORITES" ;
    public static final String VEAM_AUDIO_KIND_YEAR         ="0" ;
    public static final String VEAM_AUDIO_KIND_MESSAGE      ="1" ;
    public static final String VEAM_AUDIO_KIND_MUSIC        ="2" ;
    public static final String VEAM_AUDIO_KIND_SPECIAL      ="3" ;


    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "audio" ;

    private String id ;

    private String duration ;
    private String title ;
    private String audioCategoryId ;
    private String audioSubCategoryId ;
    private String kind ;
    private String thumbnailUrl ;
    private String rectangleThumbnailUrl ;
    private String dataUrl ;
    private String dataSize ;
    private String linkUrl ;
    private String createdAt ;

    private MixedObject mixed ; // Console only

    private String displayOrder ;
    private String updateTimeId ;

    private boolean mExistsRecord ;

    public AudioObject() {

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

    public String getAudioCategoryId() {
        return audioCategoryId;
    }

    public void setAudioCategoryId(String audioCategoryId) {
        this.audioCategoryId = audioCategoryId;
    }

    public String getAudioSubCategoryId() {
        return audioSubCategoryId;
    }

    public void setAudioSubCategoryId(String audioSubCategoryId) {
        this.audioSubCategoryId = audioSubCategoryId;
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

    public String getRectangleThumbnailUrl() {
        return rectangleThumbnailUrl;
    }

    public void setRectangleThumbnailUrl(String rectangleThumbnailUrl) {
        this.rectangleThumbnailUrl = rectangleThumbnailUrl;
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

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
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

    public MixedObject getMixed() {
        return mixed;
    }

    public void setMixed(MixedObject mixed) {
        this.mixed = mixed;
    }

    public AudioObject(SQLiteDatabase db, String id)
    {
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "duration",
                "title",
                "audio_category_id",
                "audio_sub_category_id",
                "kind",
                "thumbnail_url",
                "rectangle_thumbnail_url",
                "data_url",
                "data_size",
                "link_url",
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

            setDuration(cursor.getString(1)) ;
            setTitle(cursor.getString(2)) ;
            setAudioCategoryId(cursor.getString(3)) ;
            setAudioSubCategoryId(cursor.getString(4)) ;
            setKind(cursor.getString(5)) ;
            setThumbnailUrl(cursor.getString(6)) ;
            setRectangleThumbnailUrl(cursor.getString(7)) ;
            setDataUrl(cursor.getString(8)) ;
            setDataSize(cursor.getString(9)) ;
            setLinkUrl(cursor.getString(10)) ;
            setCreatedAt(cursor.getString(11)) ;

            setDisplayOrder(cursor.getString(12)) ;
            setUpdateTimeId(cursor.getString(13)) ;
        }
        cursor.close() ;
    }

    public AudioObject(String id, String duration,String title,String audioCategoryId,String audioSubCategoryId,String kind,String thumbnailUrl,String rectangleThumbnailUrl,String dataUrl,String dataSize,String linkUrl,String createdAt, String displayOrder, String updateTimeId){
        this.id = id ;

        this.duration = duration ;
        this.title = title ;
        this.audioCategoryId = audioCategoryId ;
        this.audioSubCategoryId = audioSubCategoryId ;
        this.kind = kind ;
        this.thumbnailUrl = thumbnailUrl ;
        this.rectangleThumbnailUrl = rectangleThumbnailUrl ;
        this.dataUrl = dataUrl ;
        this.dataSize = dataSize ;
        this.linkUrl = linkUrl ;
        this.createdAt = createdAt ;

        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }

    public AudioObject(Attributes attributes){
        this.setId(attributes.getValue("id")) ;
        this.setAudioCategoryId(attributes.getValue("c")) ;
        this.setAudioSubCategoryId(attributes.getValue("s")) ;
        this.setDuration(attributes.getValue("d")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setKind(attributes.getValue("k")) ;
        this.setThumbnailUrl(attributes.getValue("i")) ;
        this.setRectangleThumbnailUrl(attributes.getValue("ri")) ;
        this.setDataUrl(attributes.getValue("v")) ;
        this.setDataSize(attributes.getValue("vs")) ;
        this.setLinkUrl(attributes.getValue("l")) ;
        this.setCreatedAt(attributes.getValue("cr")) ;

        String encodedUrl = attributes.getValue("bu") ;
        if(!VeamUtil.isEmpty(encodedUrl)){
            this.setDataUrl(VeamUtil.bbDecode(encodedUrl)) ;
        }

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
        if(this.mExistsRecord){
            // update
            VeamUtil.updateAudio(mDb, id,  duration, title, audioCategoryId, audioSubCategoryId, kind, thumbnailUrl,rectangleThumbnailUrl, dataUrl, dataSize, linkUrl, createdAt, displayOrder, updateTimeId) ;
        } else {
            // insert
            VeamUtil.insertAudio(mDb, id,  duration, title, audioCategoryId, audioSubCategoryId, kind, thumbnailUrl,rectangleThumbnailUrl,  dataUrl, dataSize, linkUrl, createdAt, displayOrder, updateTimeId) ;
            this.mExistsRecord = true ;
        }
    }

    public String getDataFileName(){
        return String.format("p%s.dat",id) ;
    }

    public boolean dataFileExists(Context context){
        return VeamUtil.fileExistsAtVeamDirectory(context, this.getDataFileName(), VeamUtil.parseInt(this.getDataSize())) ;
    }

    public String getDataFilePath(Context context){
        return VeamUtil.getVeamFilePath(context, this.getDataFileName()) ;
    }


}
