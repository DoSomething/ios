//
//  DSOUserManager.h
//  Lets Do This
//
//  Created by Aaron Schachter on 7/23/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "DSOAPI.h"

@interface DSOUserManager : NSObject

// Stores the current/authenticated user.
@property (strong, nonatomic, readonly) DSOUser *user;

// Singleton object for accessing authenticated User, stored campaigns.
+ (DSOUserManager *)sharedInstance;

// Returns whether an authenticated user session has been saved.
- (BOOL)userHasCachedSession;

// Posts new user registration to API.
- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName mobile:(NSString *)mobile countryCode:(NSString *)countryCode deviceToken:(NSString *)deviceToken success:(void(^)(NSDictionary *))completionHandler failure:(void(^)(NSError *))errorHandler;

// Posts auth request to the API with given email and password of an existing user, and saves session tokens to remain authenticated upon future app usage.
- (void)loginWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void(^)(DSOUser *))completionHandler errorHandler:(void(^)(NSError *))errorHandler;

// Use saved session to set relevant DSOAPI headers and loads the current user.
- (void)continueSessionWithCompletionHandler:(void (^)(void))completionHandler errorHandler:(void(^)(NSError *))errorHandler;

// Logs out the user and deletes the current user and saved session tokens. Called when User logs out from Settings screen.
- (void)logoutWithCompletionHandler:(void(^)(void))completionHandler errorHandler:(void(^)(NSError *))errorHandler;

// Deletes the current user and saved session tokens, without making API request. Hack for now to solve for scenarios where logout request seems to complete but we didn't get a chance to delete the logged in user's saved session tokens.
- (void)forceLogout;

// Posts Signup to API, calls relevant GoogleAnalytics and React Native eventDispatcher.
- (void)signupForCampaign:(DSOCampaign *)campaign completionHandler:(void(^)(DSOSignup *))completionHandler errorHandler:(void(^)(NSError *))errorHandler;

// Posts Reportback to API, calls relevant GoogleAnalytics and React Native eventDispatcher.
- (void)reportbackForCampaign:(DSOCampaign *)campaign fileString:(NSString *)fileString caption:(NSString *)caption quantity:(NSInteger)quantity completionHandler:(void(^)(DSOReportback *))completionHandler errorHandler:(void(^)(NSError *))errorHandler;

// Posts Avatar to API, returns updated current user in completion handler.
- (void)postAvatarImage:(UIImage *)avatarImage completionHandler:(void(^)(DSOUser *))completionHandler errorHandler:(void(^)(NSError *))errorHandler ;

// Returns DSOCampaign from local storage, if exists.
- (DSOCampaign *)campaignWithID:(NSInteger)campaignID;

// Loads Campaign with given ID from the API, and stores locally.
- (void)loadAndStoreCampaignWithID:(NSInteger)campaignID completionHandler:(void(^)(DSOCampaign *))completionHandler errorHandler:(void(^)(NSError *))errorHandler;

@end
