//
//  YKBorderImageView.m
//  YKCamelProductListModule
//
//  Created by yanguo.sun on 13-4-16.
//  Copyright (c) 2013年 yek. All rights reserved.
//

#import "YKBorderImageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation YKBorderImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib{
    self.layer.borderColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
