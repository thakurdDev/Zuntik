//
//  CheckLoginView.m
//  Zuntik
//
//  Created by Dev-Mac on 05/08/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "CheckLoginView.h"
#import "CreateAccount.h"

@interface CheckLoginView ()

@end

@implementation CheckLoginView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)LoginAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)CreateAccountAction:(id)sender
{
    CreateAccount  *obj=[[CreateAccount alloc]initWithNibName:@"CreateAccount" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
