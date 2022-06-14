//
//  RCSViewController.m
//  RCSceneNetworkKit
//
//  Created by 彭蕾 on 06/14/2022.
//  Copyright (c) 2022 彭蕾. All rights reserved.
//

#import "RCSViewController.h"
#import <RCSceneNetworkKit/RCSNetworkKit.h>
#import "RCSNetworkDataHandler+Login.h"

@interface RCSViewController ()

@end

@implementation RCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [RCSNetworkConfig configWithBaseUrl:@""
                         bussinessToken:@""];
    
    
    [[RCSNetworkDataHandler new] sendCodeWithParams:@{ @"mobile": @"15811111112", @"region": @"+86"} completionBlock:^(RCSResponseModel * _Nonnull model) {
        NSLog(@"%@", model.description);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
