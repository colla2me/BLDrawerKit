//
//  UIViewController+BLDrawerKit.m
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/22.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "UIViewController+BLDrawerKit.h"
#import "BLPesentationController.h"
#import <objc/runtime.h>

static char kDrawerController;

@implementation UIViewController (BLDrawerKit)

- (UIViewController *)bl_drawerController {
    return objc_getAssociatedObject(self, &kDrawerController);
}

- (void)setDrawerController:(UIViewController *)drawerController edgeForOpening:(UIRectEdge)edge {
    objc_setAssociatedObject(self, &kDrawerController, drawerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    interactiveTransitionRecognizer.edges = edge;
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

- (void)openDrawerAnimated:(BOOL)animated completion:(void(^)(void))completion {
    [self openDrawerSide:UIRectEdgeLeft animated:animated completion:completion];
}

- (void)openDrawerSide:(UIRectEdge)edges animated:(BOOL)animated completion:(void(^)(void))completion {
    UIViewController *drawerController = self.bl_drawerController;
    NSParameterAssert(drawerController != nil);
    
    BLPesentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[BLPesentationController alloc] initWithPresentedViewController:drawerController presentingViewController:self];
    presentationController.targetEdge = edges;
    drawerController.transitioningDelegate = presentationController;
    [self presentViewController:drawerController animated:animated completion:completion];
}

- (void)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self openDrawerGesture:sender animated:YES completion:NULL];
    }
}

- (void)openDrawerGesture:(UIScreenEdgePanGestureRecognizer *)sender animated:(BOOL)animated completion:(void(^)(void))completion {
    UIViewController *drawerController = self.bl_drawerController;
    NSParameterAssert(drawerController != nil);
    
    BLPesentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[BLPesentationController alloc] initWithPresentedViewController:drawerController presentingViewController:self gestureRecognizer:sender];
    drawerController.transitioningDelegate = presentationController;
    [self presentViewController:drawerController animated:animated completion:completion];
}

@end
