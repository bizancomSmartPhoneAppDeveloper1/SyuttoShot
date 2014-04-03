//
//  ViewController.m
//  SyuttoShot
//
//  Created by bizan.com.mac09 on 2014/04/02.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //キャプチャセッションを作りスタートさせる
    //カメラデバイスを取得する
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //入力の初期化
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error]; //入力作成
    
    //ビデオデータ出力作成
    NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc]init];
    dataOutput.videoSettings = settings;
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //セッション作成
    self.session = [[AVCaptureSession alloc]init];
    [self.session addInput:deviceInput];
    [self.session addOutput:dataOutput];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;  //High?photo?
    
    AVCaptureConnection *videoConnection = NULL;
    
    //カメラの向きなどの設定
    [self.session beginConfiguration];
    
    for ( AVCaptureConnection *connection in [dataOutput connections]) {
        for ( AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
            }
        }
    }
    if ([videoConnection isVideoOrientationSupported]) {
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [self.session commitConfiguration];  //セッションの設定を確定する
    
    //セッションをスタートする
    [self.session startRunning];  //終了はstopRunning
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    
//    CVImageBufferRef buffer;
//    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    
//    CVPixelBufferLockBaseAddress(buffer, 0);
//    
//    uint8_t * base;
//    size_t width,height,bytesPerRow;
//    base = CVPixelBufferGetBaseAddress(buffer);
//    width = CVPixelBufferGetWidth(buffer);
//    height = CVPixelBufferGetHeight(buffer);
//    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
//    
//    CGColorSpaceRef colorSpace;
//    CGContextRef cgContext;
//    colorSpace = CGColorSpaceCreateDeviceRGB();
//    cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGColorSpaceRelease(colorSpace);
//    
//    
//    CGImageRef cgImage;
//    UIImage *image;
//    cgImage = CGBitmapContextCreateImage(cgContext);
//    image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationRight];
//    CGImageRelease(cgImage);
//    CGContextRelease(cgContext);
//    
//    
//    CVPixelBufferUnlockBaseAddress(buffer, 0);
//    
//    
//    _imageView.image = image;
//    

}




@end
