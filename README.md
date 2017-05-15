# WhichitWebSDKIntegrationDemo

Load Whichit template
----------------------

In order to display a Whichit on the screen it is necessary to load an HTML5
template on the Activity. To do so in the example code has been added in the
MainActivity a WebView (mainWebView) and it is initialized in order to load the
template file whchit_sdk_wrapper.html and enable the JavaScript code to run. 

    public class MainActivity extends AppCompatActivity {
        ...
        ...
        private WebView mainWebView;
        ...
        mainWebView = (WebView) findViewById(R.id.mainView);
        //set true to debug on chrome.
        mainWebView.setWebContentsDebuggingEnabled(true);
        //enable JavaScript.
        mainWebView.setWebChromeClient(new WebChromeClient());
        mainWebView.getSettings().setJavaScriptEnabled(true);
        //load view.
        mainWebView.loadUrl("file:///android_asset/whchit_sdk_wrapper.html");

Load Whichit data
-----------------

In order to display the correct Whichit post it is necessary to pass to the
**JsObject** class a valid HTML file containing a single line with a valid
blockquote tag which contain the information to show to the user. The filename
represent the third parameter of the **JsObject** constructor.
_Please note: The HTML file has to be located in the assets folder_.

    
Handle events
--------------------

In order to finalize the initialization of the HTML template and handle the
relative events it a reference to an **JsObject** object is passed to the
JavaScript environment, this is done by the function **addJavascriptInterface**.
In order to initialize a **JsObject** it is necessary to pass a valid context
and an instance of **EventsCallback** which contain a member function
**onEvent** called by the JsObject when an event is catched by the underling
JavaScript code. The HTML5 template send then on each event a JSON object
representing the event and the relative event catched, from this method is the
possible to manage all the events. In the example once the event is cateched the
relative JSON is parsed and all the data are displayed on a TextBox. 

    public class MainActivity extends AppCompatActivity {
    ...
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
                }, **BLOCKQUOTE FILE**), "javaObj");
    ...
