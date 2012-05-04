//
//  TLWidgetView.m
//  Calendar
//
//  Created by Tony Li on 4/18/12.
//  Copyright (c) 2012 Tony Li. All rights reserved.
//

#import "TLWidgetView.h"
#import "../Common/NSCalendarAdditons.h"
#import "../Common/TLLunarDate.h"

UIColor *UIColorMakeWithRGBValue(int value);

NSString * const kTLDatesAttributeKeyDate = @"date";
NSString * const kTLDatesAttributeKeyLunarDate = @"date.lunar";
NSString * const kTLDatesAttributeKeyFestival = @"fest";
NSString * const kTLDatesAttributeKeyFestivalIsLunar = @"fest.lunar";

@implementation TLWidgetView

@synthesize dataSource=_dataSource;
@synthesize backgroundImage=_backgroundImage;
@synthesize captionFont=_captionFont;
@synthesize weekdayFont=_weekdayFont;
@synthesize dayFont=_dayFont;
@synthesize lunarDayFont=_lunarDayFont;
@synthesize textColor=_textColor;
@synthesize weekdayTextColor=_weekdayTextColor;
@synthesize weekendTextColor=_weekendTextColor;
@synthesize currentMonthDayColor=_currentMonthDayColor;
@synthesize notCurrentMonthDayColor=_notCurrentMonthDayColor;
@synthesize todayHighlightColor=_todayHighlightColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        _captionFont = [[UIFont boldSystemFontOfSize:14.0f] retain];
        _weekdayFont = [[UIFont boldSystemFontOfSize:12.0f] retain];
        _dayFont = [[UIFont boldSystemFontOfSize:12.0f] retain];
        _lunarDayFont = [[UIFont boldSystemFontOfSize:8.0f] retain];
        _textColor = [[UIColor whiteColor] retain];
        _weekdayTextColor = [UIColorMakeWithRGBValue(0x4D79FF) retain];
        _weekendTextColor = [UIColorMakeWithRGBValue(0xFF4242) retain];
        _currentMonthDayColor = [[UIColor whiteColor] retain];
        _notCurrentMonthDayColor = [[UIColor lightGrayColor] retain];
        _todayHighlightColor = [UIColorMakeWithRGBValue(0x24FF5B) retain];
        
        _calendar = [[NSCalendar sharedCalendar] retain];
    }
    return self;
}

- (void)dealloc {
    [_dates release];
    [_dateComponents release];
    [_calendar release];
    
    [_captionFont release];
    [_weekdayFont release];
    [_dayFont release];
    [_lunarDayFont release];
    [_textColor release];
    [_weekdayTextColor release];
    [_weekendTextColor release];
    [_currentMonthDayColor release];
    [_notCurrentMonthDayColor release];
    [_todayHighlightColor release];
    
    [_backgroundImage release];
    
    [super dealloc];
}

- (NSDateComponents *)dateComponents {
    return [[_dateComponents retain] autorelease];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents {
    if (_dateComponents != dateComponents) {
        [_dateComponents release];
        _dateComponents = [dateComponents copy];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

- (NSDictionary *)datesAttributesForDate:(NSDate *)date {
    const static NSCalendarUnit unit = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit);
    NSDateComponents *comp = [_calendar components:unit fromDate:date];
    TLLunarDate *lunarDate = [[TLLunarDate alloc] initWithSolarDateComponents:comp];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dict setObject:comp forKey:kTLDatesAttributeKeyDate];
    [dict setObject:lunarDate forKey:kTLDatesAttributeKeyLunarDate];
    
    BOOL isLunar = NO;
    NSString *fest = [_dataSource widgetView:self solarFestivalForDateComponents:comp];
    if (fest == nil) {
        fest = [_dataSource widgetView:self lunarFestivalForDate:lunarDate];
        isLunar = YES;
    }
    if (fest) {
        [dict setObject:fest forKey:kTLDatesAttributeKeyFestival];
        [dict setObject:[NSNumber numberWithBool:isLunar] forKey:kTLDatesAttributeKeyFestivalIsLunar];
    }
    
    return [dict autorelease];
}

@end

UIColor *UIColorMakeWithRGBValue(int value) {
    float red = (value >> 16) / 255.0;
    float green = ((value & 0x00ff00) >> 8) / 255.0;
    float blue = (value & 0x0000ff) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
