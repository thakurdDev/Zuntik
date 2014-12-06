//
//  HelpViewController.m
//  Zuntik
//
//  Created by Dev-Mac on 14/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "HelpViewController.h"
#import "CustomCell.h"
#import "JSON.h"
#import "SWRevealViewController.h"
#import "ZuntikServicesVC.h"
#import "Reachability.h"
#define DEFAULT_FONT_STYLE_CELL_TITLE_10 [UIFont fontWithName:@"Myriad Pro" size:15]

#define DEFAULT_FONT_STYLE_CELL_TITLE_20 [UIFont fontWithName:@"Myriad Pro" size:30]

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize mArrayResponse;
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
    self.mArrayResponse = [[NSMutableArray alloc]init];
    objDatabase = [DataBaseManagement Connetion];//Database Connection
  
    [self SwrevelViewButton];
    /* [self ONServerSubscriptionsValue];*/
    selecetedIndex = -1;
    [self CheckNetwork];
}
-(void)SwrevelViewButton
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
-(void)CheckNetwork
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [self ONDataBasegetQuestionAnsewerList];//CallLocalDatabase Value
        
    }
    else
    {
         [self ONServergetQuestionAnsewerList];
//Call Server Value */ //Api call
    }
    
}
//getnewsevent list DataBase Call

-(void)ONDataBasegetQuestionAnsewerList
{
    NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
    dicResponse= [objDatabase QuestionAnsewerList];
    if (dicResponse!=nil)
    {
        self.mArrayResponse = [dicResponse valueForKey:@"newHelp"];
        
        [_tableViewHelp reloadData];
        
    }

    
}
//getnewsevent list Api Call
-(void)ONServergetQuestionAnsewerList
{
    NSDictionary *parameters = @{@"lastUpdate":@"2010/01/01 00:00:00",@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnAllQAndA.php" Withparms:parameters WithSuccess:^(id response)
     {
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
        if (dicResponse!=nil)
         {
             self.mArrayResponse = [dicResponse valueForKey:@"newHelp"];

             [_tableViewHelp reloadData];
             
         }
     }
     
    failure:^(NSError *error)
     {
     }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.mArrayResponse count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!isSelected)
    {
        return 1;
    }
    else if(section != selecetedIndex)
    {
        return 1;
    }else
    {
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mDict = [self.mArrayResponse objectAtIndex:indexPath.section];
    CustomCell *cell = (CustomCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil]objectAtIndex:0];
    
    if(indexPath.section == selecetedIndex)
    {
        if(indexPath.row == 0)
        {
            NSString *strComment = [@"Question :  "stringByAppendingString:[mDict valueForKey:@"question_text"]];
            cell.lblDesc.text = strComment;
            
            CGRect labelFrame = cell.lblCellTitle.frame;
            
            CGRect expectedFrame = [cell.lblDesc.text boundingRectWithSize:CGSizeMake(cell.lblDesc.frame.size.width, 9999)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            DEFAULT_FONT_STYLE_CELL_TITLE_20, NSFontAttributeName,
                                                                            nil]
                                                                   context:nil];
            
            labelFrame.size = expectedFrame.size;
            labelFrame.size.height = ceil(labelFrame.size.height);
            cell.lblDesc.frame = labelFrame;
            
            return cell.lblDesc.frame.size.height + 80;
        }
        if (indexPath.row == 1)
        {
            
            CustomCell *cellAnswer = (CustomCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil]objectAtIndex:3];
            
            NSString *strComment = [@"Answer :  "stringByAppendingString:[mDict valueForKey:@"answer"]];
            cellAnswer.lblDesc.text = strComment;
            CGRect labelFrame = cellAnswer.lblDesc.frame;
            CGRect expectedFrame = [cellAnswer.lblDesc.text boundingRectWithSize:CGSizeMake(cell.lblDesc.frame.size.width, 9999)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            DEFAULT_FONT_STYLE_CELL_TITLE_10, NSFontAttributeName,
                                                                            nil]
                                                                   context:nil];
            
            labelFrame.size = expectedFrame.size;
            labelFrame.size.height = ceil(labelFrame.size.height);
            cellAnswer.lblDesc.frame = labelFrame;
            
            return cellAnswer.lblDesc.frame.size.height + 100;
        }
    }
    else
    {
        NSString *strComment = [@"Question :  "stringByAppendingString:[mDict valueForKey:@"question_text"]];
        cell.lblDesc.text = strComment;
        
        CGRect labelFrame = cell.lblDesc.frame;
        
        CGRect expectedFrame = [cell.lblDesc.text boundingRectWithSize:CGSizeMake(cell.lblDesc.frame.size.width, 9999)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        DEFAULT_FONT_STYLE_CELL_TITLE_10, NSFontAttributeName,
                                                                        nil]
                                                               context:nil];
        
        labelFrame.size = expectedFrame.size;
        labelFrame.size.height = ceil(labelFrame.size.height);
        cell.lblDesc.frame = labelFrame;
    }
    return cell.lblDesc.frame.size.height + 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Q&A_Identifier";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil )
    {
        NSArray *nibCell = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nibCell objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblDesc.font = DEFAULT_FONT_STYLE_CELL_TITLE_10;
    }
    //self.imageview.transform = CGAffineTransformMakeRotation(M_PI/2);
  
    NSMutableDictionary *mDict = [self.mArrayResponse objectAtIndex:indexPath.section];
   
    if(indexPath.section == selecetedIndex)
    {
        if(indexPath.row == 0)
        {
            NSString *strCal_name = [[mDict valueForKey:@"question_text"]uppercaseString];
            cell.lblDesc.text =  strCal_name;
            
           // cell.lblDesc.text = [mDict valueForKey:@"question_text"];
            //cell.imgCell.transform = CGAffineTransformMakeRotation(M_PI / 2);
            [cell.imgCell setImage:[UIImage imageNamed:@"Help_helparrow.png"]];
            [cell.imgHelpBack setImage:[UIImage imageNamed:@"Help_arrowbox.png"]];
        }
        if (indexPath.row == 1)
        {
            static NSString *cellIdentifier = @"Answer";
            CustomCell *cellAnswer = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cellAnswer == nil )
            {
                NSArray *nibCell = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
                cellAnswer = [nibCell objectAtIndex:3];
                cellAnswer.selectionStyle = UITableViewCellSelectionStyleNone;
                cellAnswer.lblDesc.font = DEFAULT_FONT_STYLE_CELL_TITLE_10;
            }
            cellAnswer.lblDesc.text =[mDict valueForKey:@"answer"];
            [cellAnswer.imgCell setImage:nil];
            
            return cellAnswer;
        }
    }
    else{
        NSString *strCal_name = [[mDict valueForKey:@"question_text"]uppercaseString];
        cell.lblDesc.text =  strCal_name;
        [cell.imgCell setImage:[UIImage imageNamed:@"help_arrowdown.png"]];
        [cell.imgHelpBack setImage:[UIImage imageNamed:@"Help_subbox.png"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSelected = YES;
    if( selecetedIndex==-1 || selecetedIndex!=indexPath.section )
    {
        selecetedIndex = indexPath.section;
    }else
    {
        selecetedIndex = -1;
    }
    
    [_tableViewHelp reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
