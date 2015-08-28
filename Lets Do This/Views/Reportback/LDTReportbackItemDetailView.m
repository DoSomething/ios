//
//  LDTReportbackItemDetailView.m
//  Lets Do This
//
//  Created by Aaron Schachter on 8/26/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTReportbackItemDetailView.h"
#import "LDTTheme.h"

@interface LDTReportbackItemDetailView ()

@property (weak, nonatomic) IBOutlet UIButton *campaignTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *userDisplayNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *reportbackItemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userCountryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportbackItemCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportbackItemQuantityLabel;

- (IBAction)campaignTitleButtonTouchUpInside:(id)sender;
- (IBAction)userNameButtonTouchUpInside:(id)sender;

@end

@implementation LDTReportbackItemDetailView

- (void)awakeFromNib {
    [self styleView];

}

- (void)displayForReportbackItem:(DSOReportbackItem *)reportbackItem {
    [self.campaignTitleButton setTitle:reportbackItem.campaign.title forState:UIControlStateNormal];
    self.reportbackItemQuantityLabel.text = [NSString stringWithFormat:@"%li %@ %@", reportbackItem.quantity, reportbackItem.campaign.reportbackNoun, reportbackItem.campaign.reportbackVerb];
    self.reportbackItemCaptionLabel.text = reportbackItem.caption;
    [self.reportbackItemImageView sd_setImageWithURL:reportbackItem.imageURL];
    self.userAvatarImageView.image = reportbackItem.user.photo;
    [self.userDisplayNameButton setTitle:[reportbackItem.user displayName] forState:UIControlStateNormal];
    self.userCountryNameLabel.text = reportbackItem.user.countryName;
}

- (void)styleView {
    self.campaignTitleButton.titleLabel.font = [LDTTheme fontBold];
    self.reportbackItemCaptionLabel.font = [LDTTheme font];
    self.reportbackItemQuantityLabel.font = [LDTTheme fontCaptionBold];
    self.reportbackItemQuantityLabel.textColor = [LDTTheme mediumGrayColor];
    self.userCountryNameLabel.font = [LDTTheme fontCaption];
    self.userCountryNameLabel.textColor = [LDTTheme mediumGrayColor];
    self.userDisplayNameButton.titleLabel.font = [LDTTheme fontBold];
}

- (IBAction)campaignTitleButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCampaignTitleButtonForReportbackItemDetailView:)]) {
        [self.delegate didClickCampaignTitleButtonForReportbackItemDetailView:self];
    }
}

- (IBAction)userNameButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUserNameButtonForReportbackItemDetailView:)]) {
        [self.delegate didClickUserNameButtonForReportbackItemDetailView:self];
    }
}

@end