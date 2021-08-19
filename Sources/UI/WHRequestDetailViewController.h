//
//  WHRequestDetailViewController.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHBaseViewController.h"
#import "WHRequestModel.h"
#import "WHTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHRequestDetailViewController : WHBaseViewController

@property (nonatomic, strong) WHRequestModel *request;
@property (nonatomic, weak) IBOutlet WHTableView *tableView;

@end

NS_ASSUME_NONNULL_END
