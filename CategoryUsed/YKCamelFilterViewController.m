//
//  YKCamelFilterViewController.m
//  YKCamelFilterViewModuleApp
//
//  Created by yanguo.sun on 13-4-22.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelFilterViewController.h"
#import "YKFilterHeaderDetailListView.h"
#import "YKFilterCategoryClasses.h"
@interface YKCamelFilterViewController ()
@property (nonatomic, retain) YKFilterHeaderDetailListView *headerList;
@end

@implementation YKCamelFilterViewController

+ (NSString *)moduleName{
    return @"filter";
}

+ (int)priority{
    return 1;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"筛选";
        // Custom initialization
    }
    return self;
}


- (void)headerDetailList:(YKFilterHeaderDetailListView *)_headerList_ didTapItemAtIndex:(NSIndexPath *)_index{

    NSString *text =   ((YKFilterOption *) [((YKFilter *)[self.filterList objectAtIndex: _index.section]).optionList objectAtIndex: _index.row]).text;
    YKFilterSectionHeaderView* headerView =  [_headerList_ sectionHeaderViewForSection:_index.section];
    headerView.subTitleLabel.text = text;
}
- (NSString *)iconUrlAtTopRow:(int)row{
    //TO DO:要换成对应的url
    return @"";
}
- (CGFloat)heightForHeader{
    return 44;
}
- (CGFloat)heightForRow{
    return 35;
}
- (int)numOfTop{
    //    return 7;
    return self.filterList.count;
}
- (NSString *)titleAtTopRow:(int)row{
    return ((YKFilter*)[self.filterList objectAtIndex: row]).name;
}
- (NSString *)subTitleAtTopRow:(int)row{
    if (row<self.headerList.indexPathMutArray.count) {
        return  [self filterTextAtIndex:[self.headerList.indexPathMutArray objectAtIndex: row]];
    }else{
        return @"";
    }
}
- (NSArray*)itemsAtRow:(int)row{

    YKFilterOptionList *fList = ((YKFilter*)[self.filterList objectAtIndex: row]).optionList;
    return fList;
}

- (NSInteger)numOfColumn{
    return 3;
}
-(UIBarButtonItem*) createNavRightItemButtonWithNormalImageName:(NSString*) animg selectedImageName:(NSString*) asimselect target:(id) target action:(SEL)action{
    {//创建右边返回按钮
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(5, 2, 50, 47);
        [btn setImage:[UIImage imageNamed:animg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:asimselect] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:asimselect] forState:UIControlStateHighlighted];
        
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 47)];  //直接设置 btn.frame x=-10 不好使
        view.backgroundColor=[UIColor clearColor];
        [view addSubview:btn];
        
        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithCustomView:view];
        return item;
    }
}

- (NSString *)filterTextAtIndex:(NSIndexPath*)_idx{
    YKFilterOptionList *fList = ((YKFilter*)[self.filterList objectAtIndex: _idx.section]).optionList;
    return ((YKFilterOption*)[fList objectAtIndex: _idx.row]).text;
}
- (NSString *)filterValueAtIndex:(NSIndexPath*)_idx{
    YKFilterOptionList *fList = ((YKFilter*)[self.filterList objectAtIndex: _idx.section]).optionList;
    return ((YKFilterOption*)[fList objectAtIndex: _idx.row]).value;
}
- (void)overFilter:(id)sender{
    //在这里把@property (nonatomic, copy) NSMutableString *filterquery;
//拼出来
    NSMutableArray *indexPathArr = self.headerList.indexPathMutArray;
    int count =  indexPathArr.count;
//必须修正count 也不行，必须先弄出字符串再拼，不能直接拼
    NSMutableArray *toPing = [NSMutableArray new];
    for (int i=0; i<count; i++) {
        NSIndexPath *toS = [indexPathArr objectAtIndex: i];
        if (toS.row==0) {
            continue;
        }
        if (toS.length>0) {
            [toPing addObject:[self filterValueAtIndex:toS]];
        }
    }
    for (int i=0; i<toPing.count; i++) {
        NSString *toD = [toPing objectAtIndex: i];
        if (i==toPing.count-1) {
            [self.filterquery appendString:toD];
        }else{
            [self.filterquery appendString:toD];
            [self.filterquery appendString:@","];
        }
    }
    [self.filterqueryIndexPathArray removeAllObjects];
    [self.filterqueryIndexPathArray addObjectsFromArray:self.headerList.indexPathMutArray];
#ifdef DEBUG
    NSLog(@"dacaiguoguo:%@",self.filterquery);
#endif
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self createNavRightItemButtonWithNormalImageName:@"common_btn_tijiao_normal.png" selectedImageName:@"common_btn_tijiao_selected.png" target:self action:@selector(overFilter:)];
    
    self.headerList = [[YKFilterHeaderDetailListView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) withDataSource:self withDelegate:self indxArray:_filterqueryIndexPathArray];
    _headerList.backgroundColor = [UIColor clearColor];
    _headerList.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_headerList];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
