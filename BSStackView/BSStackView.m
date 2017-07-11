//
//  BSStackView.m
//  stack
//
//  Created by Oleg Musinov on 7/10/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import "BSStackView.h"
#import "EXTScope.h"
#import "BSStackViewLayoutHelper.h"

static CGFloat const BSStackViewMinAlpha = .9;
static CGFloat const BSStackViewMinBackgroundWhite = .7;
static CGFloat const BSStackViewAnimationDurationDefault = .25;

@interface BSStackView ()

@property (copy, nonatomic) NSArray *views;
@property (strong, nonatomic) NSMutableDictionary *viewConstraints;
@property (copy, nonatomic) NSArray *gestures;
@property (assign, nonatomic) UIView *dontUpdateItem;

@end

@implementation BSStackView

#pragma mark - Accessors -

- (void)setSwipeDirections:(UISwipeGestureRecognizerDirection)swipeDirections {
    _swipeDirections = swipeDirections;
    
    NSMutableArray *gestures = [NSMutableArray array];
    
    if (swipeDirections & UISwipeGestureRecognizerDirectionLeft) {
        [gestures addObject:[self addSwipeWithDirection:UISwipeGestureRecognizerDirectionLeft]];
    }
    
    if (swipeDirections & UISwipeGestureRecognizerDirectionUp) {
        [gestures addObject:[self addSwipeWithDirection:UISwipeGestureRecognizerDirectionUp]];
    }
    
    if (swipeDirections & UISwipeGestureRecognizerDirectionRight) {
        [gestures addObject:[self addSwipeWithDirection:UISwipeGestureRecognizerDirectionRight]];
    }
    
    if (swipeDirections & UISwipeGestureRecognizerDirectionDown) {
        [gestures addObject:[self addSwipeWithDirection:UISwipeGestureRecognizerDirectionDown]];
    }
    
    self.gestures = gestures;
    
    [self enableGestures:self.views.count > 0];
}

#pragma mark - Life cycle -

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    
    return self;
}

#pragma mark - Initialization -

- (void)initialize {
    _viewConstraints = [NSMutableDictionary dictionary];
    _gestures = @[];
    _contraintsConfigurator = [[BSStackViewConstraints alloc] init];
    _animationDuration = BSStackViewAnimationDurationDefault;
}

#pragma mark - Public -

- (void)configureWithViews:(NSArray<UIView *> *)views {
    [self removeAllViews];
    
    self.views = views;
    
    [self enableGestures:views.count > 0];
    [self removeAllConstraints];
    
    NSInteger index = 0;
    for (UIView *view in views) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        view.tag = index;
        view.layer.cornerRadius = 5.;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        
        index++;
    }
    
    [self updateViews];
}

#pragma mark - Private -

- (void)removeAllViews {
    for (UIView *view in self.views) {
        [view removeFromSuperview];
    }
}

- (void)enableGestures:(BOOL)enable {
    for (UIGestureRecognizer *gesture in self.gestures) {
        gesture.enabled = enable;
    }
}

- (void)removeAllConstraints {
    for (NSArray *constraints in self.viewConstraints) {
        [self removeConstraints:constraints];
    }
}

- (UISwipeGestureRecognizer *)addSwipeWithDirection:(UISwipeGestureRecognizerDirection)direction {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGesture.direction = direction;
    [self addGestureRecognizer:swipeGesture];
    
    return swipeGesture;
}

- (void)updateViews {
    for (NSInteger i = 0; i < self.views.count; i++) {
        [self updateViewAtIndex:i];
    }
}

- (void)updateViewAtIndex:(NSInteger)index {
    if (index >= self.views.count) {
        return;
    }
    
    UIView *view = self.views[index];
    if (self.dontUpdateItem == view) {
        return;
    }
    
    NSArray *oldConstraints = self.viewConstraints[@(view.tag)];
    view.alpha = [self calculateAlphaForIndex:index];
    view.backgroundColor = [UIColor colorWithWhite:[self calculateBackgroundWhiteForIndex:index] alpha:1.];
    
    NSArray *contraints = [self.contraintsConfigurator constraintsForView:view index:index];
    [self removeConstraints:oldConstraints];
    [self addConstraints:contraints];
    self.viewConstraints[@(view.tag)] = contraints;
}

- (CGFloat)calculateAlphaForIndex:(NSInteger)index {
    return (1. - BSStackViewMinAlpha) / self.views.count * (self.views.count - index) + BSStackViewMinAlpha;
}

- (CGFloat)calculateBackgroundWhiteForIndex:(NSInteger)index {
    return (1. - BSStackViewMinBackgroundWhite) / self.views.count * (self.views.count - index) + BSStackViewMinBackgroundWhite;
}

