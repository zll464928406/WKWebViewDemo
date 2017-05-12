//
//  MXJSManager.m
//  WKWebViewDemo
//
//  Created by sunny on 2017/5/12.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "MXJSManager.h"

@interface MXJSManager()
@property (nonatomic, weak) NSViewController *vc;
@end

@implementation MXJSManager

- (instancetype)initWithDelegate:(id<MXJSManagerDelegate>)delegate vc:(NSViewController *)vc;
{
    if (self = [super init])
    {
        self.delegate = delegate;
        self.vc = vc;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@, %s", self.class, __func__);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:message.body];
    NSLog(@"JS交互参数：%@", dic);
    
    if ([message.name isEqualToString:@"timefor"] && [dic isKindOfClass:[NSDictionary class]])
    {
        
        NSLog(@"currentThread  ------   %@", [NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0001"])
            {
                NSString *js = [NSString stringWithFormat:@"globalCallback(\'%@\')", @"该设备的deviceId: *****"];
                [self.webView evaluateJavaScript:js completionHandler:nil];
            } else
            {
                return;
            }
        });
    }
    else
    {
        return;
    }
}


@end
