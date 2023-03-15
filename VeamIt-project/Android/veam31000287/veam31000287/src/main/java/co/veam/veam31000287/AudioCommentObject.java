package co.veam.veam31000287;


public class AudioCommentObject {
	
	private String id ;
	private String audioId ;
	private String socialUserId ;
	private String userName ;
	private String text ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getAudioId() {
		return audioId;
	}

	public void setAudioId(String audioId) {
		this.audioId = audioId;
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

	public AudioCommentObject(String id, String audioId, String socialUserId, String userName, String text){
		this.id = id ;
		this.audioId = audioId ;
		this.socialUserId = socialUserId ;
		this.userName = userName ;
		this.text = text ;
	}
	
}
