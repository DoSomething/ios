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

@property (assign, nonatomic, readwrite) BOOL isCoverImageDarkBackground;
@property (strong, nonatomic, readwrite) DSOCause *cause;
@property (strong, nonatomic, readwrite) NSArray *tags;
@property (strong, nonatomic, readwrite) NSDate *endDate;
@property (strong, nonatomic, readwrite) NSDictionary *dictionary;
@property (assign, nonatomic, readwrite) NSInteger campaignID;
@property (strong, nonatomic, readwrite) NSString *coverImage;
@property (strong, nonatomic, readwrite) NSString *reportbackNoun;
@property (strong, nonatomic, readwrite) NSString *reportbackVerb;
@property (strong, nonatomic, readwrite) NSString *solutionCopy;
@property (strong, nonatomic, readwrite) NSString *solutionSupportCopy;
@property (strong, nonatomic, readwrite) NSString *status;
@property (strong, nonatomic, readwrite) NSString *tagline;
@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *type;
@property (strong, nonatomic, readwrite) NSURL *coverImageURL;

@end

@implementation DSOCampaign

- (instancetype)initWithCampaignID:(NSInteger)campaignID {
    self = [super init];

    if (self) {
        _campaignID = campaignID;
    }
    return self;
}


- (instancetype)initWithCampaignID:(NSInteger)campaignID title:(id)title {
    self = [super init];

    if (self) {
        _campaignID = campaignID;
        _title = title;
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary*)values {
    self = [super init];

    if (self) {
        _campaignID = [values valueForKeyAsInt:@"id" nullValue:0];
        _title = [values valueForKeyAsString:@"title" nullValue:@""];
        _status = [values valueForKeyAsString:@"status" nullValue:@"closed"];
        _type = [values valueForKeyAsString:@"type" nullValue:@""];
        NSDictionary *causeDict = [values valueForKeyPath:@"causes.primary"];
        _cause = [[DSOCause alloc] initWithPhoenixDict:causeDict];
        _tagline = [values valueForKeyAsString:@"tagline" nullValue:@""];
        _coverImage = [[values valueForKeyPath:@"cover_image.default.sizes.landscape"] valueForKeyAsString:@"uri" nullValue:@""];;
        _reportbackNoun = [values valueForKeyPath:@"reportback_info.noun"];
        _reportbackVerb = [values valueForKeyPath:@"reportback_info.verb"];
        _solutionCopy = [[values valueForKeyPath:@"solutions.copy"] valueForKeyAsString:@"raw" nullValue:@""];
        if ([values[@"solutions"] objectForKey:@"support_copy"]) {
            // Might be string: see https://github.com/DoSomething/phoenix/issues/5069
            if ([[values[@"solutions"] objectForKey:@"support_copy"] isKindOfClass:[NSString class]]) {
                _solutionSupportCopy = [values valueForKeyPath:@"solutions.support_copy"];
            }
            else {
                _solutionSupportCopy = [[values valueForKeyPath:@"solutions.support_copy"] valueForKeyAsString:@"raw" nullValue:@""];
            }
        }
        _tags = values[@"tags"];
    }
	
    return self;
}

- (NSURL *)coverImageURL {
    return [NSURL URLWithString:self.coverImage];
}

- (NSDictionary *)dictionary {
    NSString *coverImage;
    if (self.coverImage) {
        coverImage = self.coverImage;
    }
    else {
        coverImage = @"";
    }
    // @todo This is hack for default solutionCopy nullValue not being set
    if (!self.solutionCopy) {
        self.solutionCopy = @"";
    }
    if (!self.solutionSupportCopy) {
        self.solutionSupportCopy = @"";
    }
    NSDictionary *reportbackInfo = @{@"noun" : self.reportbackNoun, @"verb" : self.reportbackVerb};
    NSDictionary *dict = @{
             @"id" : [NSNumber numberWithInteger:self.campaignID],
             @"status": self.status,
             @"title" : self.title,
             @"image_url" : coverImage,
             @"tagline" : self.tagline,
             @"type" : self.type,
             @"reportback_info" : reportbackInfo,
             @"solutionCopy" : self.solutionCopy,
             @"solutionSupportCopy" : self.solutionSupportCopy,
             };
    return dict;
}

@end
