//
//  BLListViewController+Subclass.h
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

#import "BLListViewController.h"
#import "BLListDataSource.h"
#import "MJRefresh.h"

@interface BLListViewController () <BLDataSourceDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) BLListDataSource * dataSource;

- (UIView *) parentViewForTable;
- (void) initTableView;
- (void) reloadItemsFromSource;
- (void) updateItemAtIndex:(NSInteger) index;
#pragma mark - Abstract Methods
- (BLListDataSource *) createDataSource;
- (UITableViewCell *) createCellForIndexPath:(NSIndexPath *) indexPath;
- (void) customizeCell:(UITableViewCell *) cell forIndexPath:(NSIndexPath *) indexPath;
- (NSString *) reuseIdentifierForIndexPath:(NSIndexPath *) indexPath;
- (void) cellSelectedAtIndexPath:(NSIndexPath *) indexPath;

#pragma mark -
- (BOOL) loadMoreAvailable; // Default is YES. Asks subclasses whether it should create loadMoreController or not.
- (BOOL) refreshAvailable; // Default is YES. Asks subclasses whether it should create refreshController or not.
- (BOOL) invertRefreshActions; // Default is NO. Inver actions for refresh and load more controls. Used in reverse lists

#pragma mark -
- (void) showContent;
@end