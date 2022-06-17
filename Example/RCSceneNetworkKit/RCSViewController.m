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
//    [RCSNetworkConfig configWithBaseUrl:@""
//                         bussinessToken:@""];
//
//
//    [[RCSNetworkDataHandler new] sendCodeWithParams:@{ @"mobile": @"15811111112", @"region": @"+86"} completionBlock:^(RCSResponseModel * _Nonnull model) {
//        NSLog(@"%@", model.description);
//    }];
    

    [self downloadTest];
}

- (void)downloadTest {
    RCSNetworkConfig *config = [RCSNetworkConfig configWithUrl:@"http://vjs.zencdn.net/v/oceans.mp4"
                                                        method:RCSHTTPRequestMethodGET
                                                        params:nil];
    
    [[RCSNetworkDataHandler new] requestWithUrlConfig:config
                                         downloadPath:[NSString stringWithFormat:@"%@/22.mp4", [self documentsDirectoryPath]]
                                     downloadProgress:^(NSProgress * _Nonnull progress) {
        NSLog(@"----------%@",progress);
    } completion:^(RCSResponseModel * _Nonnull model) {
        NSURL *url = model.data;
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSLog(@"=====>%ld", data.length);
    }];
}

- (NSString *)documentsDirectoryPath {
    static NSString *documentDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    });
    return documentDirectory;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
