//
//  ViewController.h
//  iOSWebSDKDemo
//
//  Created by Aashay Shah on 12/05/2017.
//  Copyright © 2017 Aashay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewController.h"

@interface ViewController : UIViewController {
    WebViewController *contentViewController;
}

@property (strong, nonatomic) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *btnContent1;
@property (weak, nonatomic) IBOutlet UIButton *btnContent2;
@property (weak, nonatomic) IBOutlet UIButton *btnContent3;

- (IBAction)viewContent1:(id)sender;
- (IBAction)viewContent2:(id)sender;
- (IBAction)viewContent3:(id)sender;


@end

