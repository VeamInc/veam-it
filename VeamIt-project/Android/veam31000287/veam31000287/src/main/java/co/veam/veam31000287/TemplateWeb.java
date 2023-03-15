package co.veam.veam31000287;

import org.xml.sax.Attributes;

/**
 * Created by veam on 10/27/16.
 */
public class TemplateWeb {
    private String templateWebId ;
    private String title ;

    public TemplateWeb() {

    }

    public String getTemplateWebId() {
        return templateWebId;
    }

    public void setTemplateWebId(String templateWebId) {
        this.templateWebId = templateWebId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public TemplateWeb(Attributes attributes) {
        this.setTemplateWebId(attributes.getValue("id")) ;
        this.setTitle(attributes.getValue("t")) ;
    }
}
