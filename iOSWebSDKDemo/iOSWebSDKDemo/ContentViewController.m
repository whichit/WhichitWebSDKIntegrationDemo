//
//  ContentViewController.m
//  iOSWebSDKDemo
//
//  Created by Aashay Shah on 13/05/2017.
//  Copyright © 2017 Aashay Shah. All rights reserved.
//

#import "ContentViewController.h"
#import <AdSupport/AdSupport.h>

@interface ContentViewController ()

@end

NSString * const USER_UNIQUE_ID = @"@UserUniqueID@";
NSString * const CONTENT_EMBED_CODE = @"@Content@";


@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) getJSObjectFieldsForEvent: (NSString *) eventName{
    
    NSDictionary *serverObjectFieldMapping = @{
                                               @"whichitView" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", nil],
                                               @"whichitVote" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"frameIndex", @"frameID", nil],
                                               @"whichitShare" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"network", nil],
                                               @"whichitCTAClick" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"ctaLink", @"engageCardID", @"engageCardType", nil],
                                               @"whichitCollectionStarted" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"collectionid", @"campaignid", @"placementid", nil],
                                               @"whichitCollectionFinished" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"collectionid", @"campaignid", @"placementid", nil],
                                               @"whichitEngageCardView" : [NSArray arrayWithObjects:@"name", @"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"engageCardID", @"engageCardType", nil]
                                              };
    
    return [serverObjectFieldMapping valueForKey:eventName];
    
}

- (NSString *) getUserIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (void) loadInteractiveHTMLWithContent: (NSString *)contentName {
    
    //read idfa
    NSString *idfaString = [self getUserIDFA];
    
    //html path
    NSString *wrapperPath = [[NSBundle mainBundle] pathForResource:@"whichit_sdk_wrapper" ofType:@"html"];
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:contentName ofType:@"html"];
    
    //build wrapper
    NSMutableString *rawHTML = [NSMutableString stringWithContentsOfFile:wrapperPath encoding:NSUTF8StringEncoding error:NULL];
    NSString *htmlTemplate = [rawHTML stringByReplacingOccurrencesOfString:USER_UNIQUE_ID withString:idfaString];
    NSString *contentHTML = [NSMutableString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:NULL];
    NSString *pageHTML = [htmlTemplate stringByReplacingOccurrencesOfString:CONTENT_EMBED_CODE withString:contentHTML];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"jsObj"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.UIDelegate = self;
    [self.webView loadHTMLString:pageHTML baseURL:nil];
    
    [self.view addSubview:self.webView];
    
}

- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSError *jsonError;
    NSData *jsonObjectData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDataDictionary = [NSJSONSerialization JSONObjectWithData:jsonObjectData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&jsonError];
    
    [self.delegate contentViewDataResponse:jsonDataDictionary[@"whichitEventObject"]];
    
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    NSURL *navigationURL = navigationAction.request.URL;
    if([[UIApplication sharedApplication] canOpenURL:navigationURL]){
        [[UIApplication sharedApplication] openURL:navigationURL
                                           options:@{}
                                 completionHandler:nil];
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
