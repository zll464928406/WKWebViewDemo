//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by sunny on 2017/5/11.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "ViewController.h"
#import "MXJSManager.h"

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,MXJSManagerDelegate>

@property (nonatomic, strong) WKWebView *webView;;
@property (nonatomic, strong) MXJSManager *jsHelper;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jsHelper = [[MXJSManager alloc] initWithDelegate:self vc:self];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    // 交互对象设置
    [configuration.userContentController addScriptMessageHandler:self.jsHelper name:@"timefor"];
    WKPreferences *preferences = [WKPreferences new];
    //很重要，如果没有设置这个则不会回调createWebViewWithConfiguration方法，也不会回应window.open()方法
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.jsHelper.webView = self.webView;
    
    NSURL *url = [NSURL URLWithString:@"https://www.moxtra.com/service3/#timeline"];
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - WKNavigationDelegate

/** 每当加载一个请求之前会调用该方法，通过该方法决定是否允许或取消请求的发送 */
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);//进行跳转
    decisionHandler(WKNavigationActionPolicyCancel);//不进行跳转
}

/** 当开始发送请求时调用 */
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{}

/** 当请求过程中出现错误时调用 */
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{}

/** 当开始发送请求时出错调用 */
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{}

/** 每当接收到服务器返回的数据时调用，通过该方法可以决定是否允许或取消导航 */
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);//允许响应
}

/** 当网页加载完毕时调用：该方法使用最频繁 . 可以在这个方法执行JS代码 */
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinishNavigation   ====    %@", navigation);
}

// 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([challenge previousFailureCount] == 0)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else
        {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - WKUIDelegate

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    /*
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
     */
    
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {}

//打开新窗口的时候调用
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    WKWebView *newWebView = [[WKWebView alloc] initWithFrame:self.webView.frame configuration:configuration];
    [webView loadRequest:navigationAction.request];
    return newWebView;
    
    NSLog(@"createWebViewWithConfiguration  request     %@",navigationAction.request);
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

@end
