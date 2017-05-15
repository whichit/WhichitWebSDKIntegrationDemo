package whichit.org.whichitsdksimple;

import android.content.Context;
import android.provider.Settings;
import android.webkit.JavascriptInterface;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Created by ggc on 12/05/17.
 * Javascript object interface.
 * This class contain all the callback called by the javascript code.
 */
public class JsObject {

    private final Context mContext;
    private final EventsCallback mCallback;
    private String mBlockquote = "";

    public JsObject(Context context, EventsCallback callback, String filePAth) {
        mContext = context;
        mCallback = callback;
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(
                    new InputStreamReader(mContext.getAssets().open(filePAth)));
            mBlockquote = reader.readLine();
        } catch (IOException e) {
            //log the exception
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    //log the exception
                    System.out.print(e);
                }
            }
        }
    }

    @JavascriptInterface
    public String getBlockquote(){
        return mBlockquote;
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
