//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by sunny on 2017/5/11.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ViewController.h"

@interface ViewController ()<WKNavigationDelegate>
@property (weak) IBOutlet WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://www.moxtra.com/service3/#timeline"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.navigationDelegate = self;
}




@end
