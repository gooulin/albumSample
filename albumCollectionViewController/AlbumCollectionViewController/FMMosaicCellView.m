//
// FMMosaicCellView.m
// FMMosaicLayout
//
// Created by Julian Villella on 2015-01-30.
// Copyright (c) 2015 Fluid Media. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FMMosaicCellView.h"

static NSString* const kFMMosaicCellViewReuseIdentifier = @"FMMosaicCellViewReuseIdentifier";

@interface FMMosaicCellView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic)UIView *overlayView;

@end

@implementation FMMosaicCellView

+ (NSString *)reuseIdentifier {
    return kFMMosaicCellViewReuseIdentifier;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    self.clipsToBounds = true;
//
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
//    [self.contentView addSubview:self.titleLabel];
//    
    self.overlayView = [[UIView alloc] initWithFrame:self.contentView.frame];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.0f;
    [self.contentView addSubview:self.overlayView];
    
    [self setupGesture];
    return self;
}

- (void)setupGesture {
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
//    longPressGesture.minimumPressDuration = 0.0;
//    longPressGesture.delegate = self;
//    longPressGesture.cancelsTouchesInView = NO;
//    [self addGestureRecognizer:longPressGesture];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
          //  self.overlayView.alpha = 0.5;
        } completion:nil];
        
    } else {
        [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
            //self.overlayView.alpha = 0.0;
        } completion:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setSelectedEffect {
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
        self.overlayView.alpha = 0.5;
    } completion:nil];
}

- (void)setUnSelectedEffect {
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.overlayView.alpha = 0.0;
    } completion:nil];
}
@end
