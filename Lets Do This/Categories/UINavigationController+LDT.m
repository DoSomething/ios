//
//  UINavigationController+LDT.m
//  Lets Do This
//
//  Created by Aaron Schachter on 9/16/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "UINavigationController+LDT.h"
#import "LDTTheme.h"

@implementation UINavigationController (LDT)

- (void)styleNavigationBar:(LDTNavigationBarStyle)style {
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIStatusBarStyleLightContent;
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    titleBarAttributes[NSFontAttributeName] = [LDTTheme fontBold];
    titleBarAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = titleBarAttributes;
    if (style == LDTNavigationBarStyleNormal) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Header Background"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.translucent = NO;
        self.navigationBar.barStyle = UIStatusBarStyleLightContent;
    }
    else if (style == LDTNavigationBarStyleClear) {
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.backgroundColor = [UIColor clearColor];
        self.navigationBar.shadowImage = [UIImage new];
        self.navigationBar.translucent = YES;
        self.navigationBar.barTintColor = [UIColor clearColor];
    }

}

@end
