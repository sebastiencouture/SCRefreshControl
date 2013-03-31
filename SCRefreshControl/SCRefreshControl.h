//
//  SCRefreshControl.h
//  SCRefreshControlDemo
//
//  Created by Sebastien Couture on 13-03-23.
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

#import <UIKit/UIKit.h>

@interface SCRefreshControl : UIControl

@property (nonatomic, readonly) BOOL refreshing;

// Tint color of the control, affects the color of the arrow, text, and activity
// indicator
@property (strong, nonatomic) UIColor *tintColor UI_APPEARANCE_SELECTOR; // Default is dark gray

// Titles displayed for various states. The default values are not localized.
@property (strong, nonatomic) NSString *refreshingTitle UI_APPEARANCE_SELECTOR; // "Updating..."
@property (strong, nonatomic) NSString *releaseToRefreshTitle UI_APPEARANCE_SELECTOR; // "Release to update..."
@property (strong, nonatomic) NSString *pullToRefreshTitle UI_APPEARANCE_SELECTOR; // "Pull down to update..."

// Title to display for the last update date.
@property (strong, nonatomic) NSString *lastUpdateTitle;

// Tells the control that a refresh operation was started programmatically. Call
// this method when an external event triggers the refresh instead of user
// interaction
- (void)beginRefreshing;

// Tells the control that a refresh operation has ended. This method must be
// called when the refresh is complete
- (void)endRefreshing;

@end
