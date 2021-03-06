//
//  SCNResetPassWordViewController.m
//  SCN
//
//  Created by chenjie on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCNResetPassWordViewController.h"
#import "Go2PageUtility.h"

#define VIEWTAG_BGVIEW          100
@implementation SCNResetPassWordViewController

@synthesize m_textfield_newPassword;
@synthesize m_textfield_RenewPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidUnload
{
    
    m_button_ensure = nil;
    [super viewDidUnload];
    self.m_textfield_newPassword = nil;
    self.m_textfield_RenewPassword = nil;
}
- (void)dealloc
{
    NSLog(@"密码修改界面的dealloc调用");
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_textfield_newPassword becomeFirstResponder];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"重置密码";
    self.pathPath = @"/other";
    UIView * _view_bgview = (UIView *) [self.view viewWithTag:VIEWTAG_BGVIEW];
    _view_bgview.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    UIImage * _buttonregist_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [m_button_ensure setBackgroundImage:[_buttonregist_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonregist_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [m_button_ensure setBackgroundImage:[_buttonregist_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}
-(BOOL)checkUserInput
{
    NSString * user_newpassword = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textfield_newPassword.text];
    NSString * user_renewpassword = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textfield_RenewPassword.text];
    
    NSString * errorMsg = nil;
     if ([user_newpassword length] < 1){
        errorMsg = @"请输入新密码.";
    }
    else if ([user_newpassword length] < 6 || [user_newpassword length] > 20){
        errorMsg = @"请您输入6~20位的密码长度.";
    }
    else if ([user_renewpassword length] < 1){
        errorMsg = @"请输入确认密码.";
    }
    else if (![user_newpassword isEqualToString:user_renewpassword]){
        errorMsg = @"两次输入的密码不一致.";
        
    }
    if (errorMsg != nil) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE 
                                                       message:errorMsg 
                                                      delegate:nil 
                                             cancelButtonTitle:@"确定" 
                                             otherButtonTitles:nil];
        [alert show];
        return NO;
    }

    return YES;
    
}
-(IBAction)onActionResetbuttonpress:(id)sender
{
    if ([self checkUserInput]) {
        [self startLoading];
        [K_YKUserInfoUtility onrequestResetPasswordUser:m_textfield_newPassword.text m_delegate_ResetPassword:self];
    }

}
-(void)CallbackResetPassword:(BOOL)success errMsg:(NSString*)msg
{
    [self stopLoading];
    
    if (success) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"您的密码修改成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"回调密码找回界面成功");
}


@end
