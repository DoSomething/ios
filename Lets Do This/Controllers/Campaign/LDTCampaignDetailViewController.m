//
//  LDTCampaignDetailViewController.m
//  Lets Do This
//
//  Created by Aaron Schachter on 7/30/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "LDTCampaignDetailViewController.h"
#import "LDTTheme.h"

@interface LDTCampaignDetailViewController ()

@property (nonatomic, assign) BOOL isDoing;
@property (nonatomic, assign) BOOL isCompleted;
@property (strong, nonatomic) DSOCampaign *campaign;

@property (weak, nonatomic) IBOutlet LDTButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)actionButtonTouchUpInside:(id)sender;

@end

@implementation LDTCampaignDetailViewController

#pragma mark - NSObject

- (instancetype)initWithCampaign:(DSOCampaign *)campaign {
    self = [super initWithNibName:@"LDTCampaignDetailView" bundle:nil];

    if (self) {
        self.campaign = campaign;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self styleView];

    self.titleLabel.text = [self.campaign.title uppercaseString];
    self.taglineLabel.text = self.campaign.tagline;
    self.problemLabel.text = self.campaign.factProblem;
    [self.coverImageView sd_setImageWithURL:self.campaign.coverImageURL];
    self.isDoing = [[DSOUserManager sharedInstance].user isDoingCampaign:self.campaign];

    [self setActionButton];
}

#pragma mark - LDTCampaignDetailViewController

- (void)styleView {
    LDTNavigationController *navVC = (LDTNavigationController *)self.navigationController;
    [navVC setClear];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;

    self.titleLabel.font  = [LDTTheme fontTitle];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.taglineLabel.font = [LDTTheme font];
    self.taglineLabel.textColor = [UIColor whiteColor];
    self.problemLabel.font = [LDTTheme font];
    [self.coverImageView addGrayTint];
}

- (void)setActionButton {
    [self.actionButton enable];
    NSString *title = @"Do this now";
    if (self.isDoing) {
        title = @"Prove it";
    }
    [self.actionButton setTitle:[title uppercaseString] forState:UIControlStateNormal];
}

- (IBAction)actionButtonTouchUpInside:(id)sender {
    if (self.isDoing) {
        return;
    }
    [[DSOUserManager sharedInstance] signupForCampaign:self.campaign completionHandler:^(NSDictionary *response) {
         [self.actionButton setTitle:[@"Prove it" uppercaseString] forState:UIControlStateNormal];
    }
     errorHandler:^(NSError *error) {
         [LDTMessage displayErrorMessageForError:error];
     }];
}

@end
