//
//  MYSessionViewController.m
//  MYDownLoadDemo
//
//  Created by reborn on 16/8/24.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "MYSessionViewController.h"

@interface MYSessionViewController ()<NSURLSessionDownloadDelegate>
@property(nonatomic, strong) NSURLSessionDownloadTask *downLoadTask;  //下载任务
@property(nonatomic, strong) NSData                   *resumeData;    //记录下载位置
@property(nonatomic, strong) NSURLSession             *session;       //session

@property(nonatomic, strong) UIProgressView           *myProgress;
@property(nonatomic, strong) UILabel                  *progressDesLabel;

@end

@implementation MYSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NSURLSession";
    
    self.view.backgroundColor = [UIColor whiteColor];

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
    
    if (self.downLoadTask == nil) {
    
        if (self.resumeData) {
            //继续下载
            [self resume];
        } else {
            //从0开始下载
            [self startDownload];
        }
    } else {
        //暂停
        [self pause];
    }
}

/*
 *  从0开始下载
 */
-(void)startDownload
{
    NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
    
    //创建任务
    self.downLoadTask = [self.session downloadTaskWithURL:url];
    [self.downLoadTask resume];
}

/*
 * 恢复下载
 */
- (void)resume
{
    // 传入上次暂停下载返回的数据，就可以恢复下载
    self.downLoadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.downLoadTask resume]; //开始任务
    self.resumeData = nil;
}

/*
 *暂停
 */
- (void)pause
{
    __weak typeof(self) weakSelf = self;
    [self.downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        //resumeData：包含了继续下载的开始位置\下载的url
        weakSelf.resumeData = resumeData;
        weakSelf.downLoadTask = nil;
    }];
    
}

#pragma mark -- NSURLSessionDownloadDelegate
/**
 * 下载完毕会调用
 *
 * @param location     文件临时地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    // response.suggestedFilename:建议使用的文件名，一般跟服务器端的文件名一致
    NSString *filePath = [cache stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //将临时文件剪切或复制到Caches文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径 ,ToPath : 剪切后的文件路径
    [fileManager moveItemAtPath:location.path toPath:filePath error:nil];
    
    NSLog(@"下载完成");
    
}

/**
 *  执行下载任务时有数据写入
 *  在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
 *
 *  @param bytesWritten              这次写入的大小
 *  @param totalBytesWritten         已经写入的大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.myProgress.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
    self.progressDesLabel.text = [NSString stringWithFormat:@"下载进度%f:",(double)totalBytesWritten/totalBytesExpectedToWrite];
}


/*
 * 恢复下载后调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

/**
 *  Sesstion 简单执行下载
 */
- (void)SesstionDownLoad
{
    NSURL* url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
    
    // 得到session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //创建任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // location : 临时文件的路径（下载好的文件）
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
        
        // 将临时文件剪切或者复制Caches文件夹
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // AtPath : 剪切前的文件路径
        // ToPath : 剪切后的文件路径
        [mgr moveItemAtPath:location.path toPath:file error:nil];
    }];
    
     // 开始任务
    [downloadTask resume];
}

/**
 *  NSURLSession简单使用
 */
- (void)sessiondemo
{
    // 1.得到session对象
    NSURLSession* session = [NSURLSession sharedSession];
    NSURL* url = [NSURL URLWithString:@""];
    
    // 2.创建一个task，任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //data返回数据
    }];
    
    //    [session dataTaskWithRequest:<#(NSURLRequest *)#> completionHandler:<#^(NSData *data, NSURLResponse *response, NSError *error)completionHandler#>]
    
    //3.开始任务
    [dataTask resume];
    
    
}

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
