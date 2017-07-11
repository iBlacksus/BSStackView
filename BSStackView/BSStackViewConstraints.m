//
//  BSStackViewConstraints.m
//  stack
//
//  Created by Oleg Musinov on 7/11/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import "BSStackViewConstraints.h"

static CGFloat const BSStackViewConstraintsLeadingDefault = 40.;
static CGFloat const BSStackViewConstraintsTrailingDefault = 40.;
static CGFloat const BSStackViewConstraintsTopDefault = 100.;
static CGFloat const BSStackViewConstraintsBottomDefault = 140.;
static CGFloat const BSStackViewConstraintsCompressionHorizontalDefault = 10.;
static CGFloat const BSStackViewConstraintsCompressionVerticalDefault = 10.;

@implementation BSStackViewConstraints

- (instancetype)init {
    if (self = [super init]) {
        _leading = BSStackViewConstraintsLeadingDefault;
        _trailing = BSStackViewConstraintsTrailingDefault;
        _top = BSStackViewConstraintsTopDefault;
        _bottom = BSStackViewConstraintsBottomDefault;
        _verticalCompression = BSStackViewConstraintsCompressionVerticalDefault;
        _horizontalCompression = BSStackViewConstraintsCompressionHorizontalDefault;
    }
    
    return self;
}

- (NSArray *)constraintsForView:(UIView *)view index:(NSInteger)index {
    NSMutableArray *contraints = [NSMutableArray array];
    [contraints addObjectsFromArray:[self horizontalConstraintsForView:view index:index]];
    [contraints addObjectsFromArray:[self verticalConstraintsForView:view index:index]];
    
    return contraints;
}

- (NSArray *)horizontalConstraintsForView:(UIView *)view index:(NSInteger)index {
    CGFloat leading = self.leading + self.horizontalCompression * index;
    CGFloat trailing = self.trailing + self.horizontalCompression * index;
    
    return [self horizontalConstraintsForView:view leading:leading trailing:trailing];
}

- (NSArray *)horizontalConstraintsForView:(UIView *)view leading:(CGFloat)leading trailing:(CGFloat)trailing {
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSString *format = [NSString stringWithFormat:@"H:|-(%.f)-[view]-(%.f)-|", leading, trailing];
    
    return [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
}

- (NSArray *)verticalConstraintsForView:(UIView *)view index:(NSInteger)index {
    CGFloat top = self.top + self.verticalCompression * index;
    CGFloat bottom = self.bottom - self.verticalCompression * index;
    
    return [self verticalConstraintsForView:view top:top bottom:bottom];
}

- (NSArray *)verticalConstraintsForView:(UIView *)view top:(CGFloat)top bottom:(CGFloat)bottom {
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSString *format = [NSString stringWithFormat:@"V:|-(%.f)-[view]-(%.f)-|", top, bottom];
    
    return [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
}

@end
