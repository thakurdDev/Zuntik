
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RATableViewCell.h"

@interface RATableViewCell ()



@end

@implementation RATableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.selectedBackgroundView = [UIView new];
  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
  
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  self.additionButtonHidden = NO;
}


- (void)setupWithTitle:(NSString *)title detailText:(NSString *)detailText level:(NSInteger)level additionButtonHidden:(BOOL)additionButtonHidden
{
  self.customTitleLabel.text = title;
  self.detailedLabel.text = detailText;
  self.additionButtonHidden = additionButtonHidden;
  
  if (level == 0) {
    self.detailTextLabel.textColor = [UIColor blackColor];
  }
  if (level == 0)
  {
    self.customTitleLabel.font=[UIFont boldSystemFontOfSize:17.0];
      
    self.customTitleLabel.textColor=[UIColor colorWithRed:58.0/255.0 green:182.0/255.0 blue:137.0/255.0 alpha:1.0];
      
    self.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:52.0/255.0 blue:62.0/255.0 alpha:1.0];
      
  } else if (level == 1)
  {
    self.customTitleLabel.font=[UIFont boldSystemFontOfSize:17.0];
    self.customTitleLabel.textColor=[UIColor whiteColor];
    self.backgroundColor =[UIColor colorWithRed:34.0/255.0 green:48.0/255.0 blue:60.0/255.0 alpha:1.0];
      
  } else if (level >= 2)
  {
    self.customTitleLabel.font=[UIFont systemFontOfSize:17.0];
    self.customTitleLabel.textColor=[UIColor whiteColor];
    self.backgroundColor =[UIColor colorWithRed:29.0/255.0 green:43.0/255.0 blue:55.0/255.0 alpha:1.0];
  }
  
  CGFloat left = 15 + 10 * level;
  
  CGRect titleFrame = self.customTitleLabel.frame;
  titleFrame.origin.x = left;
  self.customTitleLabel.frame = titleFrame;
  
 /// CGRect detailsFrame = self.detailedLabel.frame;
 // detailsFrame.origin.x = left;
 // self.detailedLabel.frame = detailsFrame;
}


#pragma mark - Properties

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden
{
  [self setAdditionButtonHidden:additionButtonHidden animated:NO];
}

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden animated:(BOOL)animated
{
  _additionButtonHidden = additionButtonHidden;
  [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
    self.additionButton.hidden = additionButtonHidden;
  }];
}


#pragma mark - Actions

- (IBAction)additionButtonTapped:(id)sender
{
  if (self.additionButtonTapAction) {
    self.additionButtonTapAction(sender);
  }
}

@end