- (void)sendView:(UIView *)view direction:(UISwipeGestureRecognizerDirection)direction {
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:self.viewConstraints[@(view.tag)]];
    BOOL forward = [self isForwardDirection:direction];
    
    NSLayoutAttribute attribute = [BSStackViewLayoutHelper layoutAttributeForDirection:direction];
    NSLayoutAttribute invertAttribute = [BSStackViewLayoutHelper invertLayoutAttribute:attribute];
    BOOL isVertical = [BSStackViewLayoutHelper isVerticalAttribute:attribute];
    CGFloat x = isVertical ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame);
    NSMutableArray *oldConstraints = [NSMutableArray array];
    CGFloat firstConstraint = 0.;
    CGFloat secondConstraint = 0.;
    
    for (NSLayoutConstraint *constraint in constraints) {
        if ([BSStackViewLayoutHelper isConstraint:constraint hasAttribute:attribute forItem:self]) {
            [oldConstraints addObject:constraint];
            firstConstraint = forward ? constraint.constant - x : constraint.constant + x;
            
        } else if ([BSStackViewLayoutHelper isConstraint:constraint hasAttribute:invertAttribute forItem:self]) {
            [oldConstraints addObject:constraint];
            secondConstraint = forward ? constraint.constant + x : constraint.constant - x;
        }
    }
    
    [self removeConstraints:oldConstraints];
    [constraints removeObjectsInArray:oldConstraints];
    NSArray *newConstraints = @[];
    
    if (isVertical) {
        CGFloat top = attribute == NSLayoutAttributeTop ? firstConstraint : secondConstraint;
        CGFloat bottom = attribute == NSLayoutAttributeBottom ? firstConstraint : secondConstraint;
        newConstraints = [self.contraintsConfigurator verticalConstraintsForView:view top:top bottom:bottom];
    } else {
        CGFloat leading = attribute == NSLayoutAttributeLeading ? firstConstraint : secondConstraint;
        CGFloat trailing = attribute == NSLayoutAttributeTrailing ? firstConstraint : secondConstraint;
        newConstraints = [self.contraintsConfigurator horizontalConstraintsForView:view leading:leading trailing:trailing];
    }
    
    [self addConstraints:newConstraints];
    [constraints addObjectsFromArray:newConstraints];
    self.viewConstraints[@(view.tag)] = constraints;
}

- (void)sendViewAnimationCompletion:(UISwipeGestureRecognizerDirection)direction {
    self.dontUpdateItem = nil;
    BOOL forward = [self isForwardDirection:direction];
    UIView *view = forward ? self.views.lastObject : self.views.firstObject;
    NSInteger index = forward ? self.views.count - 1 : 0;
    [self updateViewAtIndex:index];
    if (self.changeAlphaOnSendAnimation) {
        view.alpha = 0.;
    }
    
    if (forward) {
        [self sendSubviewToBack:view];
    } else {
        [self bringSubviewToFront:view];
    }
    
    @weakify(self);
    [UIView animateWithDuration:self.animationDuration animations:^{
        @strongify(self);
        if (self.changeAlphaOnSendAnimation) {
            view.alpha = [self calculateAlphaForIndex:index];
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(stackView:didSendItem:direction:)]) {
            BSStackViewItemDirection direction = forward ? BSStackViewItemDirectionBack : BSStackViewItemDirectionFront;
            [self.delegate stackView:self didSendItem:view direction:direction];
        }
    }];
}

#pragma mark - Gestures -

- (void)checkDirections {
    if (self.forwardDirections == 0 && self.backwardDirections == 0) {
        self.forwardDirections = self.swipeDirections;
    }
}

- (BOOL)isForwardDirection:(UISwipeGestureRecognizerDirection)direction {
    return direction & self.forwardDirections;
}

- (void)swipe:(UISwipeGestureRecognizer *)gesture {
    [self checkDirections];
    BOOL forward = [self isForwardDirection:gesture.direction];
    UIView *view = forward ? self.views.firstObject : self.views.lastObject;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stackView:willSendItem:direction:)]) {
        BSStackViewItemDirection direction = forward ? BSStackViewItemDirectionBack : BSStackViewItemDirectionFront;
        [self.delegate stackView:self willSendItem:view direction:direction];
    }
    
    [self sendView:view direction:gesture.direction];
    
    NSMutableArray *views = self.views.mutableCopy;
    [views removeObject:view];
    if (forward) {
        [views addObject:view];
    } else {
        [views insertObject:view atIndex:0];
    }
    
    self.views = views;
    
    self.dontUpdateItem = view;
    [self updateViews];
    
    @weakify(self);
    [UIView animateWithDuration:self.animationDuration animations:^{
        @strongify(self);
        if (self.changeAlphaOnSendAnimation) {
            view.alpha = 0.;
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        @strongify(self);
        [self sendViewAnimationCompletion:gesture.direction];
    }];
}

@end
