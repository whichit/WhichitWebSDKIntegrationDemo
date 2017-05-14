# WhichitWebSDKIntegrationDemo

Load Whichit template
----------------------

In order to display a Whichit on the screen it is necessary to load an HTML5 template on the Activity.
To do so in the example code has been added in the MainActivity a WebView (mainWebView) and it is initialized in order to load the template file whchit_sdk_wrapper.html and enable the JavaScript code to run. 

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

In order to display the correct data it is necessary to implement the member function **getBlockquote** in the class **JsObject**. 
This class represent the interface used by the JavaScript code to interact with the Java code. The function *getBlockquote* return then a blockquote HTMl tag which will be integrated inside the displayed page, this element represent the actual Whichit/Campain displayed to the user. To display the right Whichit post it is then necessary copy-paste the right blockquote in the constant string blockquote.

    public class JsObject {
    ...
        private static final String blockquote = **BLOCKQUOTE TAG**
    ...
        @JavascriptInterface
        public String getBlockquote(){
            return blockquote;
        };
    ...
    
Handle events
--------------------

In order to finalize the initializzation of the HTML template and handle the relative events it a reference to an **JsObject** object is passed to the JavaScript environment, this is done by the function **addJavascriptInterface**.
In order to initialize a **JsObject** it is necessary to pass a valid context and an instance of **EventsCallback** which contain a member function **onEvent** called by the JsObject when an event is catched by the underling JavaScript code. The HTML5 template send then on each event a JSON object representing the event and the relative event catched, from this method is the possible to manage all the events. In the example once the event is cateched the relative JSON is parsed and all the data are displayed on a TextBox. 

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
                }), "javaObj");
    ...
