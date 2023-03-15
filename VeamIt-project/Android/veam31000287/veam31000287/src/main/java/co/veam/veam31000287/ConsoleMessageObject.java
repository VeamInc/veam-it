package co.veam.veam31000287;

/**
 * Created by veam on 12/14/16.
 */
public class ConsoleMessageObject {
    private String id ;
    private String appCreatorId ;
    private String mcnId ;
    private String createdAt ;
    private String text ;
    private String direction ;

    public ConsoleMessageObject(String id, String appCreatorId, String mcnId, String createdAt, String text, String direction) {
        this.id = id;
        this.appCreatorId = appCreatorId;
        this.mcnId = mcnId;
        this.createdAt = createdAt;
        this.text = text;
        this.direction = direction;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAppCreatorId() {
        return appCreatorId;
    }

    public void setAppCreatorId(String appCreatorId) {
        this.appCreatorId = appCreatorId;
    }

    public String getMcnId() {
        return mcnId;
    }

    public void setMcnId(String mcnId) {
        this.mcnId = mcnId;
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

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }
}
