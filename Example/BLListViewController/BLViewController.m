//
//  BLViewController.m
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

#import "BLViewController.h"
#import "BLListViewController+Subclass.h"
#import <Parse/Parse.h>
#import "BLParseFetch.h"
#import "BLTestKeys.h"
#import "BLTestObject.h"

@interface BLViewController ()

@end

@implementation BLViewController

- (void)viewDidLoad
{
    [Parse setLogLevel:PFLogLevelDebug];
    [BLTestObject registerSubclass];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration>  _Nonnull configuration) {
        configuration.applicationId = BLTestAppId;
        configuration.clientKey = BLTestAppClientId;
        configuration.localDatastoreEnabled = YES;
        configuration.networkRetryAttempts = 2;
    }]];
    [super viewDidLoad];
}


- (id<BLBaseFetch>) fetch {
    if (![super fetch]) {
        BLParseFetch * parseFetch = [BLParseFetch new];
        parseFetch.queryBlock = ^() {
            return [BLTestObject query];
        };
        self.fetch = parseFetch;
    }
    return [super fetch];
}

-(void)customizeCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    BLTestObject * obj = [self.dataSource.dataStructure objectForIndexPath:indexPath];
    cell.textLabel.text = obj.testData;
}

@end
