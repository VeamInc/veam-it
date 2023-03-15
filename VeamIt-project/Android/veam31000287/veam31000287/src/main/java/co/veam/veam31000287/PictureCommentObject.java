package co.veam.veam31000287;


public class PictureCommentObject {
	
	private String id ;
	private String pictureId ;
	private String socialUserId ;
	private String userName ;
	private String text ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPictureId() {
		return pictureId;
	}

	public void setPictureId(String pictureId) {
		this.pictureId = pictureId;
	}

	public String getSocialUserId() {
		return socialUserId;
	}

	public void setSocialUserId(String socialUserId) {
		this.socialUserId = socialUserId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public PictureCommentObject(String id,String pictureId,String socialUserId,String userName,String text){
		this.id = id ;
		this.pictureId = pictureId ;
		this.socialUserId = socialUserId ;
		this.userName = userName ;
		this.text = text ;
	}
}
