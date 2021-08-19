//
//  WHRequestsViewController.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHRequestsViewController.h"
#import "WHCollectionView.h"
#import <WHRequestModel.h>
#import "WHBundle.h"
#import "WHStorage.h"
#import "WHRequestModelBeautifier.h"
#import "WHShareUtils.h"
#import "WHRequestCell.h"
#import "WHRequestDetailViewController.h"

@interface WHRequestsViewController () <UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<WHRequestModel *> *filteredRequests;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation WHRequestsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSearchController];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WHRequestCell" bundle:[WHBundle bundle]] forCellWithReuseIdentifier:@"WHRequestCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

- (void)addSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    if (@available(iOS 9.1, *)) {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    }
    
    self.searchController.searchBar.placeholder = @"Search URL";
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.navigationItem.titleView = self.searchController.searchBar;
    }
    
    self.definesPresentationContext = YES;
    self.filteredRequests = [[WHStorage sharedInstance].requests mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"wormholy_new_request" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.filteredRequests = [self filterRequestsWithKeyword:self.searchController.searchBar.text];
            [self.collectionView reloadData];
        });
    }];
}

- (NSMutableArray<WHRequestModel *> *)filterRequestsWithKeyword:(NSString *)text {
    if (text.length == 0) {
        return [[WHStorage sharedInstance].requests mutableCopy];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (WHRequestModel *model in [WHStorage sharedInstance].requests) {
        NSRange range = [model.url rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length != 0) {
            [result addObject:model];
        }
    }
    
    return result;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 76);
        [self.collectionView reloadData];
    }];
}

#pragma mark - Actions

- (void)openActionSheet:(UIBarButtonItem *)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Wormholy" message:@"Choose an option" preferredStyle:UIAlertControllerStyleActionSheet] ;
    [ac addAction:[UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearRequests];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareContent:sender requestExportOption:WHRequestResponseExportOptionFlat];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"Share as cURL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareContent:sender requestExportOption:WHRequestResponseExportOptionCurl];
    }]];
    
//    [ac addAction:[UIAlertAction actionWithTitle:@"Share as Postman Collection" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        ac.popoverPresentationController.barButtonItem = sender;
    }
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearRequests {
    [[WHStorage sharedInstance] clearRequests];
    self.filteredRequests = [NSMutableArray array];
    [self.collectionView reloadData];
}

- (void)shareContent:(UIBarButtonItem *)sender requestExportOption:(WHRequestResponseExportOption)requestExportOption {
    [WHShareUtils shareRequests:self sender:sender requests:self.filteredRequests requestExportOption:requestExportOption];
}

- (void)openRequestDetailVC:(WHRequestModel *)request {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Flow" bundle:[WHBundle bundle]];
    WHRequestDetailViewController *requestDetailVC = (WHRequestDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WHRequestDetailViewController"];
    if (requestDetailVC) {
        requestDetailVC.request = request;
        [self showViewController:requestDetailVC sender:self];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredRequests.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WHRequestCell *cell = (WHRequestCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WHRequestCell" forIndexPath:indexPath];
    [cell populate:[self.filteredRequests objectAtIndex:indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self openRequestDetailVC:[self.filteredRequests objectAtIndex:indexPath.item]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width, 76);
}


#pragma mark - UISearchResultsUpdating Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.filteredRequests = [self filterRequestsWithKeyword:self.searchController.searchBar.text];
    [self.collectionView reloadData];
}

@end
