//
//  BLDrawerPesentation.h
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/20.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLPesentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController gestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;

@property (nonatomic, assign) UIRectEdge targetEdge;

@end
