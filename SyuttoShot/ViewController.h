//
//  ViewController.h
//  SyuttoShot
//
//  Created by bizan.com.mac09 on 2014/04/02.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//追加したフレームワーク　AVFoundation.framework CoreVideo.framework CoreMedia.framework QuartzCore.framework MobileCoreService.framework

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
