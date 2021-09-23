//
//  DBOStatusBarHandler.h
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(StatusBarHandler)
@interface DBOStatusBarHandler : NSObject

@property (nonatomic, copy, nullable) void (^onTriggerAction)(void);
@property (class, nonatomic, strong, readonly) DBOStatusBarHandler *shared;

- (void)handleStatusBarTap;

@end

NS_ASSUME_NONNULL_END
