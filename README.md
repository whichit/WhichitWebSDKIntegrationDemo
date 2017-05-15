# WhichitWebSDKIntegrationDemo

Web SDK Demo Definitions
------------------------

Wrapper : The Whichit WebSDK Wrapper template. Found in the file: whichit_sdk_wrapper.html

Content : Paste the blockquote found on the final page of creation in an HTML file with naming convention: "Content_1.html", "Content_2.html", etc.

ContentViewController: This is the UIViewController example file that creates a `WKWebView`, loads the HTML from the `Content` and `Wrapper` files, and handles callbacks from Javascript actions.

Whichit : A singular post.

Collection: A collection of `Whichits` that could be a Survey or a Quiz.

Engage Card: The final view of a `Whichit` or `Collection` which contains a `Call-To-Action (CTA)` button along with some information.

Load Whichit Data
----------------------

In order to display the Whichit entity on the screen, 
* Implement the `ContentViewController` delegate called `ContentViewDelegate` in the `UIViewController`.
* Implement `ContentViewDelegate's` `-(void)contentViewDataResponse:(NSDictionary *)resultObject;` method. The `resultObject` is a `NSDictionary` which contains the following fields:

   `name`: Name of the event returned.
   `fromSite`: IFrame listener - will always be "whichit"
   `vessel`: The whichitSDK.
   `userID`: The user's ID
   `placementid`: The placement's ID
   `campaignid`: The campaign's ID
   `collectionid`: The collection's(survey/quiz) ID
   `whichitid`: The whichit posts's ID
   `frameIndex`: The zero-based index of the whichit's frames
   `frameID`: The whichit post's frame's ID
   `engageCardID`: The engage card's ID
   `engageCardType`: The Type of engage card
   `ctaLink`: The hyperlink on the 'CTA' button of an engage card

* Initialise an instance of `ContentViewController`, set the current controller as it's delegate, and invoke it's `- (void) loadInteractiveHTMLWithContent: (NSString *)contentName;` method where, the parameter (`contentName`) is the name of the `Content (definition above)` file.

* Finally, present the `ContentViewController`.

Example:
``` objective-c
contentViewController = [[ContentViewController alloc] init];
contentViewController.delegate = self;

[contentViewController loadInteractiveHTMLWithContent:contentName];

self.navigationController.navigationBar.translucent = NO;
[self.navigationController pushViewController:contentViewController animated:YES];
```

Handle events
--------------------

Following are the events reported:
* whichitView: Reported once the `Whichit` object is loaded and rendered.
* whichitVote: Reported once the user votes on the `Whichit`.
* whichitShare: Reported when the user clicks on the Facebook or Twitter share after voting.
* whichitCTAClick: Reported when the user cliks on the `CTA button` to either Redirect or collect emails.
* whichitCollectionStarted: If a `Whichit` is placed inside a `Collection (i.e a survey or a quiz)`, the vote on the first `Whichit` of this `Collection` reports `whichitCollectionStarted`.
* whichitCollectionFinished: If a `Whichit` is placed inside a `Collection (i.e a survey or a quiz)`, the vote on the last `Whichit` of this `Collection` reports `whichitCollectionFinished`.
* whichitEngageCardView: Reported when the `Engage Card` is shown - normally after a `whichitVote` or `whichitCollectionFinished`.
