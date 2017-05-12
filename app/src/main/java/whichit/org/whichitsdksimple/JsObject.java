package whichit.org.whichitsdksimple;

import android.content.Context;
import android.provider.Settings;
import android.webkit.JavascriptInterface;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

/**
 * Created by ggc on 12/05/17.
 * Javascript object interface.
 * This class contain all the callback called by the javascript code.
 */
public class JsObject {

    private final Context mContext;
    private final EventsCallback mCallback;

    public JsObject(Context context, EventsCallback callback){
        mContext = context;
        mCallback = callback;
    }

    @JavascriptInterface
    public String getBlockquote(){
        return "<blockquote data-wh_dark class=\"whichit-reference-object\" data-wh_campaign_id=\"59157e66b6e7ff091c52f03c\" data-wh_from=\"dougtheslug\"  style=\"border: 1px solid rgb(180, 180, 180); border-radius: 5px; position: relative; display: block; overflow: hidden; box-sizing: border-box; width: 100%; margin: 0 auto; transition: opacity 0.2s; -webkit-transition: opacity 0.2s; max-width: 440px; font-family: Helvetica Neue, Helvetica, Arial, sans-serif; padding: 0; text-align: start;\"><p dir=\"auto\" class=\"whichit-caption\" style=\"background-color:#FFFFFF; color:rgb(81, 81, 81); font-size: 21px; font-weight: 400; word-wrap: break-word; float: left; width: 100%; margin: 0px; clear: both; line-height: 22px; padding: 0px 7px 7px 7px; box-sizing: border-box;\">&nbsp;</p><div class=\"img\" style=\"background-color:#FFFFFF; background-image:url(\"https://cdn.getwhichit.com/static/embed_ph.svg\");background-position: center center;background-repeat: no-repeat;background-size: 75px auto;float: left;padding-bottom:100%;width: 100%;\"></div><div class=\"whichit-embed-bottom-bar\" style=\"display: block; clear: both; box-sizing: border-box; background: #F7F7F7 none repeat scroll 0px 0px; height: 49px;\"></div></blockquote>";
    };

    @JavascriptInterface
    //Return a unique ID for user
    public String getAndroidID() { return Settings.Secure.getString(mContext.getContentResolver(),
            Settings.Secure.ANDROID_ID);}

    @JavascriptInterface
    public void reportData(String json, String event) {
        try {
            JSONObject jsonObj = new JSONObject(json);
            JSONObject jsonObject = jsonObj.getJSONObject("whichitEventObject");
            mCallback.onEvent(jsonObject, EVENTS.fromString(event));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}
