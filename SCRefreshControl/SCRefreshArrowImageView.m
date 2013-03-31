//
//  SCRefreshArrowImageView.m
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

#import "SCRefreshArrowImageView.h"

#import <QuartzCore/QuartzCore.h>

#define ANIMATE_TIME_SEC 0.25

@interface SCRefreshArrowImageView()

@property (strong, nonatomic) UIImage *original;

@end
@implementation SCRefreshArrowImageView

@synthesize tintColor = _tintColor;
@synthesize original = _original;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.original = [UIImage imageNamed:@"refreshArrow.png"];
        self.frame = CGRectMake(0, 0, self.original.size.width, self.original.size.height);
    }
    
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    // TODO: this check doesn't work if in different color model but same color
    if( [_tintColor isEqual:tintColor] )
    {
        return;
    }
    
    _tintColor = tintColor;
    
    // http://stackoverflow.com/questions/3514066/how-to-tint-a-transparent-png-image-in-iphone
    UIGraphicsBeginImageContextWithOptions(self.original.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, self.original.size.width, self.original.size.height);
    
    // draw tint color
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, rect, self.original.CGImage);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)showDown
{
    [self layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
}

- (void)showDownAnimated
{
    [UIView animateWithDuration:ANIMATE_TIME_SEC animations:^{
        [self showDown];
    }];
}

- (void)showUp
{
    [self layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
}

- (void)showUpAnimated
{
    [UIView animateWithDuration:ANIMATE_TIME_SEC animations:^{
        [self showUp];
    }];
}

@end
