//
//  ViewController.m
//  MYDownLoadDemo
//
//  Created by reborn on 16/8/24.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "ViewController.h"
#import "MYSessionViewController.h"
#import "MYConnectionViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"sandbox:%@",NSHomeDirectory());
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    UIButton *sessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sessionButton.frame = CGRectMake(40, 350, 100, 30);
    sessionButton.backgroundColor = [UIColor orangeColor];
    sessionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [sessionButton setTitle:@"NSURLSession" forState:UIControlStateNormal];
    [sessionButton addTarget:self action:@selector(sessionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sessionButton];
    
    
    UIButton *connectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    connectionButton.frame = CGRectMake(sessionButton.frame.origin.x + 120, 350, 110, 30);
    connectionButton.backgroundColor = [UIColor orangeColor];
    connectionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [connectionButton setTitle:@"NSURLConnection" forState:UIControlStateNormal];
    [connectionButton addTarget:self action:@selector(connectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:connectionButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sessionButtonClick:(id)sender
{
    MYSessionViewController *mySessionViewController = [[MYSessionViewController alloc] init];

    [self.navigationController pushViewController:mySessionViewController animated:YES];
}

- (void)connectionButtonClick:(id)sender
{
    MYConnectionViewController *myConnectionViewController = [[MYConnectionViewController alloc] init];
    [self.navigationController pushViewController:myConnectionViewController animated:YES];
}

@end
