//
//  MXJSManager.h
//  WKWebViewDemo
//
//  Created by sunny on 2017/5/12.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

@protocol MXJSManagerDelegate <NSObject>
@optional
@end

@interface MXJSManager : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<MXJSManagerDelegate> delegate;
@property (nonatomic, weak) WKWebView *webView;

/**
 指定初始化方法
 
 @param delegate 代理
 @param vc 实现WebView的VC
 @return 返回自身实例
 */
- (instancetype)initWithDelegate:(id<MXJSManagerDelegate>)delegate vc:(NSViewController *)vc;

@end
