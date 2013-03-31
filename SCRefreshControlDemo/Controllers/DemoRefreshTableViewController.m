//
//  DemoRefreshTableViewController.m
//  SCRefreshControlDemo
//
//  Created by Sebastien Couture on 13-03-24.
//  Copyright (c) 2013 Sebastien Couture. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "DemoRefreshTableViewController.h"

#import "SCRefreshControl.h"

@interface DemoRefreshTableViewController ()

- (void)startRefreshHandler:(SCRefreshControl *)sender;
- (void)endRefreshHandler:(NSTimer *)sender;

@end

@implementation DemoRefreshTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refresh = [[SCRefreshControl alloc] init];
    
    [self.refresh addTarget:self action:@selector(startRefreshHandler:) forControlEvents:UIControlEventValueChanged];
    
    self.refresh.lastUpdateTitle = @"Last Updated: Never";
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - SCRefreshControl

- (void)startRefreshHandler:(SCRefreshControl *)sender
{
    // Implement logic for refresh here, for the demo just wait 2 seconds
    // before ending the refresh
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(endRefreshHandler:) userInfo:nil repeats:NO];
}

#pragma mark -

- (void)endRefreshHandler:(NSTimer *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    
    NSDate *now = [NSDate date];
    
    self.refresh.lastUpdateTitle =
    [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:now]];
    
    [self.refresh endRefreshing];
}

@end
