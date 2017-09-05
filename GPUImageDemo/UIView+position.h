//
//  UIView+position.h
//  ZJKits
//
//  Created by jianz3 on 2017/7/25.
//  Copyright © 2017年 jianz3. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (position)

// view + frame
@property (nonatomic) CGFloat frameLeading;  ///< .frame.origin.x
@property (nonatomic) CGFloat frameTrailing; ///< .frameLeading + .frameWidth
@property (nonatomic) CGFloat frameTop;      ///< .frame.origin.x
@property (nonatomic) CGFloat frameBottom;   ///< .frameTop + .frameHeight
@property (nonatomic) CGFloat frameWidth;    ///< .frame.size.width
@property (nonatomic) CGFloat frameHeight;   ///< .frame.size.height
@property (nonatomic) CGPoint frameOrigin;   ///< .frame.origin
@property (nonatomic) CGSize  frameSize;     ///< .frame.size

@property (nonatomic, readonly) CGPoint frameOriginInWindow; ///< .frame.origin in Window
#pragma mark center
@property (nonatomic) CGFloat frameCenterX;  ///< .center.x
@property (nonatomic) CGFloat frameCenterY;  ///< .center.y

@end
NS_ASSUME_NONNULL_END
