//
//  CampaignCollectionViewCellContainer.h
//  Lets Do This
//
//  Created by Evan Roth on 9/26/15.
//  Copyright © 2015 Do Something. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampaignCollectionViewCellContainer : UICollectionViewCell

@property (nonatomic, strong) UICollectionView *innerCollectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate;

@end
