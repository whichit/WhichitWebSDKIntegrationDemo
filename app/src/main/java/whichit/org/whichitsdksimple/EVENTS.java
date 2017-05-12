package whichit.org.whichitsdksimple;

/**
 * Created by ggc on 12/05/17.
 * List all the possible events catched by the JavaScript code.
 */
public enum EVENTS {
    VOTE ("vote"),
    VIEW ("view"),
    SHARE("share"),
    CTA_CLICK("cta_click"),
    COLLECTION_STARTED("collection_started"),
    COLLECTION_FINISHED("collection_finished"),
    CARD_VIEW("card_view");

    private final String text;

    EVENTS(String text) {
        this.text = text;
    }

    /* (non-Javadoc)
    * @see java.lang.Enum#toString()
    */
    @Override
    public String toString() {
        return text;
    }

    public static EVENTS fromString(String text) {
        for (EVENTS b : EVENTS.values()) {
            if (b.text.equalsIgnoreCase(text)) {
                return b;
            }
        }
        return null;
    }
}
