package co.veam.veam31000287;

/**
 * Created by veam on 12/7/16.
 */
public class ConsoleTutorialElement {
    public String tutorialElementId ;
    public String title ;
    public String description ;
    public String imageFileName ;
    public int kind ;

    public ConsoleTutorialElement(String tutorialElementId, String title, String description, String imageFileName, int kind) {
        this.tutorialElementId = tutorialElementId;
        this.title = title;
        this.description = description;
        this.imageFileName = imageFileName;
        this.kind = kind;
    }
}
