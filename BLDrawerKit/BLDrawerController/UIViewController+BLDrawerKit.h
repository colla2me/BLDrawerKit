//
//  UIViewController+BLDrawerKit.h
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/22.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BLDrawerKit)

@property (nonatomic, strong, readonly) UIViewController *bl_drawerController;

- (void)setDrawerController:(UIViewController *)drawerController edgeForOpening:(UIRectEdge)edge;

- (void)openDrawerAnimated:(BOOL)animated completion:(void(^)(void))completion;

- (void)openDrawerSide:(UIRectEdge)edges animated:(BOOL)animated completion:(void(^)(void))completion;

@end
