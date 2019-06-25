//
//  ViewController.m
//  socketTest
//
//  Created by mac on 2019/6/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "HWSocketManager.h"
#import "HWCommunication.h"
#import "HWEncryptionUtil.h"



@interface ViewController ()

@end




@implementation ViewController{
   

}


- (void)viewDidLoad {
    [super viewDidLoad];
      [HWUserDefault setBool:true forKey:HW_LOOGER_ISDEBUG];
    [self addTextFieldView:@"请输入文字"];
    
   
}
-(id)addTextFieldView:(NSString*)placeholder {
    // 初始化UITextField,并规定一个矩形区域

    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 280, 30)];
    // 设置输入框界面风格,枚举如下:
    // UITextBorderStyleNone        // 无风格
    // UITextBorderStyleLine        // 线性风格
    // UITextBorderStyleBezel       // bezel风格
    // UITextBorderStyleRoundedRect // 边框风格
    textField.borderStyle = UITextBorderStyleRoundedRect;
    // 设置提示文字
    textField.placeholder = placeholder;
    // 将控件添加到当前视图上
    [self.view addSubview:textField];
    return textField;
}





@end

