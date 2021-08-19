//
//  WHBaseViewController.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHBaseViewController : UIViewController

- (UIView *)showLoader:(UIView *)view;
- (void)hideLoader:(UIView *)loaderView;

@end

NS_ASSUME_NONNULL_END
