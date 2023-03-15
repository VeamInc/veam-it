package co.veam.veam31000287;


public class VideoCommentObject {
	
	private String id ;
	private String videoId ;
	private String socialUserId ;
	private String userName ;
	private String text ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getVideoId() {
		return videoId;
	}

	public void setVideoId(String videoId) {
		this.videoId = videoId;
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

	public VideoCommentObject(String id, String videoId, String socialUserId, String userName, String text){
		this.id = id ;
		this.videoId = videoId ;
		this.socialUserId = socialUserId ;
		this.userName = userName ;
		this.text = text ;
	}
	
}
