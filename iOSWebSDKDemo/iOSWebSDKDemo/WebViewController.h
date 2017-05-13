//
//  WebViewController.h
//  iOSWebSDKDemo
//
//  Created by Aashay Shah on 13/05/2017.
//  Copyright © 2017 Aashay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController <WKScriptMessageHandler> {
    NSMutableDictionary *result;
    UILabel *lblResult;
}

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSString *titleString;

@end
