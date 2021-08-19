//
//  WHRequestTitleSectionView.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHRequestTitleSectionView : UITableViewHeaderFooterView

@property (weak) IBOutlet WHLabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
