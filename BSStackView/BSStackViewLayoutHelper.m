//
//  BSStackViewLayoutHelper.m
//  stack
//
//  Created by Oleg Musinov on 7/11/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import "BSStackViewLayoutHelper.h"

@implementation BSStackViewLayoutHelper


+ (NSLayoutAttribute)layoutAttributeForDirection:(UISwipeGestureRecognizerDirection)direction {
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            return NSLayoutAttributeLeading;
            
        case UISwipeGestureRecognizerDirectionUp:
            return NSLayoutAttributeTop;
            
        case UISwipeGestureRecognizerDirectionRight:
            return NSLayoutAttributeTrailing;
            
        case UISwipeGestureRecognizerDirectionDown:
            return NSLayoutAttributeBottom;
    }
}

+ (NSLayoutAttribute)invertLayoutAttribute:(NSLayoutAttribute)attribute {
    switch (attribute) {
        case NSLayoutAttributeLeading:
            return NSLayoutAttributeTrailing;
            
        case NSLayoutAttributeTop:
            return NSLayoutAttributeBottom;
            
        case NSLayoutAttributeTrailing:
            return NSLayoutAttributeLeading;
            
        case NSLayoutAttributeBottom:
            return NSLayoutAttributeTop;
            
        default:
            return NSLayoutAttributeTop;
    }
}

+ (BOOL)isConstraint:(NSLayoutConstraint *)constraint hasAttribute:(NSLayoutAttribute)attribute forItem:(id)item {
    return (constraint.firstItem == item && constraint.firstAttribute == attribute) ||
    (constraint.secondItem == item && constraint.secondAttribute == attribute);
}

+ (BOOL)isVerticalAttribute:(NSLayoutAttribute)attribute {
    switch (attribute) {
        case NSLayoutAttributeLeading:
        case NSLayoutAttributeTrailing:
            return NO;
            
        case NSLayoutAttributeTop:
        case NSLayoutAttributeBottom:
            return YES;
            
        default:
            return NO;
    }
}

@end
