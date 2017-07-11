//
//  ViewController.m
//  BSStackView_Example
//
//  Created by Oleg Musinov on 7/11/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import "ViewController.h"
#import "BSStackView.h"

@interface ViewController () <BSStackViewProtocol>

@property (strong, nonatomic) IBOutlet BSStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        [views addObject:[self viewWithLabel:i]];
    }
    
    self.stackView.swipeDirections = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    self.stackView.forwardDirections = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionUp;
    self.stackView.backwardDirections = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionDown;
    self.stackView.changeAlphaOnSendAnimation = YES;
    [self.stackView configureWithViews:views];
    self.stackView.delegate = self;
}

- (UIView *)viewWithLabel:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 100., 100.)];
    label.text = [NSString stringWithFormat:@"%ld", index];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:25.];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}

- (NSString *)translateDirection:(BSStackViewItemDirection)direction {
    switch (direction) {
        case BSStackViewItemDirectionFront:
            return @"front";
            
        case BSStackViewItemDirectionBack:
            return @"back";
    }
}

#pragma mark - BSStackViewProtocol -

- (void)stackView:(BSStackView *)stackView willSendItem:(UIView *)item direction:(BSStackViewItemDirection)direction {
    NSLog(@"stackView willSendItem %ld direction %@", item.tag, [self translateDirection:direction]);
}

- (void)stackView:(BSStackView *)stackView didSendItem:(UIView *)item direction:(BSStackViewItemDirection)direction {
    NSLog(@"stackView didSendItem %ld direction %@", item.tag, [self translateDirection:direction]);
}


@end
