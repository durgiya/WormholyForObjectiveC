//
//  WHCustomActivity.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHCustomActivity : UIActivity

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image performAction:(void (^)(NSArray *))performAction;

@end

NS_ASSUME_NONNULL_END
