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
    // test
	// Do any additional setup after loading the view, typically from a nib.
    
    time = 0; //タイマーの初期化
    repeatcount = 1; //リピート回数の初期化
    
    self.Btnflag = NO; //ボタンの初期化
    self.Btnflag2 = NO;
    self.Btnflag3 = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"3-0_02_CUT" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.countdown = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    self.syuttoView.backgroundColor = [[UIColor alloc] initWithRed:0.961 green:1.0 blue:0.9 alpha:0.3];
    
    [self.syuttoView bringSubviewToFront:self.view];
    
    // ステータスバーの表示/非表示メソッド呼び出し
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7以降
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 7未満
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

   
}

// ステータスバーの非表示
- (BOOL)prefersStatusBarHidden
{
    return YES;
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
    
    [captureDevice lockForConfiguration:nil];
    captureDevice.torchMode = AVCaptureFlashModeAuto;
    [captureDevice unlockForConfiguration];

        //セッションの設定
    [self.session startRunning];
    
    [self.view bringSubviewToFront:self.syuttoView];
    
    
    
        return YES;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//カメラボタン押時
- (IBAction)startCamera:(id)sender {
    
    if (self.Btnflag2 == NO) //セルフタイマーが４秒の時
    {
        [self start];
    }
    else if (self.Btnflag2 == YES) //セルフタイマーが１０秒の時
    {
        [self start2];
    }
    

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


- (IBAction)tapMenuBtn:(UIButton *)sender { //メニューボタンを押した時
    
    switch (sender.tag)
    {
        case 0: //メニューボタンを押すと、メニューバーがシュッと出たり入ったりする
            if (self.Btnflag == NO)
            {
                [UILabel beginAnimations:nil context:nil];
                [UILabel setAnimationDuration:0.2];
                self.syuttoView.center = CGPointMake(94, 36);
                [UILabel commitAnimations];
                
                self.Btnflag = YES;
            }
            else if (self.Btnflag == YES)
            {
                [UILabel beginAnimations:nil context:nil];
                [UILabel setAnimationDuration:0.2];
                self.syuttoView.center = CGPointMake(-32, 36);
                [UILabel commitAnimations];
                
                self.Btnflag = NO;
            }
            break;
        case 1: //セルフタイマーボタンを押すと、セルフタイマーの秒数が変わる
            if (self.Btnflag2 == NO)
            {
                [self.secondBtn setImage:[UIImage imageNamed:@"timer10.png"] forState:UIControlStateNormal];
                
                self.Btnflag2 = YES;
            }
            else if (self.Btnflag2 == YES)
            {
                [self.secondBtn setImage:[UIImage imageNamed:@"timer4.png"] forState:UIControlStateNormal];
                
                self.Btnflag2 = NO;
            }
            break;
        case 2: //リピートボタンを押すと、リピート回数が変わる
            if (self.Btnflag3 == 0)
            {
                [self.repeatBtn setImage:[UIImage imageNamed:@"repeat1.png"] forState:UIControlStateNormal];
                
                repeatcount = 2;
                
                self.Btnflag3 = 1;
            }
            else if (self.Btnflag3 == 1)
            {
                [self.repeatBtn setImage:[UIImage imageNamed:@"repeat2.png"] forState:UIControlStateNormal];
                
                repeatcount = 3;
                
                self.Btnflag3 = 2;
            }
            else if (self.Btnflag3 == 2)
            {
                [self.repeatBtn setImage:[UIImage imageNamed:@"repeattx.png"] forState:UIControlStateNormal];
                
                repeatcount = 1;
                
                self.Btnflag3 = 0;
            }
            break;
        default:
            break;
    }

}


-(void)start //カウントダウンの音声を流す
{
    [self.countdown play];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(count)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)start2 //セルフタイマーが１０秒なので、カウントダウン音声を6秒後呼び出す
{
    [self performSelector:@selector(start) withObject:nil afterDelay:6];
}

-(void)count //timerが呼び出すメソッド
{
    time++;
    
    if (time == 3)
    {
        [self camera];
        [timer invalidate];
        
    }
}



-(void)camera //写真を撮る
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
    
    time = 0; //タイマーを初期化する
    aida = 0;
    repeatcount--;
    
    if (repeatcount > 0) //リピート回数が０以外なら繰り返す。
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

-(void)onemore //繰り返す
{
    if (self.Btnflag2 == YES) //10秒タイマーなら即タイマー発動
    {
        [self start2];
    }
    else if (self.Btnflag2 == NO) //4秒タイマーなら２秒後にタイマー発動
    {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(count2)
                                                userInfo:nil repeats:YES];
    }
}

-(void)count2 //timer2が呼ぶメソッド
{
    aida++;
    
    if (aida == 2)
    {
        [self start];
        [timer2 invalidate];
    }
}
@end
