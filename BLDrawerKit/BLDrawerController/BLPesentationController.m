//
//  BLDrawerPesentation.m
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/20.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "BLPesentationController.h"
#import "BLDrawerInteractiveTransition.h"
#import "BLPanGestureRecognizer.h"

@interface BLPesentationController () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) BLDrawerInteractiveTransition *interactiveTransiton;
@end

@implementation BLPesentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController gestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    NSParameterAssert(gestureRecognizer && [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]);
    self = [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        self.targetEdge = gestureRecognizer.edges;
        self.interactiveTransiton = [[BLDrawerInteractiveTransition alloc] initWithGestureRecognizer:gestureRecognizer edgeForDragging:_targetEdge openDrawer:YES];
    }
    return self;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        _targetEdge = UIRectEdgeLeft;
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.interactiveTransiton = [[BLDrawerInteractiveTransition alloc] initWithGestureRecognizer:sender edgeForDragging:_targetEdge openDrawer:NO];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else if (sender.state == UIGestureRecognizerStateChanged) {/* do nothing */}
    else {
        self.interactiveTransiton = nil;
    }
}

- (void)presentationTransitionWillBegin
{
    UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.opaque = NO;
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:dimmingView];
    self.dimmingView = dimmingView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
    [dimmingView addGestureRecognizer:tapGesture];
    
    BLPanGestureRecognizer *panGesture = [[BLPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:) edgeForDragging:_targetEdge];
    [self.containerView addGestureRecognizer:panGesture];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.5f;
    } completion:NULL];
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed) {
        self.dimmingView = nil;
    }
    self.interactiveTransiton = nil;
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {
        self.interactiveTransiton = nil;
        self.dimmingView = nil;
    }
}

#pragma mark -
#pragma mark Layout

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.width = presentedViewContentSize.width;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    return presentedViewControllerFrame;
}

- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}

#pragma mark -
#pragma mark Tap Gesture Recognizer

- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.3 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGSize containerSize = containerView.bounds.size;
    CGPoint offset = CGPointZero;
    switch (_targetEdge) {
        case UIRectEdgeTop:
            offset.y = isPresenting ? -toViewFinalFrame.size.height : -fromViewFinalFrame.size.height;
            break;
        case UIRectEdgeBottom:
            offset.y = isPresenting ? containerSize.height : fromViewFinalFrame.size.height;
            break;
        case UIRectEdgeLeft:
            offset.x = isPresenting ? -toViewFinalFrame.size.width : -fromViewFinalFrame.size.width;
            break;
        case UIRectEdgeRight:
            offset.x = isPresenting ? containerSize.width : fromViewFinalFrame.size.width;
            break;
        default:
            break;
    }
    
    if (isPresenting) {
        toView.frame = CGRectOffset(toViewFinalFrame, offset.x, offset.y);
        if (UIRectEdgeRight == _targetEdge) {
            toViewFinalFrame.origin.x = containerSize.width - toViewFinalFrame.size.width;
        } else if (UIRectEdgeBottom == _targetEdge) {
            toViewFinalFrame.origin.y = containerSize.height - toViewFinalFrame.size.height;
        }
        
        [containerView addSubview:toView];
    } else {
        fromViewFinalFrame = CGRectOffset(fromViewFinalFrame, offset.x, offset.y);
    }

    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toViewFinalFrame;
        } else {
            fromView.frame = fromViewFinalFrame;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransiton;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransiton;
}

@end
