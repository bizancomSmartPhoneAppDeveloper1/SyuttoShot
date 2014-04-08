//
//  ViewController.h
//  SyuttoShot
//
//  Created by bizan.com.mac09 on 2014/04/02.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *syuttoView;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;

@property AVAudioPlayer *countdown;
@property AVAudioPlayer *end;

@property BOOL Btnflag; //メニューボタンが押されたかどうか
@property BOOL Btnflag2; //タイマーボタンが何回押されたかどうか
@property int Btnflag3; //繰り返しボタンが何回押されたかどうか


- (IBAction)startCamera:(id)sender;
- (IBAction)tapMenuBtn:(UIButton *)sender;

@end
