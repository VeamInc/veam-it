package co.veam.veam31000287;

public class FollowObject {
	
	private String id ;
	private String imageUrl ;
	private String socialUserId ;
	private String socialUserName ;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getSocialUserId() {
		return socialUserId;
	}

	public void setSocialUserId(String socialUserId) {
		this.socialUserId = socialUserId;
	}

	public String getSocialUserName() {
		return socialUserName;
	}

	public void setSocialUserName(String socialUserName) {
		this.socialUserName = socialUserName;
	}

	public FollowObject(String id,String imageUrl,String socialUserId,String socialUserName){
		this.id = id ;
		this.imageUrl = imageUrl ;
		this.socialUserId = socialUserId ;
		this.socialUserName = socialUserName ;
	}
}
