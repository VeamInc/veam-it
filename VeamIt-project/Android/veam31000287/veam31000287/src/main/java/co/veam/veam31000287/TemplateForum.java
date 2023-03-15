package co.veam.veam31000287;

import org.xml.sax.Attributes;

/**
 * Created by veam on 10/27/16.
 */
public class TemplateForum {
    private String templateForumId ;
    private String title ;

    public TemplateForum() {

    }

    public String getTemplateForumId() {
        return templateForumId;
    }

    public void setTemplateForumId(String templateForumId) {
        this.templateForumId = templateForumId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public TemplateForum(Attributes attributes) {
        this.setTemplateForumId(attributes.getValue("id")) ;
        this.setTitle(attributes.getValue("t")) ;
    }
}
