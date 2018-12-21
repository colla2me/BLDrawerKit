//
//  BLPanGestureRecognizer.m
//  FBLiveDemo
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "BLPanGestureRecognizer.h"

@implementation BLPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action edgeForDragging:(UIRectEdge)edge {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.maximumNumberOfTouches = 1;
        self.delegate = self;
        _edges = edge;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    BOOL isLeftToRight = _edges == UIRectEdgeLeft;
    CGFloat xOffset = isLeftToRight ? 44 : -44;
    CGFloat threshold = window.bounds.size.width * 0.5 + xOffset;
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (_edges == UIRectEdgeLeft && beginningLocation.x > threshold) {
        return NO;
    } else if (_edges == UIRectEdgeRight && beginningLocation.x < threshold) {
        return NO;
    }
    
    CGPoint translation = [self translationInView:gestureRecognizer.view];
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end
