//
//  UIStatusBarManager+DBOSwizzle.m
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

@import UIKit;
@import ObjectiveC.runtime;

#import "DBOStatusBarHandler.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation UIStatusBarManager (DBOSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(handleTapAction:);
        SEL swizzledSelector = @selector(dbo_handleTapAction:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
            class_addMethod(class,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma clang diagnostic pop

- (void)dbo_handleTapAction:(id)arg1 {
    [DBOStatusBarHandler.shared handleStatusBarTap];
    [self dbo_handleTapAction:arg1];
}

@end


