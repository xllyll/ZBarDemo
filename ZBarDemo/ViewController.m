//
//  ViewController.m
//  ZBarDemo
//
//  Created by 杨卢银 on 15/3/14.
//  Copyright (c) 2015年 杨卢银. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *iText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)beganScanZBar:(id)sender {
    
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最后读取并显示了条形码的图片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    
}
#pragma mark 二维码结束扫描对应事件（Delegate）

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    NSString *codeString  =  symbol.data ;
    
    if ([predicate evaluateWithObject:codeString]) {
        
    }
    else if([ssidPre evaluateWithObject:codeString]){
        
    }
    else{
        
    }
    NSLog(@"%@",codeString);
    _iText.text = codeString;
}

#pragma mark 生成二维码
- (IBAction)produceBarcode:(id)sender {
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
   _imageView.image = [QRCodeGenerator qrImageForString:_iText.text imageSize:_imageView.bounds.size.width];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_iText resignFirstResponder];
}
@end
