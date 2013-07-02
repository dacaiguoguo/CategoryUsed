//
//  YKProductListView.m
//  productList
//
//  Created by  yanguo.sun on 13-4-7.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelProductListView.h"
#import "YKCamelDragToLoadTableView.h"
#import "YKXIBHelper.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface YKCamelProductListView()<YKCamelDragTableDelegate,YKCamelDragToLoadTableViewDelegate>
{
    BOOL canHead;
    BOOL canFooter;
}
@property (assign) CGRect orgFrame;
@property (retain,nonatomic) IBOutlet YKCamelDragToLoadTableView *interTable;

@end



@implementation YKProductViewCellSingle

@end
@implementation YKProductViewCellTwo

@end

@implementation YKCamelProductListView
- (void)hiddenLoadButtom{
    [self.interTable disableLoadBottom];
}
- (void)showLoadButtom{
    [self.interTable enableLoadBottom];
}


- (NSString *)getShowText{
    return @"";
}

#pragma mark -
#pragma mark DataSource
- (void)awakeFromNib{
    [_interTable enableLoadBottom];
}

-(void) reloadData{
    [self.interTable reloadData];
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self reloadData];
}


#pragma mark -
#pragma mark DragToLoadTableViewDelegate

// *** Do load top / load bottom
-(void)startLoadTop {
    [self.delegate performSelector:@selector(startLoadTop)];
}

-(void)startLoadBottom {
    [self.delegate performSelector:@selector(startLoadBottom)];
}

#pragma mark etc
-(void)finishedLoadingScrollTop {
    [_interTable reloadData];
    [_interTable setContentOffset:CGPointMake(0, 0)];
    [_interTable stopAllLoadingAnimation];
}
-(void)finishedLoadingTop {
    [_interTable reloadData];
    [_interTable stopAllLoadingAnimation];
}
-(void)finishedLoadingBottom {
    [_interTable reloadData];
    [_interTable stopAllLoadingAnimation];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataSource productListType]==YKCamelProductListTypeSingle)
        return 97;
    else{
        return 135;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int ret = 0;
    int chushu = (int)[self.dataSource productListType];
    //    assert(chushu!=0);
    ret = ceilf((CGFloat)[self.dataSource numberOfItems]/chushu);
    return ret;
}
- (void)buttonAction:(UIButton*)sender{
    [self.delegate productListView:self didSelectIndex:sender.tag];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfiTwo = @"YKTableViewCellForProductListTwo";
    static NSString *idfiSingle = @"YKTableViewCellForProductListSingle";
    
    
    if ([self.dataSource productListType]==YKCamelProductListTypeTwo) {
        YKProductViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:idfiTwo];
        if (!cell) {
            cell = [YKXIBHelper loadObjectFromXIBName:@"YKProductCell" type:[YKProductViewCellTwo class]];
            [cell.leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
        }
        int row = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSURL *imageUrl = [NSURL URLWithString:[self.dataSource imageUrlForIndex:row*2]];
        [cell.leftImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"default_img_shangpinliebiaotu.png"]];
        cell.leftNameLabel.text = [self.dataSource productNameForIndex:row*2];
        cell.leftSalePriceLabel.text = [self.dataSource salePriceForIndex:row*2];
        cell.leftButton.tag = row*2;
        if (row*2+1>=[self.dataSource numberOfItems]) {
            cell.rightImageView.hidden = YES;
            cell.rightNameLabel.hidden = YES;
            cell.rightSalePriceLabel.hidden = YES;
            cell.rightButton.hidden = YES;
        }else{
            cell.rightImageView.hidden = NO;
            cell.rightSalePriceLabel.hidden = NO;
            cell.rightNameLabel.hidden = NO;
            cell.rightButton.tag = row*2+1;
            cell.rightButton.hidden = NO;
            cell.rightNameLabel.text = [self.dataSource productNameForIndex:row*2+1];
            cell.rightSalePriceLabel.text = [self.dataSource salePriceForIndex:row*2+1];
            NSURL *imageUrl = [NSURL URLWithString:[self.dataSource imageUrlForIndex:row*2+1]];
            [cell.rightImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"default_img_shangpinliebiaotu.png"]];
        }
        return cell;
        
    }else{
        YKProductViewCellSingle *cell = [tableView dequeueReusableCellWithIdentifier:idfiSingle];
        if (!cell) {
            if (self.productType==3) {
                cell = [YKXIBHelper loadObjectFromXIBName:@"YKBonusProductCell" type:[YKProductViewCellSingle class]];
            }else
                cell = [YKXIBHelper loadObjectFromXIBName:@"YKProductCell" type:[YKProductViewCellSingle class]];
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int row = indexPath.row;
        NSURL *imageUrl = [NSURL URLWithString:[self.dataSource imageUrlForIndex:row]];
        [cell.pImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"default_img_shangpinliebiaotu.png"]];
        cell.nameLabel.text = [self.dataSource productNameForIndex:row];
        cell.shopPriceLabel.text = [self.dataSource salePriceForIndex:row];
        
        cell.salePriceLabel.text= [self.dataSource shopPriceForIndex:row];
        return cell;
    }
    assert(0);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource productListType]==YKCamelProductListTypeSingle) {
        [self.delegate productListView:self didSelectIndex:indexPath.row];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


@end

@implementation YKLineLabel

- (void)drawRect:(CGRect)rect{
    
    NSString *platFormstr = self.text;
    CGSize platFormconstraint = CGSizeMake(10000, 10000);
    CGSize platFormsize =[platFormstr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:platFormconstraint lineBreakMode: UILineBreakModeCharacterWrap ];
    
    float width =  platFormsize.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [self.textColor CGColor]);
    CGFloat x = 0;
    CGFloat y = rect.size.height/2;
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, width, y);
    CGContextStrokePath(context);
    [super drawRect:rect];
}

@end

