//
//  BLDrawerInteractiveTransition.m
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "BLDrawerInteractiveTransition.h"

@interface BLDrawerInteractiveTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;
@property (nonatomic, readonly) BOOL open;

@end

@implementation BLDrawerInteractiveTransition

- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:edgeForDragging:" userInfo:nil];
}

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge openDrawer:(BOOL)open {
    NSAssert(edge == UIRectEdgeTop || edge == UIRectEdgeBottom ||
             edge == UIRectEdgeLeft || edge == UIRectEdgeRight,
             @"edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        _open = open;
        
        // Add self as an observer of the gesture recognizer so that this
        // object receives updates as the user moves their finger.
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Save the transitionContext for later.
    self.transitionContext = transitionContext;
    
    [super startInteractiveTransition:transitionContext];
}

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    // self.transitionContext.containerView
    UIView *transitionContainerView = gesture.view;
    
    CGPoint translation = [gesture translationInView:transitionContainerView];

    // Figure out what percentage we've gone.
    CGFloat percent = 0.f, width = 0.f, height = 0.f;
    
    switch (_edge) {
        case UIRectEdgeRight:
        case UIRectEdgeLeft:
            if (_open) {
                UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
                width = CGRectGetWidth(toView.frame);
            } else {
                UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
                width = CGRectGetWidth(fromView.frame);
            }
            percent = ABS(translation.x) / MAX(width, 1.0);
            break;
        case UIRectEdgeBottom:
        case UIRectEdgeTop:
            if (_open) {
                UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
                height = CGRectGetHeight(toView.frame);
            } else {
                UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
                height = CGRectGetHeight(fromView.frame);
            }
            percent = ABS(translation.y) / MAX(height, 1.0);
            break;
        default:
            percent = 0.f;
            break;
    }
    
    return MIN(1.0, percent);
}

- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            // The Began state is handled by the view controllers.  In response
            // to the gesture recognizer transitioning to this state, they
            // will trigger the presentation or dismissal.
            break;
        case UIGestureRecognizerStateChanged:
            // We have been dragging! Update the transition context accordingly.
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            break;
        case UIGestureRecognizerStateEnded: {
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            CGFloat threshold = _open ? 0.25 : 0.5;
            if ([self percentForGesture:gestureRecognizer] >= threshold)
                [self finishInteractiveTransition];
            else
                [self cancelInteractiveTransition];
            break;
        }
        default:
            // Something happened. cancel the transition.
            [self cancelInteractiveTransition];
            break;
    }
}

@end
