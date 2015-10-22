//
//  LDTTabBarViewController.m
//  Lets Do This
//
//  Created by Aaron Schachter on 8/6/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTTabBarController.h"
#import "LDTUserProfileViewController.h"
#import "LDTCampaignListViewController.h"
#import "LDTOnboardingPageViewController.h"
#import "LDTTheme.h"

@implementation LDTTabBarController

- (id)init {
    if(self = [super init]) {
        self.tabBar.translucent = NO;
		[[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:[LDTTheme fontName] size:10.0f] } forState:UIControlStateNormal];

        LDTUserProfileViewController *profileVC = [[LDTUserProfileViewController alloc] initWithUser:[DSOUserManager sharedInstance].user];
        profileVC.title = @"Me";
        UINavigationController *profileNavVC = [[UINavigationController alloc] initWithRootViewController:profileVC];
        profileNavVC.tabBarItem.image = [UIImage imageNamed:@"Me Icon"];

        LDTCampaignListViewController *campaignListVC = [[LDTCampaignListViewController alloc] init];
        UINavigationController *campaignListNavVC = [[UINavigationController alloc] initWithRootViewController:campaignListVC];
        campaignListNavVC.tabBarItem.image = [UIImage imageNamed:@"Actions Icon"];

        self.viewControllers = [NSArray arrayWithObjects:campaignListNavVC, profileNavVC, nil];
    }
	
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![DSOUserManager sharedInstance].userHasCachedSession) {
        LDTOnboardingPageViewController *onboardingVC = [[LDTOnboardingPageViewController alloc] init];
        [self presentViewController:onboardingVC animated:NO completion:nil];
        [TSMessage setDefaultViewController:onboardingVC];
    }
}

@end
