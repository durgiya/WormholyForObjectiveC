//
//  WHBodyDetailViewController.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHBaseViewController.h"
#import "WHTextView.h"

static CGFloat kPadding = 10.0;

NS_ASSUME_NONNULL_BEGIN

@interface WHBodyDetailViewController : WHBaseViewController

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomViewInputConstraint;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UILabel *labelWordFinded;
@property (nonatomic, weak) IBOutlet WHTextView *textView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonPrevious;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonNext;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<NSTextCheckingResult *> *highlightedWords;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger indexOfWord;

@end

NS_ASSUME_NONNULL_END
