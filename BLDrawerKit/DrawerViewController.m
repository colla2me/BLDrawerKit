//
//  DrawerViewController.m
//  BLDrawerKit
//
//  Created by Samuel on 2018/12/21.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * 0.6, CGRectGetHeight(self.view.bounds));
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
