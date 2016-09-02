//
//  MYConnectionViewController.m
//  MYDownLoadDemo
//
//  Created by reborn on 16/8/24.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "MYConnectionViewController.h"

@interface MYConnectionViewController ()

@property(nonatomic,strong)NSURLConnection *connection;   //连接对象
@property(nonatomic,strong)NSFileHandle    *writeHandle;  //用来写数据的文件句柄对象
@property(nonatomic,assign)long long       totalLength;   //文件的总长度
@property(nonatomic,assign)long long       currentLength; //当前已经写入的总大小

@property(nonatomic,strong) UIProgressView *myProgress;
@property(nonatomic,strong) UILabel        *progressDesLabel;
@end

@implementation MYConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NSURLConnection";

    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"sandbox:%@",NSHomeDirectory());
    
    _progressDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    _progressDesLabel.text = @"当前没有下载任务";
    [self.view addSubview:_progressDesLabel];
    
    _myProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 300, 300, 10)];
    _myProgress.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_myProgress];
    
    UIButton *downLoadtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadtButton.frame = CGRectMake(100, 400, 100, 50);
    [downLoadtButton setTitle:@"下载/暂停" forState:UIControlStateNormal];
    [downLoadtButton addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    downLoadtButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:downLoadtButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)ButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        // 1.URL
        NSURL* url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
        
        //2.请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-",self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //3.下载
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];

    } else {
        [self.connection cancel];
        self.connection = nil;
    }
}
#pragma mark - NSURLConnectionDataDelegate代理方法
/**
 *  请求失败时调用（请求超时、网络异常）
 *
 *  @param error      错误原因
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

/**
 *  1.接收到服务器的响应就会调用
 *
 *  @param response   响应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //文件路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [caches stringByAppendingString:response.suggestedFilename];
    
    // 创建一个空的文件到沙盒中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];

    // 创建一个用来写数据的文件句柄对象
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;
    
}

/**
 *  2.当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）
 *
 *  @param data       这次返回的数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    self.currentLength += data.length;
    
    self.myProgress.progress = (double)self.currentLength/self.totalLength;
    self.progressDesLabel.text = [NSString stringWithFormat:@"当前下载进度:%f",(double)self.currentLength / self.totalLength];

}

/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完成");
    
    self.currentLength = 0;
    self.totalLength = 0;
    
    //关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
}


// 简单操作
- (void)download
{
    // 创建URL
    NSURL* url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
    // 创建请求
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    // 发送请求去下载 (创建完conn对象后，会自动发起一个异步请求)
    [NSURLConnection connectionWithRequest:request delegate:self];
}

@end
