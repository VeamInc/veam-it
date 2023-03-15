package co.veam.veam31000287;

public class ForumGroupObject {
	
	private String id ;
	private String forumGroupCategoryId ;
	private String forumId ;
	private String forumName ;
	private String numberOfMembers ;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getForumGroupCategoryId() {
		return forumGroupCategoryId;
	}
	public void setForumGroupCategoryId(String forumGroupCategoryId) {
		this.forumGroupCategoryId = forumGroupCategoryId;
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
	public String getNumberOfMembers() {
		return numberOfMembers;
	}
	public void setNumberOfMembers(String numberOfMembers) {
		this.numberOfMembers = numberOfMembers;
	}
	public ForumGroupObject(String id, String forumGroupCategoryId,String forumId, String forumName, String numberOfMembers) {
		super();
		this.id = id;
		this.forumGroupCategoryId = forumGroupCategoryId;
		this.forumId = forumId;
		this.forumName = forumName;
		this.numberOfMembers = numberOfMembers;
	}

	
	
	
	
}


