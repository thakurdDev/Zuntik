/*
 DSLCalendarDayView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DSLCalendarDayView.h"
#import "NSDate+DSLCalendarView.h"


@interface DSLCalendarDayView ()

@end


@implementation DSLCalendarDayView {
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
    __strong NSString *_labelText;
    
}
@synthesize labelAttendence = _labelAttendence;

#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        _positionInWeek = DSLCalendarDayViewMidWeek;
    }
    
    return self;
}


#pragma mark Properties

- (void)setSelectionState:(DSLCalendarDayViewSelectionState)selectionState {
    _selectionState = selectionState;
    [self setNeedsDisplay];
}

- (void)setDay:(NSDateComponents *)day {
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _day = nil;
    
    _labelText = [NSString stringWithFormat:@"%ld", (long)day.day];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:_dayAsDate];
    int weekday = [comps weekday];
    if (weekday==1)
    {
        _labelAttendence = @"SUN";
    }else
    {
    }
}
- (void)setAttendence:(NSString *)dayAttendence {
    _labelAttendence = dayAttendence;
}


- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [_dayAsDate dslCalendarView_dayWithCalendar:_calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
}

- (void)setInCurrentMonth:(BOOL)inCurrentMonth {
    _inCurrentMonth = inCurrentMonth;
    [self setNeedsDisplay];
}


#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
    if ([self isMemberOfClass:[DSLCalendarDayView class]]) {
        // If this isn't a subclass of DSLCalendarDayView, use the default drawing
        [self drawBackground];
        [self drawBorders];
        [self drawDayNumber];
        if (self.isInCurrentMonth)
        {
            [self drawDayAttendence];
        }
    }
}


#pragma mark Drawing

- (void)drawBackground {
    if (self.selectionState == DSLCalendarDayViewNotSelected)
    {
       
        if (self.isInCurrentMonth)
      {
            //[[UIColor colorWithWhite:245.0/255.0 alpha:1.0] setFill];
            if ([_labelAttendence isEqualToString:@"•"])
            {
               // [[UIColor clearColor] setFill]; ///selected point
                [[UIColor colorWithRed:27/255.0 green:44/255.0 blue:54/255.0 alpha:1] setFill];//other Month

            }else
            {
               // [[UIColor colorWithWhite:0.0/255.0 alpha:1] setFill];
                //[[UIColor clearColor] setFill];// Month
                [[UIColor colorWithRed:27/255.0 green:44/255.0 blue:54/255.0 alpha:1] setFill];//other Month

            }
            
//            if ([date isEqualToDate:dateToday]) {
//                [[UIColor redColor] setFill]; //from now current day is colored
//            }
          
            
            
        }
        else {
            [[UIColor colorWithRed:27/255.0 green:44/255.0 blue:54/255.0 alpha:1] setFill];//other Month
            //[[UIColor redColor] setFill];
        }
        
        UIRectFill(self.bounds);
    
        
    }
    else {
        switch (self.selectionState) {
            case DSLCalendarDayViewNotSelected:
                break;
                
            case DSLCalendarDayViewStartOfSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
                
            case DSLCalendarDayViewEndOfSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection-right"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
                
            case DSLCalendarDayViewWithinSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection-middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
                
            case DSLCalendarDayViewWholeSelection:
                [[[UIImage imageNamed:@"DSLCalendarDaySelection"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] drawInRect:self.bounds];
                break;
        }
    }
}

- (void)drawBorders {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.1);
    
    CGContextSaveGState(context);
   // CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    //CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
   // CGContextAddLineToPoint(context, 0.5, 0.5);
    //CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
   // CGContextStrokePath(context);
   // CGContextRestoreGState(context);
    
   // CGContextSaveGState(context);
    if (self.isInCurrentMonth) {
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextMoveToPoint(context, self.bounds.size.width - 0.5, 0.0);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.0);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawDayNumber
{
    
   
    if (self.selectionState == DSLCalendarDayViewNotSelected)
    {
        [[UIColor whiteColor] set];
    }
    else {
        [[UIColor whiteColor] set];
    }
    
    if (self.isInCurrentMonth)
    {
        
        if ([_labelAttendence isEqualToString:@"•"])
        {
            [[UIColor whiteColor] setFill];//changed the bg color . ed selected
        }else
        {
            [[UIColor whiteColor] setFill];//changed the unselected color
        }
    }else{
        [[UIColor grayColor] setFill];//changed the bg color other month
    }
    UIFont *textFont = [UIFont systemFontOfSize:12.0];
    CGSize textSize = [_labelText sizeWithFont:textFont];

    CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
    
   // CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds)+ 5), 0, textSize.width, textSize.height);
    
    [_labelText drawInRect:textRect withFont:textFont];
}
- (void)drawDayAttendence
{
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        UIFont *textFont = [UIFont systemFontOfSize:18.0];
        CGSize textSize = [_labelAttendence sizeWithFont:textFont];
        
        if ([_labelAttendence isEqualToString:@"•"])
        {
            [[UIColor colorWithRed:72/255.0 green:178/255.0 blue:138/255.0 alpha:1] setFill];//changed the bg color .
            CGRect textRect = CGRectMake(20, 18, textSize.width, textSize.height);
            
            [_labelAttendence drawInRect:textRect withFont:textFont];
        }
        /*else
        {
            if ([_labelAttendence isEqualToString:@"P"])
            {
                [[UIColor redColor] setFill];//changed the bg color
                CGRect textRect = CGRectMake(2, 0+20, textSize.width, textSize.height);
                
                [_labelAttendence drawInRect:textRect withFont:textFont];
            }
        }  
         */}
    else {
       // [[UIColor greenColor] set];
        UIFont *textFont = [UIFont systemFontOfSize:18.0];
        CGSize textSize = [_labelAttendence sizeWithFont:textFont];
        
        if ([_labelAttendence isEqualToString:@"•"])
        {
            [[UIColor whiteColor] setFill];//changed the bg color .
            CGRect textRect = CGRectMake(20, 18, textSize.width, textSize.height);
            
            [_labelAttendence drawInRect:textRect withFont:textFont];
        }
     /*   else
        {
            if ([_labelAttendence isEqualToString:@"P"])
            {
                [[UIColor redColor] setFill];//changed the bg color
                CGRect textRect = CGRectMake(2, 0+20, textSize.width, textSize.height);
                
                [_labelAttendence drawInRect:textRect withFont:textFont];
            }
        }*/
    }
    
  
    
    //CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
    
}
@end
