//
//  BLListViewController.m
//  https://github.com/batkov/BLListViewController
//
// Copyright (c) 2016 Hariton Batkov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "BLListViewController+Subclass.h"
#import "NSDate+DateTools.h"
#import <QuartzCore/QuartzCore.h>

NSString * const kBLListDataSourceDefaultIdentifier = @"kBLListDataSourceDefaultIdentifier";
NSString * const kBLDataSourceLastUpdatedKey = @"lastUpdated_%@";

@implementation BLListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self setupUI];
}

#pragma mark - Table
- (UIView *) parentViewForTable {
    return self.view;
}

- (void) initTableView {
    if (self.tableView) {
        return;
    }
    UIView * parentView = [self parentViewForTable];
    self.tableView = [[UITableView alloc] initWithFrame:parentView.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:self.tableView];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.0]];
    //self.view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureRefreshController];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

- (void) reloadItemsFromSource {
    [self.tableView reloadData];
}

- (void) configureRefreshController {
    __weak typeof(self) weakSelf = self;
    if ([self invertRefreshActions]) {
        if ([self refreshAvailable]) {
            MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf pullToLoadMoreRaised];
            }];
            [header setTitle:@"Pull down to load more" forState:MJRefreshStateIdle];
            [header setTitle:@"Release to refresh"  forState:MJRefreshStatePulling];
            [header setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
            [header setTitle:@" " forState:MJRefreshStateNoMoreData];
            
            
            header.lastUpdatedTimeText =  ^(NSDate *lastUpdatedTime) {
                return lastUpdatedTime ? [NSString stringWithFormat:@"Last updated:%@", [NSDate timeAgoSinceDate:lastUpdatedTime]] : nil;
            };
            header.lastUpdatedTimeKey = [self lastUpdatedKey];
            
            self.tableView.mj_header = header;
        }
        if ([self loadMoreAvailable]) {
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf pullToRefreshRaised];
            }];
            [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
            [footer setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
            
            self.tableView.mj_footer = footer;
        }
    } else {
        if ([self refreshAvailable]) {
            MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf pullToRefreshRaised];
            }];
            [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
            [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
            [header setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
            
            header.lastUpdatedTimeText =  ^(NSDate *lastUpdatedTime) {
                return lastUpdatedTime ? [NSString stringWithFormat:@"Last updated:%@", [NSDate timeAgoSinceDate:lastUpdatedTime]] : nil;
            };
            header.lastUpdatedTimeKey = [self lastUpdatedKey];
            
            self.tableView.mj_header = header;
        }
        if ([self loadMoreAvailable]) {
            MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf pullToLoadMoreRaised];
            }];
            [footer setTitle:@"Click or drag up to load more" forState:MJRefreshStateIdle];
            [footer setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
            [footer setTitle:@" " forState:MJRefreshStateNoMoreData];
            
            self.tableView.mj_footer = footer;
        }
    }
    
    [self dataSource:self.dataSource stateChanged:self.dataSource.state];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.layer removeAllAnimations];
    });
}

- (void) setupUI {
    if (!self.tableView) {
        return;
    }
    self.dataSource = [self createDataSource];
    NSAssert(self.dataSource, @"You need to implement - createDataSource");
    __weak typeof(self) weakSelf = self;
    self.dataSource.itemsChangedBlock = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadItemsFromSource];
        });
    };
    [self.dataSource startContentLoading];
}

- (void) pullToRefreshRaised {
    [self.dataSource refreshContentIfPossible];
}

- (void) pullToLoadMoreRaised {
    [self.dataSource loadMoreIfPossible];
}

- (void) dealloc {
    self.dataSource = nil;
}

#pragma mark - Data Source
- (void) setDataSource:(BLListDataSource *)dataSource {
    if (_dataSource) {
        _dataSource.delegate = nil;
    }
    _dataSource = dataSource;
    if (_dataSource) {
        _dataSource.delegate = self;
    }
}

