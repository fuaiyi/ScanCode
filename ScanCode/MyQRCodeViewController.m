//
//  MyQRCodeViewController.m
//  demo
//
//  Created by gaofu on 2017/4/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "NSString+QRCode.h"

@interface MyQRCodeViewController ()

@end

@implementation MyQRCodeViewController
{
    __weak IBOutlet UIImageView *_headImageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UIImageView *_QRCodeImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [@"大家好,我是炮炮兵!" generateQRCodeWithLogo:_headImageView.image];
        dispatch_async(dispatch_get_main_queue(), ^{
            _QRCodeImageView.image = image;
        });
    });
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
