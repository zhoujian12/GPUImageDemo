//
//  UIView+position.m
//  ZJKits
//
//  Created by jianz3 on 2017/7/25.
//  Copyright © 2017年 jianz3. All rights reserved.
//

#import "UIView+position.h"

@implementation UIView (position)

#pragma mark - view + frame

#pragma mark - leading
- (CGFloat)frameLeading {
    return self.frame.origin.x;
}

- (void)setFrameLeading:(CGFloat)frameLeading {
    CGRect frame = self.frame;
    frame.origin.x = frameLeading;
    self.frame = frame;
}

#pragma mark - trailing
- (CGFloat)frameTrailing{
    return self.frameLeading + self.frameWidth;
}

- (void)setFrameTrailing:(CGFloat)frameTrailing{
    self.frameLeading = frameTrailing - self.frameWidth;
}

#pragma mark - top
- (CGFloat)frameTop {
    return self.frame.origin.y;
}

- (void)setFrameTop:(CGFloat)frameTop{
    CGRect frame = self.frame;
    frame.origin.y = frameTop;
    self.frame = frame;
}

#pragma mark - bottom
- (CGFloat)frameBottom{
    return self.frameTop + self.frameHeight;
}

- (void)setFrameBottom:(CGFloat)frameBottom{
    self.frameTop = frameBottom - self.frameHeight;
}

#pragma mark - frameWidth
- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    CGRect frame = self.frame;
    frame.size.width = frameWidth;
    self.frame = frame;
}

#pragma mark - frameHeight
- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    CGRect frame = self.frame;
    frame.size.height = frameHeight;
    self.frame = frame;
}

#pragma mark - frameOrigin
- (CGPoint)frameOrigin{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin{
    CGRect frame = self.frame;
    frame.origin = frameOrigin;
    self.frame   = frame;
}

#pragma mark - frameSize
- (CGSize)frameSize{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize{
    CGRect frame = self.frame;
    frame.size   = frameSize;
    self.frame   = frame;
}

#pragma mark .frame.origin in Window
- (CGPoint)frameOriginInWindow{
    CGPoint origin = self.frameOrigin;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *superView = self.superview;
    while (superView && ![superView isEqual:window]) {
        origin.x += superView.frameOrigin.x;
        origin.y += superView.frameOrigin.y;
        if ([superView isKindOfClass:[UIScrollView class]]) {
            CGPoint contentOffset = ((UIScrollView *)superView).contentOffset;
            origin.x -= contentOffset.x;
            origin.y -= contentOffset.y;
        }
    }
    return origin;
}

#pragma mark center
- (CGFloat)frameCenterX{
    return self.center.x;
}

- (void)setFrameCenterX:(CGFloat)frameCenterX{
    CGPoint center = self.center;
    center.x       = frameCenterX;
    self.center    = center;
}

- (CGFloat)frameCenterY{
    return self.center.y;
}

- (void)setFrameCenterY:(CGFloat)frameCenterY{
    CGPoint center = self.center;
    center.y       = frameCenterY;
    self.center    = center;
}
@end
