//
//  FlutterUnionPayPlugin.h
//  FlutterUnionPayPlugin
//
//  Created by luoshimei on 2021/6/30.
//

#import <Flutter/Flutter.h>

static FlutterBasicMessageChannel *messageChannel;

@interface FlutterUnionPayPlugin : NSObject<FlutterPlugin>
@property (nonatomic, strong) UIViewController *viewController;
@end
