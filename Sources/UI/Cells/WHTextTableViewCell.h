//
//  WHTextTableViewCell.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHTextTableViewCell : UITableViewCell

@property (weak) IBOutlet WHTextView *textView;

@end

NS_ASSUME_NONNULL_END
