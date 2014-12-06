//
//  SubcriptionDetailVC.h
//  Zuntik
//
//  Created by Dev-Mac on 17/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubcriptionDetailVC : UIViewController
{
    IBOutlet UILabel *lblCal_name,*lblCal_creator,*lblTags,*lblEvents;
    NSString *strCal_key,*strUserEmail;
    IBOutlet UITextView *txtDesc;

}
@property(nonatomic,retain)NSMutableDictionary *DicSubcriptionDetails;

-(IBAction)BackAction:(id)sender;
-(IBAction)UnSubcriptionAction:(id)sender;
-(IBAction)ManageCalendarAction:(id)sender;
@end
