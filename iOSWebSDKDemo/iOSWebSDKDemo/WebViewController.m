//
//  WebViewController.m
//  iOSWebSDKDemo
//
//  Created by Aashay Shah on 13/05/2017.
//  Copyright © 2017 Aashay Shah. All rights reserved.
//

#import "WebViewController.h"
#import <AdSupport/AdSupport.h>

@interface WebViewController ()

@end

NSString * const USER_UNIQUE_ID = @"@UserUniqueID@";
NSString * const CONTENT_EMBED_CODE = @"@Content@";


@implementation WebViewController

//NSArray *whViewKeys = [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", nil];

//"fromSite"
//vessel: "",
//userID: "",
//whichitid: "",
//collectionid: "",
//campaignid: "",
//placementid: """, @"", @""};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInteractiveHTML];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) getJSObjectFieldsForEvent: (NSString *) eventName{
    
    NSDictionary *serverObjectFieldMapping = @{
                                               @"whichitView" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", nil],
                                               @"whichitVote" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"frameIndex", @"frameID", nil],
                                               @"whichitShare" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"network", nil],
                                               @"whichitCTAClick" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"ctaLink", @"engageCardID", @"engageCardType", nil],
                                               @"whichitCollectionStarted" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"collectionid", @"campaignid", @"placementid", nil],
                                               @"whichitCollectionFinished" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"collectionid", @"campaignid", @"placementid", nil],
                                               @"whichitEngageCardView" : [NSArray arrayWithObjects:@"fromSite", @"vessel", @"userID", @"whichitid", @"collectionid", @"campaignid", @"placementid", @"engageCardID", @"engageCardType", nil]
                                              };
    
    return [serverObjectFieldMapping valueForKey:eventName];
    
}

- (NSString *) getUserIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (void) loadInteractiveHTML {
    
    //read idfa
    NSString *idfaString = [self getUserIDFA];
    
    //html path
    NSString *wrapperPath = [[NSBundle mainBundle] pathForResource:@"wh_sdk" ofType:@"html"];
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"Content_1" ofType:@"html"];
    
    //build wrapper
    NSMutableString *rawHTML = [NSMutableString stringWithContentsOfFile:wrapperPath encoding:NSUTF8StringEncoding error:NULL];
    NSString *htmlTemplate = [rawHTML stringByReplacingOccurrencesOfString:USER_UNIQUE_ID withString:idfaString];
    NSString *contentHTML = [NSMutableString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:NULL];
    NSString *pageHTML = [htmlTemplate stringByReplacingOccurrencesOfString:CONTENT_EMBED_CODE withString:contentHTML];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    [theConfiguration.userContentController addScriptMessageHandler:self name:@"jsObj"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:theConfiguration];
    
    [self.webView loadHTMLString:pageHTML baseURL:nil];
    
    [self.view addSubview:self.webView];
    
    lblResult = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200)];
    
}

- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSError *jsonError;
    NSData *jsonObjectData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDataDictionary = [NSJSONSerialization JSONObjectWithData:jsonObjectData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&jsonError];
    
    NSDictionary *eventObjectData = jsonDataDictionary[@"whichitEventObject"];
    NSArray *fieldsForEvents = [self getJSObjectFieldsForEvent:[eventObjectData valueForKey:@"name"]];
    
    result = [[NSMutableDictionary alloc] init];
    [result setValue:[eventObjectData valueForKey:@"name"] forKey:@"name"];
    
    for(NSString *field in fieldsForEvents){
        [result setValue:[eventObjectData valueForKey:field] forKey:field];
    }
    
    NSLog(@"Result: %@, Keys: %@", result, [result allKeys]);
    
    lblResult.text = @"";
    lblResult.numberOfLines = 0;
    lblResult.textColor = [UIColor grayColor];
    lblResult.text = @"Result:\n";
    
    for (NSString *key in [result allKeys]){
        NSString *resText = [NSString stringWithFormat:@"%@:%@\n", key, [result valueForKey:key]];
        lblResult.text = [lblResult.text stringByAppendingString:resText];
    }
    
    [self.webView addSubview:lblResult];
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
