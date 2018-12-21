//
//  BLDrawerInteractiveTransition.m
//  FBLiveDemo
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "BLDrawerInteractiveTransition.h"

@interface BLDrawerInteractiveTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;

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

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge {
    NSAssert(edge == UIRectEdgeTop || edge == UIRectEdgeBottom ||
             edge == UIRectEdgeLeft || edge == UIRectEdgeRight,
             @"edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        
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
    // Because view controllers will be sliding on and off screen as part
    // of the animation, we want to base our calculations in the coordinate
    // space of the view that will not be moving: the containerView of the
    // transition context.
    UIView *transitionContainerView = self.transitionContext.containerView;
    
    CGPoint locationInSourceView = [gesture locationInView:transitionContainerView];
    
    // Figure out what percentage we've gone.
    
    CGFloat width = CGRectGetWidth(transitionContainerView.bounds);
    CGFloat height = CGRectGetHeight(transitionContainerView.bounds);
    
    // Return an appropriate percentage based on which edge we're dragging
    // from.
    if (self.edge == UIRectEdgeRight)
        return (width - locationInSourceView.x) / width;
    else if (self.edge == UIRectEdgeLeft)
        return locationInSourceView.x / width;
    else if (self.edge == UIRectEdgeBottom)
        return (height - locationInSourceView.y) / height;
    else if (self.edge == UIRectEdgeTop)
        return locationInSourceView.y / height;
    else
        return 0.f;
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
        case UIGestureRecognizerStateEnded:
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            if ([self percentForGesture:gestureRecognizer] >= 0.5f)
                [self finishInteractiveTransition];
            else
                [self cancelInteractiveTransition];
            break;
        default:
            // Something happened. cancel the transition.
            [self cancelInteractiveTransition];
            break;
    }
}

@end
