//
//  EventListVC.m
//  Zuntik
//
//  Created by Dev-Mac on 05/08/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "EventListVC.h"
#import "SWRevealViewController.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "RATableViewCell.h"
#import "MBProgressHUD.h"
#import "SearchCalendarDetailVC.h"

@interface EventListVC ()<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) RATreeView *treeView;
@property (weak, nonatomic) IBOutlet UIView *EventView;

@end

@implementation EventListVC
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
    
    //
      //
    
    objectAppdelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;//NavigationBar Hide
    [self swrevelButton];
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    objDatabase = [DataBaseManagement Connetion];//Database Connection
   NSMutableDictionary *dicUserInfo= [objDatabase getUserInfo:strUserId];
    strCityNum=[dicUserInfo valueForKey:@"city_num"];
    [self ONServerCalendarValue];
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

#pragma ONServerCalendarValue Method
-(void)ONServerCalendarValue
{
     [self MbProcessHud];
    ////returnCreatedAndCollab.php
    NSDictionary *parameters = @{@"city_num":strCityNum,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"cityEventList.php" Withparms:parameters WithSuccess:^(id response)
     {
        objectAppdelegate.EventListArray=[[NSMutableArray alloc]init];
        objectAppdelegate.EventListArray=[response JSONValue];
       
           [self loadData];
         
         NSString *stractivate=[NSString stringWithFormat:@"%@",[objectAppdelegate.EventListArray valueForKey:@"success"]];
         if ([stractivate isEqualToString:@"1"])
         {
             
            
         }
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
     failure:^(NSError *error)
     {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  NEW WORK

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 52;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    [cell setAdditionButtonHidden:YES animated:YES];
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    [cell setAdditionButtonHidden:YES animated:YES];
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    
    NSString *detailText;
    if (level==0||level==1)
    {
         detailText = [NSString stringWithFormat:@"%@",[dataObject.mainDic objectForKey:@"item_count"]];
    }
    else if (level>1)
    {
        detailText=@"";
    }
    
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:expanded];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
            return;
        }
        
        RADataObject *newDataObject =[[RADataObject alloc]initWithName:@"Added value" children:@[] chidDic:@{} WithMainDic:@{}];
        
        [dataObject addChild:newDataObject];
        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
        [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
    };
    
    if (level==2)
    {
        cell.detailedLabel.hidden=YES;
        cell.imageRight.hidden=YES;
    }
    else if (dataObject.ChildrenDictionary.count>3)
    {
        cell.detailedLabel.hidden=YES;
        cell.imageRight.hidden=YES;
    }
    else
    {
        cell.detailedLabel.hidden=NO;
        cell.imageRight.hidden=NO;
    }
    
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item;
{
    
    RADataObject *dataObject = item;
    NSInteger level = [self.treeView levelForCellForItem:item];
    
    if (level==2)
    {
        
        NSString *cal_key=[dataObject.ChildrenDictionary  objectForKey:@"cal_key"];
        [self CallWebservicesForApplyThisItem:cal_key];
    }
    else if (dataObject.ChildrenDictionary.count>3)
    {
        
        NSString *cal_key=[dataObject.ChildrenDictionary  objectForKey:@"cal_key"];
         [self CallWebservicesForApplyThisItem:cal_key];
    }
   
}

- (void)loadData
{
    
    NSArray *MainSection=[NSArray arrayWithArray:[objectAppdelegate.EventListArray valueForKey:@"genre_name"]];


    NSMutableArray *mainSectionContaint=[[NSMutableArray alloc]init];
    // set main section with title
    for (int i=0; i<MainSection.count; i++)
    {
        //
        
        NSMutableDictionary *SemiSection=[[NSMutableDictionary alloc]initWithDictionary:[objectAppdelegate.EventListArray objectAtIndex:i]];
        NSArray *SemiSectionArray=[NSArray arrayWithArray:[SemiSection objectForKey:@"content"]];
        
        
        NSMutableArray *SemiSectionContains=[[NSMutableArray alloc]init];
        for (int j=0; j<SemiSectionArray.count; j++)
        {
            
            NSString *catname=[NSString stringWithFormat:@"%@",[[SemiSectionArray objectAtIndex:j] objectForKey:@"cat_name"]];
            
            NSDictionary *semm=[NSDictionary dictionaryWithDictionary:[SemiSectionArray objectAtIndex:j]];
            
            
            NSArray *ResultArray=[NSArray arrayWithArray:[[SemiSectionArray objectAtIndex:j] objectForKey:@"content"]];
            
            NSMutableArray *baseObjects=[[NSMutableArray alloc]init];
            
            
            if ([catname isEqualToString:@"(null)"]||catname==NULL)
            {
                NSString *catname=[NSString stringWithFormat:@"%@",[[SemiSectionArray objectAtIndex:j] objectForKey:@"el_name"]];
                
                
                RADataObject *semisectionObject = [RADataObject dataObjectWithName:catname children:baseObjects ChildDic:[SemiSectionArray objectAtIndex:j] WithMainDic:semm];
                
                [SemiSectionContains addObject:semisectionObject];
            }
            else
            {
                // create base children class  in semi section
               
                for (int k=0; k<ResultArray.count; k++)
                {
                    NSString *baseTitle=[NSString stringWithFormat:@"%@",[[ResultArray objectAtIndex:k] objectForKey:@"el_name"]];
                    
                    RADataObject *RowObject = [RADataObject dataObjectWithName:baseTitle children:nil ChildDic:[ResultArray objectAtIndex:k]WithMainDic:nil];
                    [baseObjects addObject:RowObject];
                }
                
                RADataObject *semisectionObject = [RADataObject dataObjectWithName:catname children:baseObjects ChildDic:nil WithMainDic:semm];
               [SemiSectionContains addObject:semisectionObject];
            }
            
        }
        // set main section title
        NSString *MainSectionTitle=[NSString stringWithFormat:@"%@",[MainSection objectAtIndex:i]];
        
        RADataObject *MainSection =[RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",MainSectionTitle] children:SemiSectionContains ChildDic:nil WithMainDic:SemiSection];
        
        [mainSectionContaint addObject:MainSection];
    }
    self.data = [NSArray arrayWithArray:mainSectionContaint];
    [self SetupEventTable];
    
}
-(void)SetupEventTable
{
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(5.0, 0.0, 310.0, self.EventView.frame.size.height)];
    
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    
    [treeView reloadData];
    
    
    self.treeView = treeView;
    [self.EventView addSubview:treeView];
    
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];

}
-(void)CallWebservicesForApplyThisItem:(NSString *)Cal_key
{
    [self MbProcessHud];
    
    NSDictionary *parameters = @{@"calCodes":Cal_key,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnSpecifiedCalendars.php" Withparms:parameters WithSuccess:^(id response)
     {
         
         NSDictionary *ResultDictionary=[response JSONValue];
         NSArray *ResultArray=[ResultDictionary objectForKey:@"calendars"];
         NSDictionary *Final=[NSDictionary dictionaryWithDictionary:[ResultArray objectAtIndex:0]];
         
         
                 objectAppdelegate.type_cal=[NSString stringWithFormat:@"%@",[Final objectForKey:@"cal_type"]];
                 
                 SearchCalendarDetailVC *objSearchCalendarDetailVC = [[SearchCalendarDetailVC alloc] initWithNibName:@"SearchCalendarDetailVC" bundle:nil];
                 objSearchCalendarDetailVC.DicSeachDetails =[[NSMutableDictionary alloc]initWithDictionary:Final];
                 [self.navigationController pushViewController:objSearchCalendarDetailVC animated:YES];
         
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
    failure:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
-(void)MbProcessHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
@end