- (void) dataSource:(BLDataSource *)dataSource stateChanged:(BLDataSourceState)state {
    switch (state) {
        case BLDataSourceStateInit:
        case BLDataSourceStateLoadContent:
            break;
        case BLDataSourceStateError:
            [self showError];
            break;
        case BLDataSourceStateNoContent:
            [self showNoContent];
            break;
        case BLDataSourceStateRefreshContent:
            [self showRefreshing];
            break;
        case BLDataSourceStateContent:
            [self showContent];
            break;
    }
}

#pragma mark - TableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource.dataStructure sectionsCount];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource.dataStructure itemsCountForSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * reuseIdentifier = [self reuseIdentifierForIndexPath:indexPath];
    NSAssert(reuseIdentifier, @"Cannot handle nil value of reuseIdentifierForIndexPath:");
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [self createCellForIndexPath:indexPath];
        NSAssert(cell, @"Cannot handle nil value of createCellForIndexPath:");
    }
    [self customizeCell:cell forIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self cellSelectedAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) updateItemAtIndex:(NSInteger) index {
    NSUInteger section = 0;
    NSAssert(index >= 0 && index < [self tableView:self.tableView
                             numberOfRowsInSection:section], @"index out of bounds");
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BLListDataSource *) createDataSource {
    NSAssert(self.fetch, @"You need to provide fetch before -createDataSource called");
    return [[BLListDataSource alloc] initWithFetch:self.fetch]; // For subclassing
}

- (UITableViewCell *) createCellForIndexPath:(NSIndexPath *) indexPath {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kBLListDataSourceDefaultIdentifier]; // For subclassing
}

- (NSString *) reuseIdentifierForIndexPath:(NSIndexPath *) indexPath {
    return kBLListDataSourceDefaultIdentifier; // For subclassing
}

#pragma mark - Abstract Methods
- (void) customizeCell:(UITableViewCell *) cell forIndexPath:(NSIndexPath *) indexPath {
    // Do nothing. For subclassing
}

- (void) cellSelectedAtIndexPath:(NSIndexPath *) indexPath {
    
}

#pragma mark - Top Info
- (BOOL) shouldShowContent {
    return ![self.dataSource hasContent];
}

- (void) showLoading {
    MJRefreshFooter * footer = self.tableView.mj_footer;
    MJRefreshHeader * header = self.tableView.mj_header;
    if ([self invertRefreshActions]) {
        if (!footer.isRefreshing && !header.isRefreshing)
            [footer beginRefreshing];
        if ([footer isRefreshing])
            header.hidden = YES;
    } else {
        if (!header.isRefreshing && !footer.isRefreshing)
            [header beginRefreshing];
        if ([header isRefreshing])
            footer.hidden = YES;
    }
}

- (void) showNoContent {
    [self stopLoading:YES];
    if ([self invertRefreshActions]) {
        self.tableView.mj_header.hidden = YES;
    } else {
        self.tableView.mj_footer.hidden = YES;
    }
}

- (void) showError {
    [self stopLoading:NO];
    if ([self invertRefreshActions]) {
        self.tableView.mj_header.hidden = YES;
    } else {
        self.tableView.mj_footer.hidden = YES;
    }
}

- (void) showContent {
    [self stopLoading:YES];
}

- (void) showRefreshing {
    if (![self.tableView.mj_header isRefreshing]) {
        self.tableView.mj_header.hidden = YES;
    } else {
        self.tableView.mj_footer.hidden = YES;
    }
}

- (void) stopLoading:(BOOL) updateTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.tableView.mj_footer.hidden = NO;
        self.tableView.mj_header.hidden = NO;
        
        if ([self invertRefreshActions]) {
            if ([self.dataSource canLoadMore] ) {
                self.tableView.mj_header.state = MJRefreshStateIdle;
            } else {
                self.tableView.mj_header.state = MJRefreshStateNoMoreData;
            }
        } else {
            if ([self.dataSource canLoadMore] ) {
                [self.tableView.mj_footer resetNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    });    
}

- (BOOL) loadMoreAvailable {
    return self.dataSource.pagingEnabled;
}

- (BOOL) refreshAvailable {
    return YES;
}

- (BOOL) invertRefreshActions {
    return NO;
}

- (NSString *) lastUpdatedKey {
    return [NSString stringWithFormat:kBLDataSourceLastUpdatedKey, NSStringFromClass([self class])];
}

@end
