//
//  WHRequestDetailViewController.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHRequestDetailViewController.h"
#import "WHTableView.h"
#import "WHSection.h"
#import "WHBundle.h"
#import "WHShareUtils.h"
#import "WHRequestModelBeautifier.h"
#import "WHRequestTitleSectionView.h"
#import "WHTextTableViewCell.h"
#import "WHRequestModelBeautifier.h"
#import "WHActionableTableViewCell.h"
#import "WHBodyDetailViewController.h"
#import "WHStorage.h"

@interface WHRequestDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<WHSection *> *sections;
@property (nonatomic, strong) UIColor *labelTextColor;

@end

@implementation WHRequestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WHSection *setion1 = [[WHSection alloc] initWithName:@"Overview" type:WHSectionTypeOverview];
    WHSection *setion2 = [[WHSection alloc] initWithName:@"Request Header" type:WHSectionTypeRequestHeader];
    WHSection *setion3 = [[WHSection alloc] initWithName:@"Request Body" type:WHSectionTypeRequestBody];
    WHSection *setion4 = [[WHSection alloc] initWithName:@"Response Header" type:WHSectionTypeResponseHeader];
    WHSection *setion5 = [[WHSection alloc] initWithName:@"Response Body" type:WHSectionTypeResponseBody];
    self.sections = @[setion1, setion2, setion3, setion4, setion5];
    
    if (self.request.url.length > 0) {
        self.title = [NSURL URLWithString:self.request.url].path;
    }

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    self.navigationItem.rightBarButtonItems = @[shareButton];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WHTextTableViewCell" bundle:[WHBundle bundle]] forCellReuseIdentifier:@"WHTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WHActionableTableViewCell" bundle:[WHBundle bundle]] forCellReuseIdentifier:@"WHActionableTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WHRequestTitleSectionView" bundle:[WHBundle bundle]] forHeaderFooterViewReuseIdentifier:@"WHRequestTitleSectionView"];
}

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
//
//    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        ac.popoverPresentationController.barButtonItem = sender;
    }

    [self presentViewController:ac animated:YES completion:nil];
}

- (UIColor *)labelTextColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    } else {
        return [UIColor blackColor];
    }
}

#pragma mark - Actions

- (void)clearRequests {
    [[WHStorage sharedInstance] clearRequests];
}

- (void)shareContent:(UIBarButtonItem *)sender requestExportOption:(WHRequestResponseExportOption)requestExportOption {
    NSMutableArray *requests = [NSMutableArray arrayWithObject:self.request];
    [WHShareUtils shareRequests:self
                         sender:sender
                       requests:requests
            requestExportOption:requestExportOption];
}

#pragma mark - Navigation

- (void)openBodyDetailVC:(NSString *)title body:(NSData *)body {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Flow" bundle:[WHBundle bundle]];
    WHBodyDetailViewController *bodyDetailVC = (WHBodyDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WHBodyDetailViewController"];
    if (bodyDetailVC) {
        bodyDetailVC.title = title;
        bodyDetailVC.data = body;
        [self showViewController:bodyDetailVC sender:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WHRequestTitleSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WHRequestTitleSectionView"];
    header.titleLabel.text = [self.sections objectAtIndex:section].name;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.request == nil) {
        return [[UITableViewCell alloc] init];
    }
    
    WHSection *section = [self.sections objectAtIndex:indexPath.section];
    switch (section.type) {
        case WHSectionTypeOverview:
        {
            WHTextTableViewCell *cell = (WHTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WHTextTableViewCell" forIndexPath:indexPath];
            cell.textView.attributedText = [[WHRequestModelBeautifier overview:self.request] chageTextColor:self.labelTextColor];
            return cell;
        }
        case WHSectionTypeRequestHeader:
        {
            WHTextTableViewCell *cell = (WHTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WHTextTableViewCell" forIndexPath:indexPath];
            cell.textView.attributedText = [[WHRequestModelBeautifier header:self.request.headers] chageTextColor:self.labelTextColor];
            return cell;
        }
        case WHSectionTypeRequestBody:
        {
            WHActionableTableViewCell *cell = (WHActionableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WHActionableTableViewCell" forIndexPath:indexPath];
            cell.labelAction.text = @"View body";
            return cell;
        }
        case WHSectionTypeResponseHeader:
        {
            WHTextTableViewCell *cell = (WHTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WHTextTableViewCell" forIndexPath:indexPath];
            cell.textView.attributedText = [[WHRequestModelBeautifier header:self.request.responseHeaders] chageTextColor:self.labelTextColor];
            return cell;
        }
        case WHSectionTypeResponseBody:
        {
            WHActionableTableViewCell *cell = (WHActionableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WHActionableTableViewCell" forIndexPath:indexPath];
            cell.labelAction.text = @"View body";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WHSection *section = [self.sections objectAtIndex:indexPath.section];
    switch (section.type) {
        case WHSectionTypeRequestBody:
            [self openBodyDetailVC:@"Request Body" body:self.request.httpBody];
            break;
        case WHSectionTypeResponseBody:
            [self openBodyDetailVC:@"Response Body" body:self.request.dataResponse];
            break;
        default:
            break;
    }
}

@end
