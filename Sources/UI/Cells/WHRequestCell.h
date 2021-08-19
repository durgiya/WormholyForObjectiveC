//
//  WHRequestCell.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHLabel.h"
#import "WHRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHRequestCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet WHLabel *methodLabel;
@property (nonatomic, weak) IBOutlet WHLabel *codeLabel;
@property (nonatomic, weak) IBOutlet WHLabel *urlLabel;
@property (nonatomic, weak) IBOutlet WHLabel *durationLabel;

- (void)populate:(WHRequestModel *)request;

@end

NS_ASSUME_NONNULL_END
