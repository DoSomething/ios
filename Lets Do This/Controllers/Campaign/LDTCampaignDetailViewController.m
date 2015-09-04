//
//  LDTCampaignDetailViewController.m
//  Lets Do This
//
//  Created by Aaron Schachter on 7/30/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTCampaignDetailViewController.h"
#import "LDTTheme.h"
#import "LDTCampaignDetailCampaignCell.h"
#import "LDTCampaignDetailReportbackItemCell.h"
#import "LDTHeaderCollectionReusableView.h"
#import "LDTUserProfileViewController.h"

typedef NS_ENUM(NSInteger, LDTCampaignDetailSections) {
    LDTSectionTypeCampaign = 0,
    LDTSectionTypeReportback = 1
};

@interface LDTCampaignDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, LDTReportbackItemDetailViewDelegate>

@property (nonatomic, assign) BOOL isDoing;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, nonatomic) DSOCampaign *campaign;
@property (strong, nonatomic) NSMutableArray *reportbackItems;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LDTCampaignDetailViewController

#pragma mark - NSObject

- (instancetype)initWithCampaign:(DSOCampaign *)campaign {
    self = [super initWithNibName:@"LDTCampaignDetailView" bundle:nil];

    if (self) {
        self.campaign = campaign;
        self.reportbackItems = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.collectionView registerNib:[UINib nibWithNibName:@"LDTCampaignDetailCampaignCell" bundle:nil] forCellWithReuseIdentifier:@"CampaignCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LDTCampaignDetailReportbackItemCell" bundle:nil] forCellWithReuseIdentifier:@"ReportbackItemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LDTHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];

    [self styleView];

    [self fetchReportbackItems];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect rect = self.navigationController.navigationBar.frame;
    float y = -rect.origin.y;
    self.collectionView.contentInset = UIEdgeInsetsMake(y,0,0,0);
}

#pragma mark - LDTCampaignDetailViewController

- (void)styleView {
    LDTNavigationController *navVC = (LDTNavigationController *)self.navigationController;
    [navVC setClear];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
}

- (void)fetchReportbackItems {
    [[DSOAPI sharedInstance] fetchReportbackItemsForCampaigns:@[self.campaign] completionHandler:^(NSArray *rbItems) {
		[self.reportbackItems addObjectsFromArray:rbItems];
        [self.collectionView reloadData];
    } errorHandler:^(NSError *error) {
        [LDTMessage displayErrorMessageForError:error];
    }];
}

- (void)configureCampaignCell:(LDTCampaignDetailCampaignCell *)cell {
    cell.titleLabelText = self.campaign.title;
    cell.taglineLabelText = self.campaign.tagline;
    cell.problemLabelText = self.campaign.factProblem;
    cell.coverImageURL = self.campaign.coverImageURL;
    NSString *actionButtonTitle = @"Prove it";
    if ([[DSOUserManager sharedInstance].user hasCompletedCampaign:self.campaign]) {
        actionButtonTitle = @"Proved it";
    }
    cell.actionButtonTitle = actionButtonTitle;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == LDTSectionTypeReportback) {	
        return self.reportbackItems.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == LDTSectionTypeCampaign) {
        LDTCampaignDetailCampaignCell *cell = (LDTCampaignDetailCampaignCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CampaignCell" forIndexPath:indexPath];
        [self configureCampaignCell:cell];
        return cell;
    }

    if (indexPath.section == LDTSectionTypeReportback) {
        DSOReportbackItem *reportbackItem = self.reportbackItems[indexPath.row];
        LDTCampaignDetailReportbackItemCell *cell = (LDTCampaignDetailReportbackItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ReportbackItemCell" forIndexPath:indexPath];
        cell.reportbackItemDetailView.reportbackItem = reportbackItem;
        cell.reportbackItemDetailView.delegate = self;
        [cell.reportbackItemDetailView displayForReportbackItem];
        return cell;
    }

    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        LDTHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = [@"Who's doing it now" uppercaseString];
        reusableView = headerView;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = 440;
    if (indexPath.section == LDTSectionTypeCampaign) {
        // @todo: Should this be dynamic based on the campaign content?
        height = 350;
    }
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == LDTSectionTypeReportback) {
        // Width is ignored here.
        return CGSizeMake(60.0f, 50.0f);
    }
    return CGSizeMake(0.0f, 0.0f);
}

# pragma mark - LDTReportbackItemDetailViewDelegate

- (void)didClickCampaignTitleButtonForReportbackItemDetailView:(LDTReportbackItemDetailView *)reportbackItemDetailView {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)didClickUserNameButtonForReportbackItemDetailView:(LDTReportbackItemDetailView *)reportbackItemDetailView {
    LDTUserProfileViewController *destVC = [[LDTUserProfileViewController alloc] initWithUser:reportbackItemDetailView.reportbackItem.user];
    [self.navigationController pushViewController:destVC animated:YES];
}

@end
