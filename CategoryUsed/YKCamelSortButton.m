//
//  YKCamelSortButton.m
//  YKCamelProductListModule
//
//  Created by yanguo.sun on 13-4-11.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelSortButton.h"
@implementation YKCamelSortButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
//        104 31 3 #681f03
        lineColor = [UIColor colorWithRed:104./255. green:31./255. blue:3./255. alpha:1.];

    }else{
        lineColor = [UIColor whiteColor];
    }
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];    // Drawing code

    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,2.0);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGFloat yy = self.bounds.size.height;
    CGContextMoveToPoint(context, 0, yy-2);
    CGContextAddLineToPoint(context, self.bounds.size.width,yy-2);
    CGContextStrokePath(context);
}


@end
