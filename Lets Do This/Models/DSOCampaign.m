//
//  DSOCampaign.m
//  Pods
//
//  Created by Aaron Schachter on 3/4/15.
//
//

#import "DSOCampaign.h"
#import "NSDate+DSO.h"
#import "NSDictionary+DSOJsonHelper.h"

@interface DSOCampaign ()

@property (strong, nonatomic, readwrite) NSArray *tags;
@property (strong, nonatomic, readwrite) NSDate *endDate;
@property (assign, nonatomic, readwrite) NSInteger campaignID;
@property (strong, nonatomic, readwrite) NSString *coverImage;
@property (strong, nonatomic, readwrite) NSString *factProblem;
@property (strong, nonatomic, readwrite) NSString *factSolution;
@property (strong, nonatomic, readwrite) NSString *reportbackNoun;
@property (strong, nonatomic, readwrite) NSString *reportbackVerb;
@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *tagline;
@property (strong, nonatomic, readwrite) NSURL *coverImageURL;

@end

@implementation DSOCampaign

-(id)initWithDict:(NSDictionary*)values {
    self = [super init];

    if(self) {
        self.campaignID = [values valueForKeyAsInt:@"id" nullValue:self.campaignID];
        self.endDate = [[values valueForKeyPath:@"mobile_app.dates"] valueForKeyAsDate:@"end" nullValue:nil];
        self.title = [values valueForKeyAsString:@"title" nullValue:self.title];
        self.tagline = [values valueForKeyAsString:@"tagline" nullValue:self.tagline];
        self.coverImage = [[values valueForKeyPath:@"cover_image.default.sizes.landscape"] valueForKeyAsString:@"uri" nullValue:self.coverImage];
        self.reportbackNoun = [values valueForKeyPath:@"reportback_info.noun"];
        self.reportbackVerb = [values valueForKeyPath:@"reportback_info.verb"];
        self.factProblem = [values[@"facts"] valueForKeyAsString:@"problem" nullValue:self.factProblem];
        self.factSolution = [values[@"solutions.copy"] valueForKeyAsString:@"raw" nullValue:self.factSolution];
        self.tags = values[@"tags"];
    }
    return self;
}

- (NSURL *)coverImageURL {
    return [NSURL URLWithString:self.coverImage];
}

- (NSInteger)numberOfDaysLeft {
    if (!self.endDate) {
        return 0;
    }
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *components = [c components:NSCalendarUnitDay fromDate:today toDate:self.endDate options:0];

    if (components.day > 0) {
        return components.day;
    }
    return 0;
}

@end
