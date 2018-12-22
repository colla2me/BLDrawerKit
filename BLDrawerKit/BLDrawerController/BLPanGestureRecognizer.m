//
//  BLPanGestureRecognizer.m
//  BLDrawerKit
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
    if (!(_edges == UIRectEdgeLeft || _edges == UIRectEdgeRight)) return NO;
    
    BOOL isEdgeLeft = _edges == UIRectEdgeLeft;
    CGPoint translation = [self translationInView:gestureRecognizer.view];
    CGFloat multiplier = isEdgeLeft ? -1 : 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end
