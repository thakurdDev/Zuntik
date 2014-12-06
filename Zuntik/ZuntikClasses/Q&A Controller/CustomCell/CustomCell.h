//
//  CustomCell.h
//  BookTasawwufApp
//
//  Created by Sonu Parmar on 03/02/14.
//  Copyright (c) 2014 Linkites. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(nonatomic ,retain)IBOutlet UIImageView *imgCell;
@property(nonatomic ,retain)IBOutlet UILabel *lblCellTitle,*cell_S_No,*lblPubDate,*lblDesc,*lblTime,*lblDownload,*lblIndex,*lblDuration;
@property(nonatomic ,retain)IBOutlet UIView *circleView;
@property(nonatomic,retain)IBOutlet UILabel *lblCalendarName,*lblCalendarDisc;

//Label for Home View

@property(nonatomic,retain)IBOutlet UILabel *lblH_EventName,*lblH_EventDetail,*lblH_EventType,*lblH_TimeAdd,*lblH_Duretion,*lblH_StartTime;
@property(nonatomic ,retain)IBOutlet UIImageView *img_HDot;
@property(nonatomic,retain)IBOutlet UIImageView *imgH_Color;

@property(nonatomic,retain)IBOutlet UIImageView *imgHelpBack;

@end
