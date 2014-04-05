//
//  ViewController.m
//  SyuttoShot
//
//  Created by bizan.com.mac09 on 2014/04/02.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@end

@implementation ViewController
{
    int time,aida,repeatcount;
    
    NSTimer *timer;
    NSTimer *timer2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    time = 0;
    repeatcount = 1;
    
    self.Btnflag = NO;
    self.Btnflag2 = NO;
    self.Btnflag3 = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"3-0_02_CUT" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.countdown = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureCamera];
}

//カメラの設定
-(BOOL)configureCamera{
    NSError *error;
    
    //セッションを作成
    if (self.session) {
        [self.session stopRunning];
        self.session = nil;
    }
    self.session = [[AVCaptureSession alloc]init];
    
    //入力デバイス
    AVCaptureDevice *captureDevice = nil;
    NSArray *devices = [AVCaptureDevice devices];
    
    //背面カメラを見つける
    for (AVCaptureDevice *device in devices) {
        if (device.position==AVCaptureDevicePositionBack)
        {
            captureDevice = device;
        }
    }
    //カメラが見つからなかった場合
        if (captureDevice == nil) {
            return  NO;
        }
        AVCaptureDeviceInput *deviceinput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
        if (error) {
            return NO;
        }
        //静止画出力を作成
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
        
        //プレビュー用レイヤ
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        previewLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:previewLayer];
    //セッションの設定
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    [self.session addInput:deviceinput];
    [self.session addOutput:self.stillImageOutput];
        
        //セッションの設定
        [self.session startRunning];
        
        return YES;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//カメラボタン押時
- (IBAction)startCamera:(id)sender {
    
    if (self.Btnflag2 == NO)
    {
        [self start];
    }
    else if (self.Btnflag2 == YES)
    {
        [self start2];
    }
    

//    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    
//    //静止画を撮影
//    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection
//                                                       completionHandler:^(CMSampleBufferRef
//                                                                           imageDataSampleBuffer,NSError *error)
//     {
//         //エラーの場合
//         if (error) {return;}
//         
//         NSData *imagedata = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//         //画像のデータからUIImageを作成
//         UIImage *image = [UIImage imageWithData:imagedata];
//         //フォトライブラリに保存
//         UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingImageWithError:contetInfo:), nil);
//     }];
}
//フォトライブラリ保存時に呼ばれるメソッド
-(void)image:(UIImage *)image didFinishSavingImageWithError:(NSError *)error contetInfo:(void *)contextinfo
{
    //エラーがあればメッセージ表示
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"エラー" message:@"写真の保存に失敗した" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
}


- (IBAction)tapMenuBtn:(UIButton *)sender {
    
    switch (sender.tag)
    {
        case 0:
            if (self.Btnflag == NO)
            {
                [UILabel beginAnimations:nil context:nil];
                [UILabel setAnimationDuration:0.2];
                self.syuttoView.center = CGPointMake(115, 64);
                [UILabel commitAnimations];
                
                self.Btnflag = YES;
            }
            else if (self.Btnflag == YES)
            {
                [UILabel beginAnimations:nil context:nil];
                [UILabel setAnimationDuration:0.2];
                self.syuttoView.center = CGPointMake(-20, 64);
                [UILabel commitAnimations];
                
                self.Btnflag = NO;
            }
            break;
        case 1:
            if (self.Btnflag2 == NO)
            {
                [self.secondBtn setTitle:@"10秒" forState:UIControlStateNormal];
                
                self.Btnflag2 = YES;
            }
            else if (self.Btnflag2 == YES)
            {
                [self.secondBtn setTitle:@"4秒" forState:UIControlStateNormal];
                
                self.Btnflag2 = NO;
            }
            break;
        case 2:
            if (self.Btnflag3 == 0)
            {
                [self.repeatBtn setTitle:@"1回" forState:UIControlStateNormal];
                
                repeatcount = 2;
                
                self.Btnflag3 = 1;
            }
            else if (self.Btnflag3 == 1)
            {
                [self.repeatBtn setTitle:@"2回" forState:UIControlStateNormal];
                
                repeatcount = 3;
                
                self.Btnflag3 = 2;
            }
            else if (self.Btnflag3 == 2)
            {
                [self.repeatBtn setTitle:@"なし" forState:UIControlStateNormal];
                
                repeatcount = 1;
                
                self.Btnflag3 = 0;
            }
            break;
        default:
            break;
    }

}


-(void)start
{
    [self.countdown play];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(count)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)start2
{
    [self performSelector:@selector(start) withObject:nil afterDelay:5];
}

-(void)count
{
    time++;
    
    if (time == 4)
    {
        [self camera];
        [timer invalidate];
        
    }
}



-(void)camera
{
    
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //静止画を撮影
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                       completionHandler:^(CMSampleBufferRef
                                                                           imageDataSampleBuffer,NSError *error)
     {
         //エラーの場合
         if (error) {return;}
         
         NSData *imagedata = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         //画像のデータからUIImageを作成
         UIImage *image = [UIImage imageWithData:imagedata];
         //フォトライブラリに保存
         UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingImageWithError:contetInfo:), nil);
     }];
    
    time = 0;
    aida = 0;
    repeatcount--;
    
    if (repeatcount > 0)
    {
        [self onemore];
    }
    else if (repeatcount == 0 && self.Btnflag3 == 0)
    {
        repeatcount = 1;
    }
    else if (repeatcount == 0 && self.Btnflag3 == 1)
    {
        repeatcount = 2;
    }
    else if (repeatcount == 0 && self.Btnflag3 == 2)
    {
        repeatcount = 3;
    }
}

-(void)onemore
{
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(count2)
                                            userInfo:nil repeats:YES];
}

-(void)count2
{
    aida++;
    
    if (aida == 2)
    {
        [self start];
        [timer2 invalidate];
        
    }
}
@end
