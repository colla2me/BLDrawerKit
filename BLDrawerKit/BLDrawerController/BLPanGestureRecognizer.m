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
    if (UIRectEdgeNone == _edges || UIRectEdgeAll == _edges) return NO;
    
    CGPoint translation = [self translationInView:gestureRecognizer.view];
    CGFloat multiplier = (_edges == UIRectEdgeLeft || _edges == UIRectEdgeTop) ? -1 : 1;
    
    BOOL shouldBegin = YES;
    switch (_edges) {
        case UIRectEdgeLeft:
        case UIRectEdgeRight:
            if ((translation.x * multiplier) <= 0) {
                shouldBegin = NO;
            }
            break;
        case UIRectEdgeTop:
        case UIRectEdgeBottom:
            if ((translation.y * multiplier) <= 0) {
                shouldBegin = NO;
            }
            break;
        default:
            shouldBegin = NO;
            break;
    }
    
    return shouldBegin;
}

@end
