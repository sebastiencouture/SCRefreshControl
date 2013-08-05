//
//  SCRefreshControl.m
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

#import "SCRefreshControl.h"

#import "SCRefreshArrowImageView.h"

#define ANIMATE_TIME_SEC 0.25

#define DEFAULT_REFRESHING_TITLE @"Updating..."
#define DEFAULT_RELEASE_TO_REFRESH_TITLE @"Release to update..."
#define DEFAULT_PULL_TO_REFRESH_TITLE @"Pull down to update..."

@interface SCRefreshControl ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) SCRefreshArrowImageView *arrow;

@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *lastUpdateLabel;

@property (strong, nonatomic) UIColor *defaultTintColor;

@property (nonatomic) CGFloat originalContentInsetTop;

- (void)updateForRefresh;
- (void)updateForReleaseToRefresh;
- (void)updateForPullToRefresh;

- (void)resetContentInsetToOriginal;
- (void)positionAboveScrollContent;

- (void)createSubviews;
- (void)initAppearance;

- (UIScrollView *)scrollView;
- (BOOL)isSuperviewScrollView;

@end

@implementation SCRefreshControl

@synthesize refreshing = _refreshing;

@synthesize tintColor = _tintColor;

@synthesize lastUpdateTitle = _lastUpdateTitle;
@synthesize refreshingTitle = _refreshingTitle;
@synthesize releaseToRefreshTitle = _releaseToRefreshTitle;
@synthesize pullToRefreshTitle = _pullToRefreshTitle;

@synthesize activityIndicator = _activityIndicator;
@synthesize arrow = _refreshArrow;

@synthesize statusLabel = _statusLabel;
@synthesize lastUpdateLabel = _lastUpdateLabel;

@synthesize defaultTintColor = _defaultTintColor;

@synthesize  originalContentInsetTop = _originalContentInsetTop;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, 0, 70);
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        [self createSubviews];
        [self initAppearance];
        
        [self updateForPullToRefresh];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    CGFloat arrowWidth = self.arrow.frame.size.width;
    CGFloat arrowHeight = self.arrow.frame.size.height;
    
    CGFloat arrowY = CGRectGetMaxY(self.bounds) - arrowHeight - 10;
    CGFloat arrowX = 25;
    
    self.arrow.frame =
        CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight);
    
    CGFloat activityWidth = self.activityIndicator.frame.size.width;
    CGFloat activityHeight = self.activityIndicator.frame.size.height;
    
    CGFloat activityY = center.y - (activityHeight / 2.0);
    CGFloat activityX = 40;
    
    self.activityIndicator.frame =
        CGRectMake(activityX, activityY, activityWidth, activityHeight);
    
    CGFloat textX = arrowX + arrowWidth + 10;
    CGFloat textY = CGRectGetMinY(self.bounds) + 20;
    
    CGFloat textWidth = CGRectGetWidth(self.bounds) - (textX * 2.0);
    CGFloat textHeight = 20;

    self.statusLabel.frame =
        CGRectMake(textX, textY, textWidth, textHeight);
    
    textY = textY + textHeight;
    
    self.lastUpdateLabel.frame =
        CGRectMake(textX, textY, textWidth, textHeight);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (!self.isSuperviewScrollView)
    {
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    
    self.originalContentInsetTop = self.scrollView.contentInset.top;
    [self positionAboveScrollContent];
    
    [self.superview addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionOld
                        context:NULL];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!self.isSuperviewScrollView)
    {
        return;
    }
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - setters

- (void)setTintColor:(UIColor *)tintColor
{
    if (!tintColor)
    {
        tintColor = self.defaultTintColor;
    }
    
    _tintColor = tintColor;
    
    self.statusLabel.textColor = tintColor;
    self.lastUpdateLabel.textColor = tintColor;
    self.activityIndicator.color = tintColor;
    self.arrow.tintColor = tintColor;
}

- (void)setPullToRefreshTitle:(NSString *)pullToRefreshTitle
{
    if (!pullToRefreshTitle)
    {
        pullToRefreshTitle = DEFAULT_PULL_TO_REFRESH_TITLE;
    }
    
    _pullToRefreshTitle = pullToRefreshTitle;
}

- (void)setReleaseToRefreshTitle:(NSString *)releaseToRefreshTitle
{
    if (!releaseToRefreshTitle)
    {
        releaseToRefreshTitle = DEFAULT_RELEASE_TO_REFRESH_TITLE;
    }
    
    _releaseToRefreshTitle = releaseToRefreshTitle;
}

- (void)setRefreshingTitle:(NSString *)refreshingTitle
{
    if (!refreshingTitle)
    {
        refreshingTitle = DEFAULT_REFRESHING_TITLE;
    }
    
    _refreshingTitle = refreshingTitle;
}

