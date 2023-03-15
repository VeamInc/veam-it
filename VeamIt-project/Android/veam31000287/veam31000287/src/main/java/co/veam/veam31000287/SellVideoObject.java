package co.veam.veam31000287;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.xml.sax.Attributes;

public class SellVideoObject {

	private SQLiteDatabase mDb ;

	private final String TABLE_NAME = "sell_video" ;

	private String id ;
	private String videoId ;
	private String productId ;
	private String price ;
	private String priceText ;
    private String description ;
    private String buttonText ;

	private String status ; // Console only
	private String statusText ; // Console only

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

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getPriceText() {
		return priceText;
	}

	public void setPriceText(String priceText) {
		this.priceText = priceText;
	}

	public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getButtonText() {
        return buttonText;
    }

    public void setButtonText(String buttonText) {
        this.buttonText = buttonText;
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

	public SellVideoObject(SQLiteDatabase db, String id)
	{
		mExistsRecord = false ;

		mDb = db ;

    	String[] columns = new String[]{
    			"id",
    			"video_id",
    			"product_id",
				"price",
				"price_text",
                "description",
                "button_text",
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

			setVideoId(cursor.getString(1));
			setProductId(cursor.getString(2));
			setPrice(cursor.getString(3));
			setPriceText(cursor.getString(4));
            setDescription(cursor.getString(5));
            setButtonText(cursor.getString(6));

			setDisplayOrder(cursor.getString(7)) ;
			setUpdateTimeId(cursor.getString(8)) ;
    	}
		cursor.close() ;
	}


	public SellVideoObject(String id, String videoId, String productId, String price, String priceText, String description, String buttonText, String displayOrder, String updateTimeId){
		this.id = id ;
		this.videoId = videoId ;
		this.productId = productId ;
        this.priceText = priceText ;
        this.description = description ;
        this.buttonText = buttonText ;
		this.displayOrder = displayOrder ;
		this.updateTimeId = updateTimeId ;
	}

	public SellVideoObject(){
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
			VeamUtil.updateSellVideo(mDb, id, videoId,productId,price,priceText,description,buttonText, displayOrder, updateTimeId) ;
		} else {
			// insert
			VeamUtil.insertSellVideo(mDb, id, videoId,productId,price,priceText,description,buttonText, displayOrder, updateTimeId) ;
			this.mExistsRecord = true ;
		}
	}
}
