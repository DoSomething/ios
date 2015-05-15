//
//  LDTCampaignActionsViewController.m
//  Lets Do This
//
//  Created by Ryan Grimm on 4/2/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTCampaignActionsViewController.h"
#import "LDTCampaignActionsLayout.h"
#import "LDTCampaignCollectionCell.h"
#import "DSOCampaign.h"

@interface LDTCampaignActionsViewController ()
@property (nonatomic, strong) NSArray *campaigns;
@property (nonatomic, weak) IBOutlet LDTCampaignActionsLayout *layout;
@end

@implementation LDTCampaignActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.campaigns = [DSOCampaign MR_findAllSortedBy:@"title" ascending:YES];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.campaigns.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LDTCampaignCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CampaignCell" forIndexPath:indexPath];
    cell.campaign = self.campaigns[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end
