//
//  WebViewController.h
//  iOSWebSDKDemo
//
//  Created by Aashay Shah on 13/05/2017.
//  Copyright © 2017 Aashay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol ContentViewDelegate <NSObject>

- (void) contentViewDataResponse: (NSDictionary *) resultObject;

@end

@interface ContentViewController : UIViewController <WKScriptMessageHandler, WKUIDelegate> {
    NSMutableDictionary *resultObject;
}

@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) id<ContentViewDelegate> delegate;

- (void) loadInteractiveHTMLWithContent: (NSString *)contentName;

@end
