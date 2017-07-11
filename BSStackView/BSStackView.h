//
//  BSStackView.h
//  stack
//
//  Created by Oleg Musinov on 7/10/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSStackViewConstraints.h"
#import "BSStackViewProtocol.h"

@interface BSStackView : UIView

@property (assign, nonatomic) UISwipeGestureRecognizerDirection swipeDirections;
@property (assign, nonatomic) UISwipeGestureRecognizerDirection forwardDirections;
@property (assign, nonatomic) UISwipeGestureRecognizerDirection backwardDirections;
@property (strong, nonatomic, readonly) BSStackViewConstraints *contraintsConfigurator;
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) BOOL changeAlphaOnSendAnimation;
@property (weak, nonatomic) id<BSStackViewProtocol> delegate;

- (void)configureWithViews:(NSArray<UIView *> *)views;

@end
