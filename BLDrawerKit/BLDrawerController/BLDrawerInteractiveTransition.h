//
//  BLDrawerInteractiveTransition.h
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLDrawerInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge openDrawer:(BOOL)open;

@end
