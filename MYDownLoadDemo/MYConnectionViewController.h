//
//  MYConnectionViewController.h
//  MYDownLoadDemo
//
//  Created by reborn on 16/8/24.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYConnectionViewController : UIViewController

/*
 * 1.NSURLSession
 *   不需要手动写入沙盒
 *
 *  @NSURLSession也是一组相互依赖的类,它的大部分组件和NSURLConnection中的组件相同如 NSURLRequest,NSURLCache等。而NSURLSession的不同之处在于,它将 NSURLConnection替换为NSURLSession和NSURLSessionConfiguration,以及3个NSURLSessionTask的子类: NSURLSessionDataTask, NSURLSessionUploadTask, 和NSURLSessionDownloadTask。
 
 *  @NSURLSessionTask类
 *
 *  NSURLSessionTask是一个抽象子类,它有三个子类:NSURLSessionDataTask, NSURLSessionUploadTask和NSURLSessionDownloadTask。这三个类封装了现代应用程序的三个基 本网络任务:获取数据,比如JSON或XML,以及上传和下载文件。
 *
 *
 * 2.NSURLConnection
 *   需手动写入沙盒
 *
 *  @NSURLConnection这个名字,实际上指的是一组构成Foundation框架中URL加载系统的相互关联的 组件:NSURLRequest,NSURLResponse,NSURLProtocol,NSURLCache,
 *
 */

@end
