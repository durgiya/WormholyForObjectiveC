//
//  WHBodyDetailViewController.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHBodyDetailViewController.h"
#import "WHRequestModelBeautifier.h"
#import "WHColors.h"

@interface WHBodyDetailViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@end

@implementation WHBodyDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textView.font = [UIFont fontWithName:@"Courier" size:14];
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareContent:)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
    self.navigationItem.rightBarButtonItems = @[searchButton, shareButton];

    self.buttonPrevious.enabled = NO;
    self.buttonNext.enabled = NO;
    [self addSearchController];
    
}

#pragma mark - Keyboard

- (void)handleKeyboardWillShow:(NSNotification *)sender {
    CGSize keyboardSize = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self animationInputViewWithHeight:-keyboardSize.height notification:sender];
}

- (void)handleKeyboardWillHide:(NSNotification *)sender {
    [self animationInputViewWithHeight:0.0 notification:sender];
}

- (void)animationInputViewWithHeight:(CGFloat)height notification:(NSNotification *)notification {
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.bottomViewInputConstraint.constant = height;
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)shareContent:(UIBarButtonItem *)sender {
    if (self.textView.text.length > 0) {
        NSArray *textShare = @[self.textView.text];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:textShare applicationActivities:nil];
        activityViewController.popoverPresentationController.barButtonItem = sender;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void)showSearch {
    self.searchController.active = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *hud = [self showLoader:self.view];
    [WHRequestModelBeautifier body:self.data splitLength:0 completion:^(NSString * _Nonnull formattedJSON) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.textView.text = formattedJSON;
            [self hideLoader:hud];
        });
    }];
}

#pragma mark - Search

- (void)addSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchController.searchBar.delegate = self;
    
    if (@available(iOS 9.1, *)) {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
        // Fallback
    }
    
    self.searchController.searchBar.placeholder = @"Search";
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.navigationItem.titleView = self.searchController.searchBar;
    }
    
    self.definesPresentationContext = YES;
}

- (void)previousStep:(UIBarButtonItem *)sender {
    self.indexOfWord -= 1;
    if (self.indexOfWord < 0) {
        self.indexOfWord = self.highlightedWords.count - 1;
    }
    
    [self getCursor];
}

- (void)getCursor {
    NSTextCheckingResult *value = [self.highlightedWords objectAtIndex:self.indexOfWord];
    UITextRange *range = [self.textView convertRange:value.range];
    if (range) {
        CGRect rect = [self.textView firstRectForRange:range];
        self.labelWordFinded.text = [NSString stringWithFormat:@"%zd of %lu", (long)(self.indexOfWord + 1), (unsigned long)self.highlightedWords.count];
        CGRect focusRect = {self.textView.contentOffset, self.textView.frame.size};
        if (CGRectContainsRect(focusRect, rect)) {
            [self.textView setContentOffset:CGPointMake(0, rect.origin.y - kPadding) animated:YES];
        }
        
        [self cursorAnimation:value.range];
    }
}

- (void)cursorAnimation:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSTextCheckingResult *value in self.highlightedWords) {
        [attributedString addAttributes:@{NSBackgroundColorAttributeName: WHColors.uiWordsInEvidence} range:value.range];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier-Bold" size:14]} range:value.range];
    }
    
    self.textView.attributedText = attributedString;
    
    [attributedString addAttributes:@{NSBackgroundColorAttributeName: WHColors.uiWordFocus} range:range];
    self.textView.attributedText = attributedString;
}

- (void)nextStep:(UIBarButtonItem *)sender {
    self.indexOfWord += 1;
    if (self.indexOfWord >= self.highlightedWords.count) {
        self.indexOfWord = 0;
    }
    
    [self getCursor];
}

- (void)resetSearchText {
    [self resetTextAttribute];
    
    self.labelWordFinded.text = @"0 of 0";
    self.buttonPrevious.enabled = NO;
    self.buttonNext.enabled = NO;
}

- (void)resetTextAttribute {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedString addAttributes:@{NSBackgroundColorAttributeName: UIColor.clearColor} range:NSMakeRange(0, self.textView.attributedText.length)];
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier" size:14]} range:NSMakeRange(0, self.textView.attributedText.length)];
    
    self.textView.attributedText = attributedString;
}

- (void)performSearch:(NSString *)text {
    [self.highlightedWords removeAllObjects];
    [self resetTextAttribute];
    
    self.highlightedWords = [self.textView highlights:text
                                                color:WHColors.uiWordsInEvidence
                                                 font:[UIFont fontWithName:@"Courier" size:14]
                                      highlightedFont:[UIFont fontWithName:@"Courier-Bold" size:14]];
    
    self.indexOfWord = 0;
    if (self.highlightedWords.count != 0) {
        [self getCursor];
        self.buttonPrevious.enabled = YES;
        self.buttonNext.enabled = YES;
    } else {
        self.buttonPrevious.enabled = NO;
        self.buttonNext.enabled = NO;
        self.labelWordFinded.text = @"0 of 0";
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text.length > 0) {
        [self performSearch:searchController.searchBar.text];
    } else {
        [self resetSearchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
