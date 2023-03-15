package co.veam.veam31000287;

public class MessageUserObject {
	
	private String imageUrl ;
	private String socialUserId ;
	private String name ;
	

	
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public MessageUserObject(String socialUserId,String name,String imageUrl){
		this.socialUserId = socialUserId ;
		this.name = name ;
		this.imageUrl = imageUrl ;
	}
}
