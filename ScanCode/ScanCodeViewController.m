//
//  ScanCodeViewController.m
//  demo
//
//  Created by gaofu on 2017/4/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extend.h"

const static CGFloat animationTime = 2.5f;//扫描时长

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic,strong) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic,strong) CAShapeLayer *scanPaneBgLayer;

@end

@implementation ScanCodeViewController
{
    __weak IBOutlet UIImageView *_scanPane;//扫描框
    __weak IBOutlet UILabel *_contentLabel;
    __weak IBOutlet NSLayoutConstraint *_boxLayoutConstraint;
    __weak IBOutlet UIActivityIndicatorView *_loaddingIndicatorView;
    UIImageView *_scanLine;//扫描线
}


#pragma mark -
#pragma mark  Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initScanCode];
    [self initScanLine];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startScan];
}

-(CAShapeLayer *)scanPaneBgLayer
{
    
    if (!_scanPaneBgLayer)
    {
        _scanPaneBgLayer = [CAShapeLayer layer];
    }
    return _scanPaneBgLayer;
}

#pragma mark -
#pragma mark  Interface Components

//扫描线
-(void)initScanLine
{
    
    _scanLine = [UIImageView new];
    _scanLine.image = [UIImage imageNamed:@"scancode_line"];
    [_scanPane addSubview:_scanLine];
    
    [self setScanReact:YES];
    [self.view.layer insertSublayer:self.scanPaneBgLayer above:self.captureVideoPreviewLayer];
}

//绘制扫描框背景
- (void)setScanReact:(BOOL)loading
{
    
    CGRect scanRect = _scanPane.frame;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:scanRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.view.bounds]];
    
    [self.scanPaneBgLayer setFillRule:kCAFillRuleEvenOdd];
    [self.scanPaneBgLayer setPath:path.CGPath];
    [self.scanPaneBgLayer setFillColor:[UIColor colorWithWhite:0 alpha:loading ? 1 : 0.6].CGColor];
}


#pragma mark -
#pragma mark  Target Action Methods

//开灯按钮
- (IBAction)lightBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self turnTorchOn:sender.selected];
}

//打开相册
- (IBAction)photoBtnAction:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = true;
    [self presentViewController:picker animated:true completion:nil];
}

#pragma mark -
#pragma mark  DataRequest


#pragma mark -
#pragma mark  Private Methods

//初始化扫描二维码
-(void)initScanCode
{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        [self showMessage:@"摄像头不可用" title:@"温馨提示" andler:nil];
        return;
    }
    
    if ([device lockForConfiguration:nil])
    {
        //自动白平衡
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
        {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动对焦
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        {
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
        {
            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        [device unlockForConfiguration];
    }
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [self.self.captureSession canAddInput:input] ? [self.captureSession addInput:input] : nil;
    [self.captureSession canAddOutput:self.captureMetadataOutput] ? [self.captureSession addOutput:self.captureMetadataOutput] : nil;
    
    [self.captureMetadataOutput setMetadataObjectTypes:@[
                                                         AVMetadataObjectTypeQRCode,
                                                         AVMetadataObjectTypeCode39Code,
                                                         AVMetadataObjectTypeCode128Code,
                                                         AVMetadataObjectTypeCode39Mod43Code,
                                                         AVMetadataObjectTypeEAN13Code,
                                                         AVMetadataObjectTypeEAN8Code,
                                                         AVMetadataObjectTypeCode93Code
                                                         ]];
    
    self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
    
    [self loadScan];
}

//启动扫描
-(void)loadScan
{
    [_loaddingIndicatorView startAnimating ];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loaddingIndicatorView stopAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                _contentLabel.alpha = 1;
                _boxLayoutConstraint.constant = [UIScreen mainScreen].bounds.size.width*0.6;
                [self.view layoutIfNeeded];
                self.captureMetadataOutput.rectOfInterest = [self.captureVideoPreviewLayer metadataOutputRectOfInterestForRect:_scanPane.frame];
            } completion:^(BOOL finished) {
                _scanLine.frame = CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width*0.6, 3);
                [_scanLine.layer addAnimation:[self moveAnimation] forKey:nil];
                [self setScanReact:NO];
            }];
        });
    });
}

//开始扫描
- (void)startScan
{
    [_scanLine.layer addAnimation:[self moveAnimation] forKey:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
    });
}

//停止扫描
- (void)stopScan
{
    
    [_scanLine.layer removeAllAnimations];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.captureSession.isRunning )
        {
            [self.captureSession stopRunning];
        }
    });
}

//扫描动画
-(CABasicAnimation*)moveAnimation
{
    CGPoint starPoint = CGPointMake(_scanLine .center.x  , 1);
    CGPoint endPoint = CGPointMake(_scanLine.center.x, _scanPane.bounds.size.height - 2);
    
    CABasicAnimation*translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    translation.fromValue = [NSValue valueWithCGPoint:starPoint];
    translation.toValue = [NSValue valueWithCGPoint:endPoint];
    translation.duration = animationTime;
    translation.repeatCount = CGFLOAT_MAX;
    translation.autoreverses = YES;
    
    return translation;
}

//散光灯
- (void)turnTorchOn: (BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash])
        {
            [device lockForConfiguration:nil];
            if (on && device.torchMode == AVCaptureTorchModeOff)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            }
            if (!on && device.torchMode == AVCaptureTorchModeOn)
            {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

//扫描结果处理
-(void)dealwithResult:(NSString*)result
{
    [self playScanCodeSound];
    [self showMessage:result title:@"扫描结果" andler:^(UIAlertAction *action) {
        [self startScan];
    }];
}

//播放提示音
- (void)playScanCodeSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scancode.caf" ofType:nil];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
    AudioServicesPlayAlertSound(soundID);
}

-(void)showMessage:(NSString*)message title:(NSString*)title andler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:handler];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark -
#pragma mark  AVCaptureMetadataOutputObjects Delegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self stopScan];
    
    //扫完完成
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *result = obj.stringValue;
        [self dealwithResult:result];
    }
}


#pragma mark -
#pragma mark  UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [_loaddingIndicatorView startAnimating];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSString *scanResult = [image scanCodeContent];
        
        [_loaddingIndicatorView stopAnimating];
        
        [self dealwithResult:scanResult];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}


#pragma mark -
#pragma mark  Dealloc

-(void)dealloc
{
    [self.captureSession stopRunning];
    _captureMetadataOutput = nil;
    _captureSession = nil;
    [_captureVideoPreviewLayer removeFromSuperlayer];
    _captureVideoPreviewLayer = nil;
}

@end
