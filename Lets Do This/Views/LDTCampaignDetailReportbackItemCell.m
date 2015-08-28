//
//  LDTCampaignDetailReportbackItemCell.m
//  Lets Do This
//
//  Created by Aaron Schachter on 8/27/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTCampaignDetailReportbackItemCell.h"

@interface LDTCampaignDetailReportbackItemCell ()

@end

@implementation LDTCampaignDetailReportbackItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)displayForReportbackItem:(DSOReportbackItem *)reportbackItem  tag:(NSInteger)tag{
    [self.reportbackItemDetailView displayForReportbackItem:reportbackItem];
    self.reportbackItemDetailView.tag = tag;
}
@end
