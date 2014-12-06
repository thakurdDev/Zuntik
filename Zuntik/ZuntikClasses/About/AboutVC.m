//
//  AboutVC.m
//  Zuntik
//
//  Created by Dev-Mac on 17/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "AboutVC.h"
#import "SWRevealViewController.h"
@interface AboutVC ()

@end

@implementation AboutVC

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
    self.navigationController.navigationBarHidden=YES;
    [self swrevelButton];
}
#pragma mark -swrevelButton Add
-(void)swrevelButton
{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44 , 44)];
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"]forState:UIControlStateNormal];
    [btnLeft addTarget:revealController action:@selector(revealToggle:)
      forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnLeft];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
