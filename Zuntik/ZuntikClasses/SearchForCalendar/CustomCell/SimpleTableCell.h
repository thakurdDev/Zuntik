//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblSearchName;
@property (nonatomic, retain) IBOutlet UILabel *lblSearchDetail,*lblcreate;
@property(nonatomic, retain) IBOutlet UIButton *btnDetailShow;


@end
