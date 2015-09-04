//
//  NSDate+DSO.m
//  Pods
//
//  Created by Ryan Grimm on 4/27/15.
//
//

#import "NSDate+DSO.h"

static NSDateFormatter *_fromDateFormatter;
static NSDateFormatter *_toDateFormatter;

@implementation NSDate (DSO)

+ (NSDate *)dateFromISOString:(NSString *)dateString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fromDateFormatter = [[NSDateFormatter alloc] init];
        _fromDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _fromDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    });

    return [_fromDateFormatter dateFromString:dateString];
}

+ (NSDate *)dateFromISO8601String:(NSString *)dateString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fromDateFormatter = [[NSDateFormatter alloc] init];
        // Date string http://stackoverflow.com/a/16449665/1470725
        _fromDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
        _fromDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];;
    });

    return [_fromDateFormatter dateFromString:dateString];
}

- (NSString *)ISOString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _toDateFormatter = [[NSDateFormatter alloc] init];
        _toDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _toDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    });

    return [_toDateFormatter stringFromDate:self];
}

@end
