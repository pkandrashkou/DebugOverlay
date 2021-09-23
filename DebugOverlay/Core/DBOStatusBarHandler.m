//
//  DBOStatusBarHandler.m
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

@import UIKit;
#import "DBOStatusBarHandler.h"

@interface DBOStatusBarHandler ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSNumber *numberOfTaps;

@end

@implementation DBOStatusBarHandler

+ (instancetype)shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)handleStatusBarTap {
    self.numberOfTaps = @(self.numberOfTaps.intValue + 1);

    if (self.timer) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block: ^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;

        if (strongSelf.numberOfTaps.intValue >= 2) {
            if (strongSelf.onTriggerAction) {
                strongSelf.onTriggerAction();
            }
        }

        [timer invalidate];
        strongSelf.timer = nil;
        strongSelf.numberOfTaps = @0;
    }];
}

@end
