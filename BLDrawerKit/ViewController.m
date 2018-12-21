//
//  ViewController.m
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "ViewController.h"
#import "BLPesentationController.h"

@interface ViewController ()

@end

@implementation ViewController

+ (UIViewController *)viewController {
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [s instantiateViewControllerWithIdentifier:@"DrawerController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    interactiveTransitionRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

- (IBAction)openAction:(id)sender {
    [self showDrawerController:nil];
}

- (void)showDrawerController:(UIPanGestureRecognizer *)sender {
    UIViewController *vc = [ViewController viewController];
    BLPesentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[BLPesentationController alloc] initWithPresentedViewController:vc presentingViewController:self gestureRecognizer:sender];
    vc.transitioningDelegate = presentationController;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showDrawerController:sender];
    }
}

@end
