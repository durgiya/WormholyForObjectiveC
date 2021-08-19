//
//  WHRequestsViewController.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHBaseViewController.h"
#import "WHCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHRequestsViewController : WHBaseViewController

@property (nonatomic, weak) IBOutlet WHCollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
