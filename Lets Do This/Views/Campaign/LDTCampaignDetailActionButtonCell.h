//
//  LDTCampaignDetailActionButtonCell.h
//  Lets Do This
//
//  Created by Aaron Schachter on 10/13/15.
//  Copyright © 2015 Do Something. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDTCampaignDetailActionButtonCellDelegate;

@interface LDTCampaignDetailActionButtonCell : UICollectionViewCell

@property (weak, nonatomic) id<LDTCampaignDetailActionButtonCellDelegate> delegate;
@property (strong, nonatomic) NSString *actionButtonTitle;

@end

@protocol LDTCampaignDetailActionButtonCellDelegate <NSObject>

- (void)didClickActionButtonForCell:(LDTCampaignDetailActionButtonCell *)cell;

@end