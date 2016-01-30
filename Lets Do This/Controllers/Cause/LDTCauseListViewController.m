//
//  LDTCauseListViewController.m
//  Lets Do This
//
//  Created by Aaron Schachter on 1/4/16.
//  Copyright © 2016 Do Something. All rights reserved.
//

#import "LDTCauseListViewController.h"
#import "LDTTheme.h"
#import "LDTCauseDetailViewController.h"
#import "GAI+LDT.h"
#import "LDTAppDelegate.h"
#import <RCTBridgeModule.h>
#import <RCTRootView.h>

@interface LDTCauseListViewController () <RCTBridgeModule>

@property (strong, nonatomic) NSArray *causes;

@end

@implementation LDTCauseListViewController

RCT_EXPORT_MODULE();

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self styleView];

    self.causes = [[NSArray alloc] init];
    self.title = @"Actions";
    self.navigationItem.title = @"Let's Do This".uppercaseString;

    NSURL *jsCodeLocation = ((LDTAppDelegate *)[UIApplication sharedApplication].delegate).jsCodeLocation;
    NSString *causeURLString = [NSString stringWithFormat:@"%@terms?vid=2", [DSOAPI sharedInstance].phoenixApiURL];
    NSDictionary *initialProperties = @{@"url" : causeURLString};
    RCTRootView *rootView =[[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName: @"CauseListView" initialProperties:initialProperties launchOptions:nil];
    self.view = rootView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController styleNavigationBar:LDTNavigationBarStyleNormal];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.hidesBarsOnSwipe = NO;
    [[GAI sharedInstance] trackScreenView:@"cause-list"];
}

#pragma mark - LDTCauseListViewController

- (void)styleView {
    [self styleBackBarButton];
}

#pragma mark - RCTBridgeModule

RCT_EXPORT_METHOD(presentCauseWithCauseID:(NSDictionary *)causeDict) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        // This is the worst.
        // May need to look into creating a separate UIView and then adding our ReactView as a subview: http://stackoverflow.com/questions/29597610/cant-push-a-native-view-controller-from-a-react-native-click

        UINavigationController *navigationController = keyWindow.rootViewController.childViewControllers[1];
        DSOCause *cause = [[DSOCause alloc] initWithDict:causeDict];
        LDTCauseDetailViewController *causeDetailViewController = [[LDTCauseDetailViewController alloc] initWithCause:cause];
        [navigationController pushViewController:causeDetailViewController animated:YES];
    });
}

@end
