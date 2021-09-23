//
//  DBOOverlayWindow.h
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(OverlayTouchDelegate)
@protocol DBOOverlayTouchDelegate <NSObject>

@optional
- (BOOL)shouldHandleTouchAtPoint:(CGPoint)point;

@end

NS_SWIFT_NAME(OverlayWindow)
@interface DBOOverlayWindow : UIWindow

@property (nonatomic, nullable, weak) id<DBOOverlayTouchDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
