//
//  CustomCell.m
//  BookTasawwufApp
//
//  Created by Sonu Parmar on 03/02/14.
//  Copyright (c) 2014 Linkites. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize lblCellTitle,cell_S_No,lblPubDate,lblDesc,lblTime,lblDownload,lblIndex,lblDuration;
@synthesize imgCell;
@synthesize circleView;
@synthesize lblCalendarDisc,lblCalendarName;
@synthesize lblH_EventName,lblH_EventDetail,lblH_EventType,lblH_TimeAdd,imgH_Color,lblH_Duretion,lblH_StartTime,img_HDot;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