- (void)setLastUpdateTitle:(NSString *)lastUpdateTitle
{
    _lastUpdateTitle = lastUpdateTitle;
    
    self.lastUpdateLabel.text = lastUpdateTitle;
}

#pragma mark -

- (void)beginRefreshing
{
    [self updateForRefresh];
}

- (void)endRefreshing
{
    _refreshing = NO;
    
    [self.arrow showDown];
    
    [self resetContentInsetToOriginal];
    
    [UIView animateWithDuration:ANIMATE_TIME_SEC animations:^{
        self.alpha = 0.0;
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_refreshing)
    {
        return;
    }
    
    CGFloat pullHeight = -self.scrollView.contentOffset.y + self.originalContentInsetTop;
    CGFloat minPullHeightForRefresh = self.bounds.size.height;

    if (minPullHeightForRefresh < pullHeight ||
        0.0001 > fabs( minPullHeightForRefresh - pullHeight))
    {
        if (self.scrollView.isDragging)
        {
            [self updateForReleaseToRefresh];
        }
        else
        {
            [self updateForRefresh];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    else if (self.scrollView.isDragging)
    {
        [self updateForPullToRefresh];
    }
}

#pragma mark - private

- (void)updateForRefresh
{
    _refreshing = YES;
    
    self.alpha = 1.0;
    
    self.statusLabel.text = self.refreshingTitle;
    
    self.arrow.hidden = YES;
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    UIEdgeInsets contentInset =
        UIEdgeInsetsMake(
            self.originalContentInsetTop + self.bounds.size.height, 0, 0, 0);
    
    if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, contentInset))
    {
        [UIView animateWithDuration:ANIMATE_TIME_SEC animations:^{
            self.scrollView.contentInset = contentInset;
        }];
    }
}

- (void)updateForReleaseToRefresh
{
    _refreshing = NO;
    
    self.alpha = 1.0;
    
    self.statusLabel.text = self.releaseToRefreshTitle;
    
    self.arrow.hidden = NO;
    [self.activityIndicator stopAnimating];
    
    [self.arrow showUpAnimated];
}

- (void)updateForPullToRefresh
{
    _refreshing = NO;
    
    self.alpha = 1.0;
    
    self.statusLabel.text = self.pullToRefreshTitle;
    
    self.arrow.hidden = NO;
    [self.activityIndicator stopAnimating];
    
    [self.arrow showDownAnimated];
    
    [self resetContentInsetToOriginal];
}

- (void)resetContentInsetToOriginal
{
    UIEdgeInsets contentInset =
        UIEdgeInsetsMake(self.originalContentInsetTop, 0, 0, 0);
    
    if (!UIEdgeInsetsEqualToEdgeInsets( self.scrollView.contentInset, contentInset))
    {
        [UIView animateWithDuration:ANIMATE_TIME_SEC animations:^{
            self.scrollView.contentInset = contentInset;
        }];
    }
}

- (void)positionAboveScrollContent
{
    CGFloat height = self.frame.size.height;
    
    self.frame = CGRectMake(0, -height, self.superview.frame.size.width, height);
}

- (void)createSubviews
{
    self.arrow = [[SCRefreshArrowImageView alloc] init];
    [self addSubview:self.arrow];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment = UITextAlignmentCenter;
    self.statusLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [self addSubview:self.statusLabel];
    
    self.lastUpdateLabel = [[UILabel alloc] init];
    self.lastUpdateLabel.backgroundColor = [UIColor clearColor];
    self.lastUpdateLabel.textAlignment = UITextAlignmentCenter;
    self.lastUpdateLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    
    [self addSubview:self.lastUpdateLabel];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.hidesWhenStopped = YES;
    
    [self addSubview:self.self.activityIndicator];
}

- (void)initAppearance
{
    self.backgroundColor = [UIColor clearColor];
    
    self.defaultTintColor = [UIColor grayColor];
    _tintColor = self.defaultTintColor;
    
    self.statusLabel.textColor = _tintColor;
    self.lastUpdateLabel.textColor = _tintColor;
    self.activityIndicator.color = _tintColor;
    self.arrow.tintColor = _tintColor;
    
    _pullToRefreshTitle = DEFAULT_PULL_TO_REFRESH_TITLE;
    _releaseToRefreshTitle = DEFAULT_RELEASE_TO_REFRESH_TITLE;
    _refreshingTitle = DEFAULT_REFRESHING_TITLE;
}

- (UIScrollView *)scrollView
{
    return (UIScrollView *)self.superview;
}

- (BOOL)isSuperviewScrollView
{
    return [self.superview isKindOfClass:[UIScrollView class]];
}

@end
