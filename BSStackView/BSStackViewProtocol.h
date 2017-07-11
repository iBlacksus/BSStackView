//
//  BSStackViewProtocol.h
//  stack
//
//  Created by Oleg Musinov on 7/11/17.
//  Copyright © 2017 iBlacksus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSStackView;

typedef NS_ENUM(NSInteger, BSStackViewItemDirection) {
    BSStackViewItemDirectionBack,
    BSStackViewItemDirectionFront
};

@protocol BSStackViewProtocol <NSObject>
@optional

- (void)stackView:(BSStackView *)stackView willSendItem:(UIView *)item direction:(BSStackViewItemDirection)direction;
- (void)stackView:(BSStackView *)stackView didSendItem:(UIView *)item direction:(BSStackViewItemDirection)direction;

@end
