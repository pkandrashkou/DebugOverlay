//
//  DBOOverlayWindow.m
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

@import ObjectiveC.runtime;

#import "DBOOverlayWindow.h"

@implementation DBOOverlayWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Some apps have windows at UIWindowLevelStatusBar + n.
        // If we make the window level too high, we block out UIAlertViews.
        // There's a balance between staying above the app's windows and staying below alerts.
        // UIWindowLevelStatusBar + 100 seems to hit that balance.
        self.windowLevel = UIWindowLevelStatusBar + 100.0;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = NO;
    if (CGRectContainsPoint(UIApplication.sharedApplication.statusBarFrame, point)) {
        pointInside = YES;
    }

    // @optimization: we may want to check if delegate responds to selector only when delegate is assigned.
    if ([self.delegate respondsToSelector: @selector(shouldHandleTouchAtPoint:)]) {
        if ([self.delegate shouldHandleTouchAtPoint:point]) {
            pointInside = [super pointInside:point withEvent:event];
        }
    }

    return pointInside;
}

#pragma mark - Method Swizzling

- (BOOL)shouldAffectStatusBarAppearance {
    return [self isKeyWindow];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"_canAffectStatusBarAppearance");
        SEL swizzledSelector = @selector(shouldAffectStatusBarAppearance);

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

@end
