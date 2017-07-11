//
//  BSStackViewLayoutHelper.h
//  stack
//
//  Created by Oleg Musinov on 7/11/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSStackViewLayoutHelper : NSObject

+ (NSLayoutAttribute)layoutAttributeForDirection:(UISwipeGestureRecognizerDirection)direction;
+ (NSLayoutAttribute)invertLayoutAttribute:(NSLayoutAttribute)attribute;
+ (BOOL)isConstraint:(NSLayoutConstraint *)constraint hasAttribute:(NSLayoutAttribute)attribute forItem:(id)item;
+ (BOOL)isVerticalAttribute:(NSLayoutAttribute)attribute;

@end
