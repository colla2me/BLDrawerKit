//
//  ViewController.m
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "ViewController.h"
//#import "BLPesentationController.h"
#import "UIViewController+BLDrawerKit.h"

@interface ViewController ()

@end

@implementation ViewController

+ (UIViewController *)viewController {
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [s instantiateViewControllerWithIdentifier:@"DrawerController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDrawerController:[ViewController viewController] edgeForOpening:UIRectEdgeRight];
}

- (IBAction)openLeftAction:(id)sender {
    [self openDrawerSide:UIRectEdgeTop animated:YES completion:^{
        
    }];
}

- (IBAction)openRightAction:(id)sender {
    [self openDrawerSide:UIRectEdgeBottom animated:YES completion:^{
        
    }];
}

@end
