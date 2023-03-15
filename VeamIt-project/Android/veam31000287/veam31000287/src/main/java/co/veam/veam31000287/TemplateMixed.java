package co.veam.veam31000287;

import org.xml.sax.Attributes;

/**
 * Created by veam on 10/27/16.
 */
public class TemplateMixed {
    private String templateMixedId ;
    private String title ;

    public TemplateMixed() {

    }

    public String getTemplateMixedId() {
        return templateMixedId;
    }

    public void setTemplateMixedId(String templateMixedId) {
        this.templateMixedId = templateMixedId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public TemplateMixed(Attributes attributes) {
        this.setTemplateMixedId(attributes.getValue("id")) ;
        this.setTitle(attributes.getValue("t")) ;
    }
}
