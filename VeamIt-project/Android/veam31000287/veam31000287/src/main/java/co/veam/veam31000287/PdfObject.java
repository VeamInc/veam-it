package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

import java.util.ArrayList;

public class PdfObject implements HandlePostResultInterface {

    private SQLiteDatabase mDb ;

    private final String TABLE_NAME = "pdf" ;

    private String id ;

    private String title ;
    private String pdfCategoryId ;
    private String pdfSubCategoryId ;
    private String kind ;
    private String thumbnailUrl ;
    private String dataUrl ;
    private String dataSize ;
    private String token ;
    private String createdAt ;
    private String sourceUrl ;

    private String displayOrder ;
    private String updateTimeId ;

    private boolean mExistsRecord ;

    public PdfObject() {

    }


    public String getSourceUrl() {
        return sourceUrl;
    }

    public void setSourceUrl(String sourceUrl) {
        this.sourceUrl = sourceUrl;
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

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

    public String getPdfCategoryId() {
        return pdfCategoryId;
    }

    public void setPdfCategoryId(String pdfCategoryId) {
        this.pdfCategoryId = pdfCategoryId;
    }

    public String getPdfSubCategoryId() {
        return pdfSubCategoryId;
    }

    public void setPdfSubCategoryId(String pdfSubCategoryId) {
        this.pdfSubCategoryId = pdfSubCategoryId;
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

    public PdfObject(SQLiteDatabase db, String id)
    {
       //VeamUtil.log("debug", "pdfObject(id)" + id) ;
        mExistsRecord = false ;

        mDb = db ;

        String[] columns = new String[]{
                "id",
                "title",
                "pdf_category_id",
                "pdf_sub_category_id",
                "kind",
                "thumbnail_url",
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

            setTitle(cursor.getString(1)) ;
            setPdfCategoryId(cursor.getString(2)) ;
            setPdfSubCategoryId(cursor.getString(3)) ;
            setKind(cursor.getString(4)) ;
            setThumbnailUrl(cursor.getString(5)) ;
            setCreatedAt(cursor.getString(6)) ;

            setDisplayOrder(cursor.getString(7)) ;
            setUpdateTimeId(cursor.getString(8)) ;
        }
        cursor.close() ;
    }

    public PdfObject(String id, String title, String pdfCategoryId, String pdfSubCategoryId, String kind, String thumbnailUrl, String createdAt, String displayOrder, String updateTimeId,String dataUrl,String dataSize,String token){
        this.id = id ;

        this.title = title ;
        this.pdfCategoryId = pdfCategoryId ;
        this.pdfSubCategoryId = pdfSubCategoryId ;
        this.kind = kind ;
        this.thumbnailUrl = thumbnailUrl ;
        this.createdAt = createdAt ;

        this.dataUrl = dataUrl ;
        this.dataSize = dataSize ;
        this.token = token ;

        this.displayOrder = displayOrder ;
        this.updateTimeId = updateTimeId ;
    }

    public PdfObject(Attributes attributes){
        this.setId(attributes.getValue("id")) ;
        this.setTitle(attributes.getValue("t")) ;
        this.setKind(attributes.getValue("k")) ;
        this.setPdfCategoryId(attributes.getValue("c")) ;
        this.setPdfSubCategoryId(attributes.getValue("s")) ;
        this.setThumbnailUrl(attributes.getValue("i")) ;
        //this.setImageSize(attributes.getValue("is")) ;
        this.setDataUrl(attributes.getValue("v")) ;
        this.setDataSize(attributes.getValue("vs")) ;
        this.setCreatedAt(attributes.getValue("cr")) ;

        String encodedUrl = attributes.getValue("bu") ;
        if(!VeamUtil.isEmpty(encodedUrl)){
            this.setDataUrl(VeamUtil.bbDecode(encodedUrl)) ; ;
        }

        String encodedToken = attributes.getValue("bt") ;
        if(!VeamUtil.isEmpty(encodedToken)){
            //VeamUtil.setPdfToken(VeamUtil.bbDecode(encodedToken),this.getId()) ;
        }

    /*
    mixed = [[Mixed alloc] init] ;
    [mixed setMixedId(attributes.getValue("mi")) ;
    [mixed setTitle(attributes.getValue("t")) ;
    [mixed setMixedCategoryId(attributes.getValue("mc")) ;
    [mixed setMixedSubCategoryId(attributes.getValue("ms")) ;
    [mixed setKind(attributes.getValue("mk")) ;
    [mixed setThumbnailUrl(attributes.getValue("mt")) ;
    [mixed setCreatedAt(attributes.getValue("cr")) ;
    [mixed setContentId:self.videoId] ;
    [mixed setDisplayType(attributes.getValue("mdt")) ;
    [mixed setDisplayName(attributes.getValue("mdn")) ;
     */

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
       //VeamUtil.log("debug","PdfObject.save()" + this.mExistsRecord) ;
        if(this.mExistsRecord){
            // update
            VeamUtil.updatePdf(mDb, id, title, pdfCategoryId, pdfSubCategoryId, kind, thumbnailUrl, createdAt, displayOrder, updateTimeId,dataUrl,dataSize,token);
        } else {
            // insert
            VeamUtil.insertPdf(mDb, id, title, pdfCategoryId, pdfSubCategoryId, kind, thumbnailUrl, createdAt, displayOrder, updateTimeId,dataUrl,dataSize,token);
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
                //NSLog(@"set PdfId:%@",self.PdfId) ;
                //[self.mixed setMixedId(results.get(2)) ;
                //NSLog(@"set mixedId:%@",self.mixed.mixedId) ;
                if(results.size()  >= 6){
                    //this.setStatus(results.get(3)) ;
                    //NSLog(@"set status:%@",self.status) ;
                    //this.setStatusText(results.get(4)) ;
                    //NSLog(@"set statusText:%@",self.statusText) ;
                    this.setThumbnailUrl(results.get(5)); ;
                    //NSLog(@"set imageUrl:%@",self.imageUrl) ;
                }
            }
        }

    }
}
