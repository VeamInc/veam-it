package co.veam.veam31000287;

public class UserNotificationObject {
	
	public static final String USER_NOTIFICATION_KIND_MESSAGE          = "1" ;
	public static final String USER_NOTIFICATION_KIND_FOLLOW           = "2" ;
	public static final String USER_NOTIFICATION_KIND_LIKE_PICTURE     = "3" ;
	public static final String USER_NOTIFICATION_KIND_COMMENT_PICTURE  = "4" ;

	private String id ;
	private String fromUserId ;
	private String createdAt ;
	private String message ;
	private String text ;
	private String kind ;
	private String readFlag ;
	private String pictureId ;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFromUserId() {
		return fromUserId;
	}
	public void setFromUserId(String fromUserId) {
		this.fromUserId = fromUserId;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	public String getReadFlag() {
		return readFlag;
	}
	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	public String getPictureId() {
		return pictureId;
	}
	public void setPictureId(String pictureId) {
		this.pictureId = pictureId;
	}
	public UserNotificationObject(String id, String fromUserId,String createdAt, String message, String text, String kind,String readFlag, String pictureId) {
		super();
		this.id = id;
		this.fromUserId = fromUserId;
		this.createdAt = createdAt;
		this.message = message;
		this.text = text;
		this.kind = kind;
		this.readFlag = readFlag;
		this.pictureId = pictureId;
	}
}
