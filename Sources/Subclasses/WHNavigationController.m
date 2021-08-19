//
//  WHNavigationController.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHNavigationController.h"

@interface WHNavigationController ()

@end

@implementation WHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        navBarAppearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        navBarAppearance.backgroundColor = [UIColor systemBackgroundColor];
        self.navigationBar.standardAppearance = navBarAppearance;
        self.navigationBar.scrollEdgeAppearance = navBarAppearance;
        self.navigationBar.tintColor = [UIColor systemBlueColor];
    }
}

@end
