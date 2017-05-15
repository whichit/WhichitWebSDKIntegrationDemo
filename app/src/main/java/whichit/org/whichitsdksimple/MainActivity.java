package whichit.org.whichitsdksimple;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class MainActivity extends AppCompatActivity {

    private WebView mainWebView;
    private TextView txtData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //TextView
        txtData = (TextView) findViewById(R.id.txtData);
        //WebView
        mainWebView = (WebView) findViewById(R.id.mainView);
        mainWebView.setWebContentsDebuggingEnabled(true);
        mainWebView.setWebChromeClient(new WebChromeClient());
        mainWebView.getSettings().setJavaScriptEnabled(true);
        mainWebView.loadUrl("file:///android_asset/whchit_sdk_wrapper.html");
        mainWebView.addJavascriptInterface(new JsObject(getApplicationContext(), new EventsCallback() {
            @Override
            public void onEvent(JSONObject json, EVENTS event) {
                String s = event.toString() + "\n";
                Iterator<String> keys = json.keys();
                while (keys.hasNext()){
                    String field = keys.next();
                    if (!json.has(field))
                        continue;
                    try {
                        s += field + ": " + json.getString(field) + "\n";
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                txtData.setText(s);
            }
        }, "blockquote.html"), "javaObj");
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
