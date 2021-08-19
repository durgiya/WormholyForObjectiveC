//
//  WHBaseViewController.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHBaseViewController.h"

@interface WHBaseViewController ()

@end

@implementation WHBaseViewController

- (UIView *)showLoader:(UIView *)view {
    UIView *loaderView = [[UIView alloc] initWithFrame:view.bounds];
    loaderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = loaderView.center;
    [loaderView addSubview:indicator];
    [view addSubview:loaderView];
    [indicator startAnimating];
    [loaderView bringSubviewToFront:view];
    return loaderView;
}

- (void)hideLoader:(UIView *)loaderView {
    [loaderView removeFromSuperview];
}

@end
