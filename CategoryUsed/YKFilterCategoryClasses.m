//
//  YKCategoryClasses.m
//  Category
//
//  Created by  yanguo.sun on 13-4-2.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKFilterCategoryClasses.h"
#import <QuartzCore/QuartzCore.h>

#define WantUpLine 0
@implementation YKFilterDataMoudleList
- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (NSString *)description{
    return  [NSString stringWithFormat:@"dd:%@",self.open?@"YES":@"NO"];
    
}

@end
@implementation YKFilterSectionHeaderView


@synthesize titleLabel=_titleLabel, subTitleLabel=_subTitleLabel,iconImage=_iconImage, delegate=_delegate, section=_section,lineLabel = _lineLabel,lineImage = _lineImage,disclosureButton = _disclosureButton;
-(UIColor*) bgColor{
    return [UIColor colorWithRed:247.0/255 green:245.0/255 blue:238.0/255 alpha:1.0];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title subTitle:(NSString*)subTitle section:(NSInteger)sectionNumber delegate:(id <YKFilterSectionHeaderViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        
        _delegate = delegate;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [self bgColor];
        self.opaque = YES;
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        //add up line
        CGRect lineRect = titleLabelFrame;
        lineRect.origin.y = 0;
        lineRect.size.height = 1;
//        YKLineView *line = [[YKLineView alloc] initWithFrame:lineRect];
//        [self addSubview:line];
//        _lineImage = line;
//        
//        YKLineView *lineLabelt = [[YKLineView alloc] initWithFrame:lineRect];
//        lineLabelt.hidden = YES;
//        [self addSubview:lineLabelt];
//        _lineLabel = lineLabelt;
        
        titleLabelFrame.origin.x  =20;
        titleLabelFrame.origin.y  =10;
        titleLabelFrame.size.width = 120;
        titleLabelFrame.size.height-=20;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
        label.text = title;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        _titleLabel = label;
        titleLabelFrame.origin.x  =120;
        titleLabelFrame.size.width = 200;

        UILabel *subLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        subLabel.text = subTitle;
        subLabel.font = [UIFont systemFontOfSize:12];
        subLabel.textColor = [UIColor blackColor];
        subLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:subLabel];
        
        _subTitleLabel = subLabel;
        _iconImage = nil;
        
        
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(300, 16.0, 14, 14);
        [button setImage:[UIImage imageNamed:@"common_img_qianwang.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"common_img_zhankai.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _disclosureButton = button;
        if (WantUpLine) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpLineChange:) name:@"_openSectionIndex" object:nil];
        }else{
            
        }
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}
- (void)setUpLineChange:(BOOL)change{
    int index = [self.delegate get_OpenSectionIndex];
    if (index+1==_section) {
        _lineLabel.hidden = NO;
        _lineImage.hidden = YES;
    }else{
//        YKLog(@"%d:%d",[self.delegate get_OpenSectionIndex]+1,_section);
        _lineLabel.hidden = YES;
        _lineImage.hidden = NO;
    }
    if (index==_section) {
        _lineImage.hidden = NO;
        _lineLabel.hidden = YES;
    }
}

-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.iselected = !self.iselected;
    self.disclosureButton.selected = !self.disclosureButton.selected;
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.iselected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}



@end
