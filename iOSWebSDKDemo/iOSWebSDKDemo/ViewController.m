//
//  ViewController.m
//  iOSWebSDKDemo
//
//  Created by Aashay Shah on 12/05/2017.
//  Copyright © 2017 Aashay Shah. All rights reserved.
//

#import "ViewController.h"
#import <AdSupport/AdSupport.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.topItem.title = @"iOS WebSDK Demo";
    
    contentViewController = [[WebViewController alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadEmbeddedHTML {
    
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, self.view.bounds.size.height - 100)];
    myWebView.layer.borderWidth = 1.0f;
    myWebView.layer.borderColor = [[UIColor redColor] CGColor];
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"wh_sdk" ofType:@"html"];
    NSString *indexPath = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:NULL];
    [myWebView loadHTMLString:indexPath baseURL:nil];
    [self.view addSubview:myWebView];
}


- (IBAction)viewContent1:(id)sender {
    [self presentContentView:@"Content 1"];
}

- (IBAction)viewContent2:(id)sender {
    [self presentContentView:@"Content 2"];
}

- (IBAction)viewContent3:(id)sender {
    [self presentContentView:@"Content 3"];
}


- (void) presentContentView:(NSString *)contentName {

    contentViewController.titleString = contentName;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController pushViewController:contentViewController animated:YES];
    
}

@end
