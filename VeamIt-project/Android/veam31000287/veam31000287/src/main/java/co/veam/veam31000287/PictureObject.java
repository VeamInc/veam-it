package co.veam.veam31000287;

import java.util.ArrayList;

public class PictureObject {
	
	private String id ;
	private String imageUrl ;
	private String socialUserId ;
	private String userName ;
	private String userIconUrl ;
	private String isLike ;
	private String likes ;
	private String createdAt ;
	private String forumId ;
	private String forumName ;
	private boolean showAllComments = false ;
	
	ArrayList<PictureCommentObject> comments ;
	
	public boolean isShowAllComments() {
		return showAllComments;
	}

	public void setShowAllComments(boolean showAllComments) {
		this.showAllComments = showAllComments;
	}



	public ArrayList<PictureCommentObject> getComments() {
		return comments;
	}

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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserIconUrl() {
		return userIconUrl;
	}

	public void setUserIconUrl(String userIconUrl) {
		this.userIconUrl = userIconUrl;
	}

	public String getIsLike() {
		return isLike;
	}

	public void setIsLike(String isLike) {
		this.isLike = isLike;
	}

	public String getLikes() {
		return likes;
	}

	public void setLikes(String likes) {
		this.likes = likes;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	
	

	public String getForumId() {
		return forumId;
	}

	public void setForumId(String forumId) {
		this.forumId = forumId;
	}

	public String getForumName() {
		return forumName;
	}

	public void setForumName(String forumName) {
		this.forumName = forumName;
	}

	public PictureObject(){

	}

	public PictureObject(String id,String imageUrl,String socialUserId,String userName,String userIconUrl,String isLike,String likes,String createdAt,String forumId,String forumName){
		this.id = id ;
		this.imageUrl = imageUrl ;
		this.socialUserId = socialUserId ;
		this.userName = userName ;
		this.userIconUrl = userIconUrl ;
		this.isLike = isLike ;
		this.likes = likes ;
		this.createdAt = createdAt ;
		this.forumId = forumId ;		
		this.forumName = forumName ;
		
		comments = new ArrayList<PictureCommentObject>() ; 

	}
	
	public boolean hasComment(PictureCommentObject pictureCommentObject){
		boolean retValue = false ;
		int count = comments.size() ;
		String id = pictureCommentObject.getId() ;
		for(int index = 0 ; index < count ; index++){
			PictureCommentObject workObject = comments.get(index) ;
			if(id.equals(workObject.getId())){
				retValue = true ;
				break ;
			}
		}
		return retValue ;
	}
	
	public void addComment(PictureCommentObject pictureCommentObject){
		if(!this.hasComment(pictureCommentObject)){
			comments.add(pictureCommentObject) ;
		}
	}
	
}
