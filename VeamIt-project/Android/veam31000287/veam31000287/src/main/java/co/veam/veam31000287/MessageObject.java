package co.veam.veam31000287;

public class MessageObject {
	
	public static final int MESSAGE_KIND_MESSAGE = 1 ;
	public static final int MESSAGE_KIND_DATE = 2 ;
	
	private String id ;
	private String fromUserId ;
	private String toUserId ;
	private String createdAt ;
	private String text ;
	private String readFlag ;
	private int kind ;
	
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
	public String getToUserId() {
		return toUserId;
	}
	public void setToUserId(String toUserId) {
		this.toUserId = toUserId;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public int getKind() {
		return kind;
	}
	public void setKind(int kind) {
		this.kind = kind;
	}
	public String getReadFlag() {
		return readFlag;
	}
	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	public MessageObject(String id, String fromUserId, String toUserId,String createdAt, String text, String readFlag, int kind) {
		super();
		this.id = id;
		this.fromUserId = fromUserId;
		this.toUserId = toUserId;
		this.createdAt = createdAt;
		this.text = text;
		this.readFlag = readFlag;
		this.kind = kind;
	}
	
}
