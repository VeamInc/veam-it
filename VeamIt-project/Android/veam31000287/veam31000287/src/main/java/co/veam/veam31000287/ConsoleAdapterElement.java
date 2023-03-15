package co.veam.veam31000287;

/**
 * Created by veam on 11/24/16.
 */
public class ConsoleAdapterElement {

    ///////////////////////////////////////////////////
    public static int KIND_EDITABLE_TEXT         = 0 ;
    public static int KIND_EDITABLE_LONG_TEXT    = 1 ;
    public static int KIND_EDITABLE_SELECT       = 2 ;
    public static int KIND_TITLE_ONLY            = 3 ;
    public static int KIND_TITLE_CLICKABLE       = 4 ;
    public static int KIND_SPACER                = 5 ;
    public static int KIND_SMALL_TITLE           = 6 ;
    public static int KIND_TITLE_AND_DESCRIPTION = 7 ;
    public static int KIND_TEXT_CLICKABLE        = 8 ;
    public static int KIND_TEXT_ORDER_STOP       = 9 ;
    public static int KIND_TEXT_ORDER_REMOVE     = 10 ;
    ///////////////////////////////////////////////////
    public static int NUMBER_OF_KINDS            = 11 ;
    ///////////////////////////////////////////////////

    private int elementId ;
    private int kind ;
    private int colorType ;
    private String title ;
    private String value ;
    private String[] values ;

    public ConsoleAdapterElement(int elementId,int kind,int colorType,String title,String value,String[] values){
        this.elementId = elementId ;
        this.kind = kind ;
        this.title = title ;
        this.value = value ;
        this.values = values ;
        this.colorType = colorType ;
    }

    public int getElementId() {
        return elementId;
    }

    public void setElementId(int elementId) {
        this.elementId = elementId;
    }

    public int getColorType() {
        return colorType;
    }

    public void setColorType(int colorType) {
        this.colorType = colorType;
    }

    public int getKind() {
        return kind;
    }

    public void setKind(int kind) {
        this.kind = kind;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String[] getValues() {
        return values;
    }

    public void setValues(String[] values) {
        this.values = values;
    }
}
