//
//  YKSegmentView.m
//  YKSegmentTableView
//
//  Created by yanguo.sun on 13-4-8.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKSegmentViewProductList.h"

@implementation YKSegmentViewProductList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addDoubleClick{
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(doubleClickHappend)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    //关键语句，给self.view添加一个手势监测；
    [self addGestureRecognizer:doubleRecognizer];
}
-(void)onButtonClick:(id) sender{
	//UIButton* button=(UIButton*) sender;
	for(int i=0; i<[buttonArray count]; ++i){
		id obj=[buttonArray objectAtIndex:i];
		if([obj isEqual:sender]){
			//由于有时同一按钮需要处理不同的状态所以不能过滤 if(i!=selectedIndex){
            [self setSelectIndex:i];
            //				[self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
			//}
		}
	}
}

-(int) selectedIndex{
	return selectedIndex;
}

-(UIButton*) selectedButton{
	if(selectedIndex>[buttonArray count]-1){
		return nil;
	}
	return [buttonArray objectAtIndex:selectedIndex];
}

-(UIButton *) buttonAtIndex:(int)index{
	return [buttonArray objectAtIndex:index];
}
- (void)setSelectIndexNoAction:(int)index{
    selectedIndex=index;
	for(int i=0;i<[buttonArray count];++i){
		UIButton* button=(UIButton*)[buttonArray objectAtIndex:i];
		if(i==selectedIndex){
            //选中状态时不可点击(若某按钮可重复点,需在使用时对按钮进行单独设置userInteractionEnabled=YES)
            button.userInteractionEnabled=NO;
            if (selectedIndex==_needIndex) {
                button.userInteractionEnabled = YES;
                button.tag++;
                if (button.tag%2==0) {
                    [self.delegate needButtonClicked];
                }
                if (button.tag==11) {
                    button.tag = 1;
                }
            }
			[button setSelected:YES];
		}else{
            button.userInteractionEnabled=YES;
			[button setSelected:NO];
		}
	}
}
-(void) setSelectIndex:(int) index{
    [self setSelectIndexNoAction:index];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (id)initWithFrame:(CGRect)frame buttonNumber:(int)_number normalImages:(NSArray *)normals selectImages:(NSArray *)selects titles:(NSArray *)titles normalTitleColor:(UIColor*)_normalColor selectColor:(UIColor *)_selectColor selectIndex:(int)_selectIndex buttonClass:(NSString *)_btnClassName{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        selectedIndex=-1;
        buttonArray=[[NSMutableArray alloc] init];
        CGRect rect = frame;
        Class buttonClass;
        if (_btnClassName.length>0) {
             buttonClass= NSClassFromString(_btnClassName);

        }else{
            buttonClass = [UIButton class];
        }
        int width =  rect.size.width /_number;
        for (int i=0; i<_number; i++) {
            UIButton *button = [[buttonClass alloc] initWithFrame:CGRectMake(i*width, 0, width, rect.size.height)];
            [button setTitle:[titles objectAtIndex: i] forState:UIControlStateNormal];
            [button setTitleColor:_normalColor forState:UIControlStateNormal];
            [button setTitleColor:_selectColor forState:UIControlStateSelected];
            [button setTitleColor:_normalColor forState:UIControlStateHighlighted];
            if (normals&&selects) {
                [button setBackgroundImage:[UIImage imageNamed:[normals objectAtIndex: i]] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:[selects objectAtIndex: i]] forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage imageNamed:[normals objectAtIndex: i]] forState:UIControlStateHighlighted];
            }

            button.titleLabel.font = [UIFont systemFontOfSize:14];
//            button.frame = CGRectMake(i*width, 0, width, rect.size.height);
            [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            assert(button);
			[buttonArray addObject:button];
            if (_selectIndex==i) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
            
            if([button isSelected] && selectedIndex<0){
				selectedIndex=i;
			}
            [self addSubview:button];
        }
        // Initialization code
    }
    return self;
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
