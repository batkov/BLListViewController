//
//  BLListDataSource+Subclass.h
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

#import "BLListDataSource.h"
#import "BLDataSource+Subclass.h"
#import "BLPaging.h"
@class BLBaseFetchResult;

@interface BLListDataSource ()
@property (nonatomic, strong, readwrite, nullable) BLDataStructure * dataStructure;

@property (nonatomic, strong, readwrite, nonnull) id<BLBaseFetch> fetch;
@property (nonatomic, strong, readwrite, nullable) BLPaging * paging;
@property (nonatomic, assign) BOOL canLoadMore;

#pragma mark - 
- (BLDataStructure *__nonnull) dataStructureFromFetchResult:(BLBaseFetchResult *__nonnull) fetchResult;
- (BLBaseFetchResult * __nonnull) createFetchResultFor:(id __nullable)object;
- (BLBaseFetchResult * __nonnull) createFetchResultForLocalObject:(id __nullable)object;
- (void) processFetchResult:(BLBaseFetchResult *__nonnull) fetchResult;

- (void) updatePagingFlagsForListSize;
- (BOOL) shouldClearList;

- (BOOL) failIfNeeded:(NSError *__nullable)error;

@end