package whichit.org.whichitsdksimple;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.provider.Settings.Secure;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

public class MainActivity extends AppCompatActivity {

    private WebView mainWebView;
    private TextView txtData;

    // Javascript object interface.
    // This class contain all the callback called by the javascript code.
    class JsObject {
        @JavascriptInterface
        public void show(String msg) { Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_LONG).show(); }

        @JavascriptInterface
        //Return a unique ID for user
        public String getAndroidID() { return Secure.getString(getApplicationContext().getContentResolver(),
                Secure.ANDROID_ID);}

        @JavascriptInterface
        public void reportData(String json) {
            try {
                JSONObject jsonObj = new JSONObject(json);
                JSONObject jsonObject = jsonObj.getJSONObject("whichitEventObject");
                String s = "";
                Iterator<String> keys = jsonObject.keys();
                while (keys.hasNext()){
                    String field = keys.next();
                    if (!jsonObject.has(field))
                        continue;
                    s += field + ": " + jsonObject.getString(field) + "\n";
                }
                txtData.setText(s);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //WebView
        mainWebView = (WebView) findViewById(R.id.mainView);
        mainWebView.setWebContentsDebuggingEnabled(true);
        mainWebView.setWebChromeClient(new WebChromeClient());
        mainWebView.getSettings().setJavaScriptEnabled(true);
        mainWebView.loadUrl("file:///android_asset/whchit_sdk_wrapper.html");
        mainWebView.addJavascriptInterface(new JsObject(), "javaObj");
        //TextView
        txtData = (TextView) findViewById(R.id.txtData);

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
