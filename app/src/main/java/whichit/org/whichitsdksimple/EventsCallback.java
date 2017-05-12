package whichit.org.whichitsdksimple;

import org.json.JSONObject;

/**
 * Created by ggc on 12/05/17.
 * Callback called by the JsObject when an event is catch.
 */
public interface EventsCallback {
    void onEvent(JSONObject json, EVENTS event);
}
