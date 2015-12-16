//
//  LDTCampaignListCampaignCell.m
//  Lets Do This
//
//  Created by Aaron Schachter on 8/7/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTCampaignListCampaignCell.h"

const CGFloat kCampaignImageViewConstantCollapsed = -25;
const CGFloat kCampaignImageViewConstantExpanded = 0;

@interface LDTCampaignListCampaignCell()

@property (nonatomic, assign) CGFloat collapsedTitleLabelTopLayoutConstraintConstant;
@property (weak, nonatomic) IBOutlet LDTButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *signupIndicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopLayoutConstraint;

- (IBAction)actionButtonTouchUpInside:(id)sender;

@end

@implementation LDTCampaignListCampaignCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self styleView];
    self.actionButton.hidden = YES;
}

- (void)styleView {
    self.titleLabel.font = LDTTheme.fontTitle;
    self.taglineLabel.font = LDTTheme.font;;
    self.titleLabel.textColor = UIColor.whiteColor;
    [self.imageView addGrayTintForFullScreenWidthImageView];
	
	self.imageViewTop.constant = kCampaignImageViewConstantCollapsed;
	self.imageViewBottom.constant = kCampaignImageViewConstantCollapsed;
}

- (void)setTitleLabelText:(NSString *)titleLabelText {
    self.titleLabel.text = titleLabelText.uppercaseString;

    if (!self.expanded) {
        // Get height of label after dynamic text is set, then set the constraint to center the text
        CGFloat labelHeight = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), NSIntegerMax)].height;
        self.titleLabelTopLayoutConstraint.constant = CGRectGetMidY(self.bounds) - labelHeight/2;

        // Store that value to use when we animate the cell back to the collapsed state
        self.collapsedTitleLabelTopLayoutConstraintConstant = self.titleLabelTopLayoutConstraint.constant;
    }

}

- (void)setTaglineLabelText:(NSString *)taglineLabelText {
    self.taglineLabel.text = taglineLabelText;
}

- (void)setImageViewImageURL:(NSURL *)imageURL {
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Placeholder Image Loading"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *url){
        if (!image) {
            [self.imageView setImage:[UIImage imageNamed:@"Placeholder Image Download Fails"]];
        }
    }];
}

- (void)setActionButtonTitle:(NSString *)actionButtonTitle {
    [self.actionButton setTitle:actionButtonTitle.uppercaseString forState:UIControlStateNormal];
}

- (IBAction)actionButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickActionButtonForCell:)]) {
        [self.delegate didClickActionButtonForCell:self];
    }
}

-(void)setExpanded:(BOOL)expanded {
	_expanded = expanded;
	
	if (expanded) {
		self.titleLabelTopLayoutConstraint.constant = CGRectGetHeight(self.imageView.bounds)-CGRectGetHeight(self.titleLabel.bounds)-10; // -10 for padding
		self.imageViewTop.constant = kCampaignImageViewConstantExpanded;
		self.imageViewBottom.constant = kCampaignImageViewConstantExpanded;
		[self.actionButton enable:YES];
        self.actionButton.hidden = NO;

		[self layoutIfNeeded];
	}
	else {
		self.imageViewTop.constant = kCampaignImageViewConstantCollapsed;
		self.imageViewBottom.constant = kCampaignImageViewConstantCollapsed;
		self.titleLabelTopLayoutConstraint.constant = self.collapsedTitleLabelTopLayoutConstraintConstant;
        self.actionButton.hidden = YES;
		
		[self layoutIfNeeded];
	}
}

- (void)setSignedUp:(BOOL)isSignedUp {
    if (isSignedUp) {
        self.signupIndicatorView.backgroundColor = [UIColor colorWithRed:141.0f/255.0f green:196.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
    }
    else {
        self.signupIndicatorView.backgroundColor = UIColor.clearColor;
    }
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [[super preferredLayoutAttributesFittingAttributes:layoutAttributes] copy];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGRect newFrame = attributes.frame;
    newFrame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    newFrame.size.height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    attributes.frame = newFrame;
    return attributes;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Subtract 16 for left/right margins of 8.
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 16;
    self.titleLabel.preferredMaxLayoutWidth = width;
    // Subtract 42 for left/right margins of 21.
    self.taglineLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 42;

    [super layoutSubviews];
}

@end
