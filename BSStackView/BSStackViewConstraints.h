//
//  BSStackViewConstraints.h
//  stack
//
//  Created by Oleg Musinov on 7/11/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSStackViewConstraints : NSObject

@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat trailing;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat verticalCompression;
@property (nonatomic, assign) CGFloat horizontalCompression;

- (instancetype)init;

- (NSArray *)constraintsForView:(UIView *)view index:(NSInteger)index;
- (NSArray *)horizontalConstraintsForView:(UIView *)view index:(NSInteger)index;
- (NSArray *)horizontalConstraintsForView:(UIView *)view leading:(CGFloat)leading trailing:(CGFloat)trailing;
- (NSArray *)verticalConstraintsForView:(UIView *)view index:(NSInteger)index;
- (NSArray *)verticalConstraintsForView:(UIView *)view top:(CGFloat)top bottom:(CGFloat)bottom;

@end
