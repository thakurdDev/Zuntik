//
//  RearViewController.m
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "HomeVC.h"
#import "SearchCalendarVC.h"
#import "MyCalendarVC.h"
#import "MySucriptionVC.h"
#import "CreateCalendarVC.h"
#import "WelComeVC.h"
#import "HelpViewController.h"
#import "CalendarMenuVC.h"
#import "SettingNotificationVC.h"
#import "EventListVC.h"
@interface RearViewController ()

@end

@implementation RearViewController
@synthesize rearTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Rear View", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
        objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        objDatabase = [DataBaseManagement Connetion];//Database Connection
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strUserId=[userDefaults valueForKey:@"UserId"];
        NSMutableDictionary * DicForUserDetails= [objDatabase getUserInfo:strUserId];
          lblUName.text=[NSString stringWithFormat:@"%@ %@",[DicForUserDetails valueForKey:@"first_name"],[DicForUserDetails valueForKey:@"last_name"]];
        lblUId.text=[DicForUserDetails valueForKey:@"user_email"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];

        cell.textLabel.textColor=[UIColor whiteColor];
               
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectionColor;
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 230, 1)];
        imageView1.image=[UIImage imageNamed:@"menu_Line.png"];
        [cell.contentView addSubview:imageView1];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
	}
	if (row == 0)
	{
         cell.imageView.image=[UIImage imageNamed:@"menu_Home.png"];
		cell.textLabel.text = @"Home";
        
	}
    
	if (row == 1)
	{
        cell.imageView.image=[UIImage imageNamed:@"Menu_search.png"];
		cell.textLabel.text = @"Calendar Search";
        
	}
	else if (row == 2)
	{
        cell.imageView.image=[UIImage imageNamed:@"menu_mycal.png"];
		cell.textLabel.text = @"My Calendars";
	}
	else if (row == 3)
	{
        cell.imageView.image=[UIImage imageNamed:@"Menu_mysubs.png"];
		cell.textLabel.text = @"My Subscriptions";
	}
    else if (row == 4)
	{
        cell.imageView.image=[UIImage imageNamed:@"Menu_EventList.png"];
		cell.textLabel.text = @"Event lists";
	}
	else if (row == 5)
	{
        cell.imageView.image=[UIImage imageNamed:@"Menu_help.png"];
		cell.textLabel.text = @"Help";
	}
    else if (row == 6)
	{
        cell.imageView.image=[UIImage imageNamed:@"Menu_setting.png"];
		cell.textLabel.text = @"Settings";
	}
  
    else if (row == 7)
	{
        cell.imageView.image=[UIImage imageNamed:@"Menu_logout.png"];
        cell.textLabel.text=@"Sign Out";
    }
    
    cell.backgroundColor=[UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    NSInteger row = indexPath.row;
    
    if (row == 0)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[HomeVC class]] )
        {
			HomeVC *frontViewController = [[HomeVC alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
			[revealController setFrontViewController:navigationController animated:YES];
        }
		else
		{
			[revealController revealToggle:self];
		}
	}
    
    else if (row == 1)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[SearchCalendarVC class]] )
        {
			SearchCalendarVC *frontViewController = [[SearchCalendarVC alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
			[revealController setFrontViewController:navigationController animated:YES];
        }
		else
		{
			[revealController revealToggle:self];
		}
	}
    
	else if (row == 2)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[MyCalendarVC class]] )
        {
			MyCalendarVC *objMyCalendarVC = [[MyCalendarVC alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objMyCalendarVC];
			[revealController setFrontViewController:navigationController animated:YES];
		}
        else
		{
			[revealController revealToggle:self];
		}
	}
	else if (row == 3)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[MySucriptionVC class]] )
        {
			MySucriptionVC *objMySucriptionVC = [[MySucriptionVC alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objMySucriptionVC];
			[revealController setFrontViewController:navigationController animated:YES];
		}
        else
		{
			[revealController revealToggle:self];
		}
	}
    else if (row == 4)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[EventListVC class]] )
        {
			EventListVC *objEventListVC = [[EventListVC alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objEventListVC];
			[revealController setFrontViewController:navigationController animated:YES];
		}
        else
		{
			[revealController revealToggle:self];
		}
	}

    else if (row == 5)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[HelpViewController class]] )
        {
			HelpViewController *objHelpViewController = [[HelpViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objHelpViewController];
			[revealController setFrontViewController:navigationController animated:YES];
		}
        else
		{
			[revealController revealToggle:self];
		}
	}
    else if (row == 6)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[SettingNotificationVC class]] )
        {
			SettingNotificationVC *objSettingNotificationVC = [[SettingNotificationVC alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objSettingNotificationVC];
			[revealController setFrontViewController:navigationController animated:YES];
		}
        else
		{
			[revealController revealToggle:self];
		}
	}
  
	else if (row == 7)
	{
       //Logout
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"UserId"];
       // [userDefaults setValue:nil forKey:@"UserId"];
        [userDefaults setBool:NO forKey:@"isLogedIn"];
        [userDefaults synchronize];
        [self.revealViewController.navigationController popViewControllerAnimated:YES];
 	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
