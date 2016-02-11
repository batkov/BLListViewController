//
//  BLListDataSource.h
//  https://github.com/batkov/BLDataSource
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

#import "BLDataSource.h"
#import "BLDataStructure.h"
#import "BLBaseFetch.h"
#import "BLPaging.h"

@interface BLListDataSource : BLDataSource
@property (nonatomic, assign) BLFetchMode fetchMode; // BLFetchModeOnlineOffline by default
@property (nonatomic, strong, readonly) BLDataStructure * dataStructure;

@property (nonatomic, assign) BOOL pagingEnabled; // YES by default
@property (nonatomic, strong, readonly) BLPaging * paging;
@property (nonatomic, assign, readonly) BOOL canLoadMore;

@property (nonatomic, copy) dispatch_block_t itemsChangedBlock;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithFetch:(id<BLBaseFetch>) fetch NS_DESIGNATED_INITIALIZER;

- (BOOL) refreshContentIfPossible;
- (BOOL) loadMoreIfPossible;

@end