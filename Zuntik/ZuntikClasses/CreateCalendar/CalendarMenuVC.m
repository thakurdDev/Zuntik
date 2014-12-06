//
//  CalendarMenuVC.m
//  Zuntik
//
//  Created by Dev-Mac on 18/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "CalendarMenuVC.h"
#import "CustomCell.h"
#import "SWRevealViewController.h"
#import "CreateCalendarVC.h"
#import "SimpleScheduleVC.h"
@interface CalendarMenuVC ()
@property (weak, nonatomic) IBOutlet UIView *viewAdvanceError;
- (IBAction)cancelAction:(id)sender;

@end

@implementation CalendarMenuVC
@synthesize arryCalendarDesc,arryCalendarName;
@synthesize tblCalendar;
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
      objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _viewAdvanceError.hidden=YES;
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    arryCalendarName=[[NSMutableArray alloc]initWithObjects:@"Basic Calendar",@"Simple Course Schedule",@"Advanced Course Schedule", nil];
    arryCalendarDesc=[[NSMutableArray alloc]initWithObjects:@"Create a calendar that will be stored on our database and made available for users to download.",@"Create a course schedule to hold class events that will be stored on our database and made available for students or parents to download.",@"Create an advanced course schedule that allows you to create a single calendar for a class with several events due in different lecture, lab and discussion sections.", nil];
    [self.tblCalendar reloadData];
}

-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#define kCellPaddingHeight 40

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UIFont *font = [UIFont systemFontOfSize: 13];
        
        NSString* text = [self.arryCalendarDesc objectAtIndex:indexPath.row];
        
    
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary * attributes = @{NSFontAttributeName : font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        CGSize size = [text boundingRectWithSize:(CGSize){280, 1500}
                                         options:NSStringDrawingUsesFontLeading
                       |NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil].size;
        
        return size.height + kCellPaddingHeight;
   
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arryCalendarName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"calendarCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil )
    {
        NSArray *nibCell = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nibCell objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    UIFont *font = [UIFont systemFontOfSize:13];

    cell.lblCalendarName.text=[self.arryCalendarName objectAtIndex:indexPath.row];
    cell.lblCalendarDisc.text=[self.arryCalendarDesc objectAtIndex:indexPath.row];
    cell.lblCalendarDisc.textColor=[UIColor lightGrayColor];
    cell.lblCalendarDisc.lineBreakMode = NSLineBreakByWordWrapping;
    cell.lblCalendarDisc.numberOfLines = 0;
    cell.lblCalendarDisc.backgroundColor = [UIColor clearColor];
    [cell.lblCalendarDisc setFont:font];
    
      NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary * attributes = @{NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize size = [[self.arryCalendarDesc objectAtIndex:indexPath.row] boundingRectWithSize:(CGSize){280, 1500}
                                     options:NSStringDrawingUsesFontLeading
                   |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
    [cell.lblCalendarDisc setFrame:CGRectMake(22.0f, 26.0f, 280.0f, size.height)];
    [cell.lblCalendarDisc setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objAppDelegate.type_cal=@"add";
    if (indexPath.row==0) {
        CreateCalendarVC *objCreateCalendarVC=[[CreateCalendarVC alloc]initWithNibName:@"CreateCalendarVC" bundle:Nil];
        [self.navigationController pushViewController:objCreateCalendarVC animated:YES];
    }
   else if (indexPath.row==1)
   {
       SimpleScheduleVC *objSimpleScheduleVC=[[SimpleScheduleVC alloc]initWithNibName:@"SimpleScheduleVC" bundle:Nil];
       [self.navigationController pushViewController:objSimpleScheduleVC animated:YES];
   }
    else
    {
        self.viewAdvanceError.transform = CGAffineTransformMakeScale(0, 0);
        self.viewAdvanceError.hidden= NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.viewAdvanceError.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender
{
    _viewAdvanceError.hidden=YES;
}
@end
