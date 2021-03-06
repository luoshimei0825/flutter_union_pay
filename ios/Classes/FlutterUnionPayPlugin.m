//
//  FlutterUnionPayPlugin.m
//  FlutterUnionPayPlugin
//
//  Created by luoshimei on 2021/6/30.
//

#import "FlutterUnionPayPlugin.h"
#import "UPPaymentControl.h"

static NSString *methodChannelName = @"flutter_union_pay";
static NSString *messageChannelName = @"flutter_union_pay.message";

@implementation FlutterUnionPayPlugin

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _viewController = viewController;
    }
    return self;
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:methodChannelName
                                                                binaryMessenger:[registrar messenger]];
    messageChannel = [FlutterBasicMessageChannel messageChannelWithName:messageChannelName
                                                        binaryMessenger:[registrar messenger]
                                                                  codec:[FlutterStringCodec sharedInstance]];

    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterUnionPayPlugin *instance = [[FlutterUnionPayPlugin alloc] initWithViewController:viewController];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"pay" isEqualToString:call.method]) {
        [self pay:call result:result];
    } else if([@"isPaymentAppInstalled" isEqualToString:call.method]){
        [self isPaymentAppInstalled:call result:result];
    } else if([@"version" isEqualToString:call.method]) {
        [self getVersion:call result:result];
    }  else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)pay:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *tn = call.arguments[@"tn"];
    NSString *mode = call.arguments[@"mode"];
    NSString *scheme = call.arguments[@"scheme"];
    BOOL ret = [[UPPaymentControl defaultControl] startPay:tn
                                                fromScheme:scheme
                                                      mode:mode
                                            viewController:self.viewController];
    result([NSNumber numberWithBool:ret]);
}

- (void)isPaymentAppInstalled:(FlutterMethodCall *)call result:(FlutterResult)result {
    BOOL ret = [[UPPaymentControl defaultControl] isPaymentAppInstalled];
    result([NSNumber numberWithBool:ret]);
}

- (void)getVersion:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *version = @"v3.3.14";
    result(version);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    // - (void)handlePaymentResult:(NSURL*)url completeBlock:(UPPaymentResultBlock)completionBlock;
    // ??????1: url????????????????????????handlePaymentResult: completeBlock:????????????url?????????
    // ??????2: completionBlock?????????APP?????????????????????????????????????????????????????? code???data???
    // ??????code??????????????????????????????suceess???fail???cancel?????????????????? ???????????????????????????????????????
    // data??????????????????????????????????????????
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        if([code isEqualToString:@"success"]) {
            [payload setValue:[NSNumber numberWithInt:1] forKey:@"status"];
        }
        else if([code isEqualToString:@"fail"]) {
            [payload setValue:[NSNumber numberWithInt:2] forKey:@"status"];
        }
        else if([code isEqualToString:@"cancel"]) {
            [payload setValue:[NSNumber numberWithInt:0] forKey:@"status"];
        }
        
        NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload
                                                              options:NSJSONWritingPrettyPrinted
                                                                error:nil];
        NSString *json = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
        
        [messageChannel sendMessage:json reply:^(id  _Nullable reply) {
            NSLog(@"%@", reply);
        }];
    }];

    return YES;
}

@end
