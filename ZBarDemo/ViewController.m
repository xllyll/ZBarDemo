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

@interface ViewController ()<ZBarReaderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *iText;
@property (weak, nonatomic) IBOutlet UILabel *showBarCodeLabel;
@property (strong, nonatomic)UIImagePickerController *imagePickerController;
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
//扫描本地文件
- (IBAction)scanLocaImageBarCode:(id)sender {
    
    
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }
    // 跳转到相机或相册页面
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.sourceType = sourceType;
    
    [self presentViewController:_imagePickerController animated:YES completion:^{}];
}
#pragma mark 二维码结束扫描对应事件（Delegate）

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    ZBarSymbol *symbol = nil;
    if (reader==_imagePickerController) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imageView.image = image;
        ZBarReaderController* read = [ZBarReaderController new];
        
        read.readerDelegate = self;
        
        CGImageRef cgImageRef = image.CGImage;
        
        for(symbol in [read scanImage:cgImageRef]) break;
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        
        for(symbol in results)
            break;
        [reader dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    
    
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
    _showBarCodeLabel.text = codeString;
}
-(void)readerControllerDidFailToRead: (ZBarReaderController*) reader withRetry: (BOOL) retry{
    
    if(retry){
        
        
        //retry == YES 选择图片为非二维码
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您选择的二维码不正确,请重新选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        //retry == 1 选择图片为非二维码。
        NSLog(@"ok");
        
        return;
        
    }else{
        NSLog(@"nooooooooo");
    }
    
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
