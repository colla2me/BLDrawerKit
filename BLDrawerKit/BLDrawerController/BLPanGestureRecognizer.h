//
//  BLPanGestureRecognizer.h
//  FBLiveDemo
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

- (instancetype)initWithTarget:(id)target action:(SEL)action edgeForDragging:(UIRectEdge)edge;

@property (nonatomic, assign, readonly) UIRectEdge edges;

@end
