//
//  YKCamelProductListViewController.m
//  YKCamelProductListModule
//
//  Created by yanguo.sun on 13-4-9.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelProductListViewController.h"

#import "YKCamelProductListView.h"
#import "YKSegmentViewProductList.h"
#import "YKXIBHelper.h"

#define transNilString(string) (string.length==0?@"":string)
#define transNilObject(obj,classN) (obj==nil?obj = [classN new]:obj)

#define KREQUESTTYPEFIRST 0
#define KREQUESTTYPELOADUP 1
#define KREQUESTTYPELOADDOWN 2



@interface YKCamelProductListViewController ()<YKSegmentViewProductListDelegate,YKCamelProductListViewDataSource,YKCamelProductListViewDelegate>{
    //为了只是记住第一次请求回来的筛选数据添加的变量
    int staicCount;
    //是不是双击了价格按钮
    BOOL needClicked;
    //控制只运行一次的代码
    int staticOnlyOnce;
    //总的商品列表里有的商品数
    NSUInteger totoalProductCount;
    //当前请求回来的商品数
    NSUInteger currentProductCount;
}
@property (strong,nonatomic) YKCamelProductListView *listView;
@property (assign) YKCamelProductListType type;
@property (strong,nonatomic) YKProductList *listData;
@property (strong, nonatomic) YKSegmentViewProductList *segUp;
@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation YKCamelProductListViewController
@synthesize filterquery = _filterquery;
@synthesize filterqueryIndexPathArray = _filterqueryIndexPathArray;
+(NSString *)moduleName{
    return @"productList";
}
+(int)priority{
    return 1;
}

#pragma mark -
#pragma mark @synthesize filterquery&filterqueryIndexPathArray

- (void)setFilterqueryIndexPathArray:(NSMutableArray *)filterqueryIndexPathArray__{
    _filterqueryIndexPathArray = [filterqueryIndexPathArray__ mutableCopy];
}

- (NSMutableArray *)filterqueryIndexPathArray{
    return _filterqueryIndexPathArray;
}
- (void)setFilterquery:(NSMutableString *)filterquery{
    _filterquery = [filterquery mutableCopy];
}
- (NSMutableString *)filterquery{
    return _filterquery;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        staticOnlyOnce = 0;
        _type = YKCamelProductListTypeSingle;//设置初始为单行
        staicCount = 0;
        self.title = @"商品列表";

        
        _categoryId =  @"";
        _brandId = @"";
        _topicId = @"";
        _keyword = @"";
        self.filterquery = [NSMutableString string];
        _sortBy = @"";
        _sortOrder = @"asc";
        _pageIndex = @"1";
        _pageSize = @"20";
        totoalProductCount = NSNotFound;
        self.filterqueryIndexPathArray = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //设置右边按钮
    self.navigationItem.rightBarButtonItem =[self createNavRightItemButtonWithNormalImageName:@"common_btn_gongge_normal.png" selectedImageName:@"common_btn_gongge_selected.png" rNormalImageName:@"common_btn_shaixuan_normal.png" rSelectedImageName:@"common_btn_shaixuan_selected.png" target:self action:@selector(changeViewType) raction:@selector(popFilter)];
    
    
    //添加segmentControl
    self.segUp = [[YKSegmentViewProductList alloc] initWithFrame:CGRectMake(0, 0, 320, 44) buttonNumber:4 normalImages:nil selectImages:nil titles:@[@"价格",@"新品",@"销量",@"好评"] normalTitleColor:[UIColor colorWithRed:112./255. green:112./255. blue:112./255. alpha:1.] selectColor:[UIColor colorWithRed:104./255. green:31./255. blue:3./255. alpha:1.] selectIndex:0 buttonClass:@"YKCamelSortButton"];
    _segUp.delegate = self;
    _segUp.needIndex = 0;
    _segUp.backgroundColor = [UIColor whiteColor];
    [_segUp addTarget:self action:@selector(segUpClicked:) forControlEvents:UIControlEventValueChanged];
    [_segUp addDoubleClick];
    [self.view addSubview:_segUp];
    
    //添加价格旁边 箭头IMAGE  common_btn_shaixuan_selected.png
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liebiao_img_xiangshang.png"]];
    _arrowImageView.frame = CGRectMake(60, 17, 12, 12);
    [self.view addSubview:_arrowImageView];
    
    //设置segment的下边线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:104./255. green:31./255. blue:3./255. alpha:1.];
    lineView.opaque = YES;
    [self.view addSubview:lineView];
    
    
    //添加商品列表View;
    self.listView = [YKXIBHelper loadObjectFromXIBName:@"YKProductCell" type:[YKCamelProductListView class]];
    _listView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    _listView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _listView.dataSource = self;
    _listView.delegate = self;
    self.listView.backgroundColor=[UIColor colorWithRed:0.546 green:0.432 blue:0.410 alpha:1.000];
    self.listView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_listView];
    
    //向segment的第一个按钮发事件。
//    [self.segUp.selectedButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _pageIndex = @"1";
    [self requestProductListInfoWithType:KREQUESTTYPEFIRST];
#ifdef DEBUG
    NSLog(@"s:%@",self.listData.filterList);
    NSLog(@"s:%@",self.filterquery);
#endif
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark DragToLoadTableViewDelegate

// *** Do load top / load bottom
-(void)startLoadTop {
    _pageIndex = @"1";
    [self requestProductListInfoWithType:KREQUESTTYPELOADUP];
}

-(void)startLoadBottom {
    [self requestProductListInfoWithType:KREQUESTTYPELOADDOWN];
}


#pragma mark -
#pragma mark YKCamelProductListViewDelegate

- (void)productListView:(YKCamelProductListView *)productListView didSelectIndex:(int)_row{
    NSString *pId =( (YKProduct*)[self.listData objectAtIndex:_row]).productId;

//    [[[YKModuleManager shareInstance] shareNavModule] gotoControllerWithName:YK_MODULE_NAME_PRODUCT_DETAIL params:@{@"productId":pId} fromController:self sender:nil];
}



- (NSInteger)numberOfItems{
    return self.listData.count;
}
- (YKCamelProductListType)productListType{
    return _type;
}

- (NSString *)imageUrlForIndex:(int)_index{
    return ((YKProduct*)[self.listData objectAtIndex:_index]).imageUrl;
}
- (NSString *)productNameForIndex:(int)_index{
    YKProduct *product = [self.listData objectAtIndex:_index];
    assert(product);
    return product.name;
}
- (NSString *)salePriceForIndex:(int)_index{
    YKProduct *product = [self.listData objectAtIndex:_index];
    assert(product);
    return [NSString stringWithFormat:@"¥%@",product.salePrice];
}
- (NSString *)shopPriceForIndex:(int)_index{
    YKProduct *product = [self.listData objectAtIndex:_index];
    return [NSString stringWithFormat:@"¥%@",product.marketPrice];
}

#pragma mark -
#pragma mark popFilter & changeViewType
- (void)popFilter{
    id obj = self.filterOnlyFirst;
    if (obj==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"筛选列表为空" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    assert(obj);
    assert(_filterquery);
    self.filterquery = [NSMutableString string];
    [((YKCamelNavigationController*)self.navigationController) goFilterViewController:nil];

//    [((YKCamelNavigationController*)self.navigationController) goFilterWithFilterQ:self.filterquery andFilterList:obj filterqueryIndexPathArray:self.filterqueryIndexPathArray];
}
- (void)changeViewType{
    YKCamelProductListView *blockView = self.listView;
    [UIView transitionWithView:self.view duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        if (_type==YKCamelProductListTypeSingle) {
            _type=YKCamelProductListTypeTwo;
        }else{
            _type = YKCamelProductListTypeSingle;
        }
        [blockView reloadData];


    } completion:^(BOOL finished) {
        if (_type==YKCamelProductListTypeTwo) {
            self.navigationItem.rightBarButtonItem =[self createNavRightItemButtonWithNormalImageName:@"common_btn_liebiao_normal.png" selectedImageName:@"common_btn_liebiao_selected.png" rNormalImageName:@"common_btn_shaixuan_normal.png" rSelectedImageName:@"common_btn_shaixuan_selected.png" target:self action:@selector(changeViewType) raction:@selector(popFilter)];
            
        }else{
            self.navigationItem.rightBarButtonItem =[self createNavRightItemButtonWithNormalImageName:@"common_btn_gongge_normal.png" selectedImageName:@"common_btn_gongge_selected.png" rNormalImageName:@"common_btn_shaixuan_normal.png" rSelectedImageName:@"common_btn_shaixuan_selected.png" target:self action:@selector(changeViewType) raction:@selector(popFilter)];
            
        }
    }];
    
}

#pragma mark -
#pragma mark YKSegmentViewProductList

- (void)doubleClickHappend{
    [_segUp setSelectIndexNoAction:0];
    _sortBy = @"price";
    _pageIndex = @"1";
    [self requestProductListInfoWithType:0];
}
- (void)needButtonClicked{
    needClicked = YES;
}


- (void)segUpClicked:(YKSegmentViewProductList*)_segV{
    //    if (needClicked&&needClickedUpOrDown) {
    //TO DO请求不同的数据
    if (_segV.selectedIndex==0) {
        if (needClicked) {
            self.arrowImageView.image = [UIImage imageNamed:@"liebiao_img_xiangshang.png"];
            needClicked = NO;
            _pageIndex = @"1";
            _sortBy = @"price";
            _sortOrder = @"asc";
        }else{
            self.arrowImageView.image = [UIImage imageNamed:@"liebiao_img_xiangxia.png"];
            _sortBy = @"price";
            _sortOrder = @"desc";
            _pageIndex = @"1";
        }
    }else if (_segV.selectedIndex==1){
        _sortBy = @"addTime";
        _sortOrder = @"";
        _pageIndex = @"1";
    }else if (_segV.selectedIndex==2){
        _sortBy = @"volume";
        _sortOrder = @"";
        _pageIndex = @"1";
    }else if (_segV.selectedIndex==3){
        _sortBy = @"goodComment";
        _sortOrder = @"";
        _pageIndex = @"1";
    }


    [self requestProductListInfoWithType:0];
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

#pragma mark -
#pragma mark 辅助方法

-(UIBarButtonItem*) createNavRightItemButtonWithNormalImageName:(NSString*) animg selectedImageName:(NSString*) asimselect rNormalImageName:(NSString*) ranimg rSelectedImageName:(NSString*) rasimselect target:(id) target action:(SEL)action raction:(SEL)raction{
    {//创建右边返回按钮
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(55, 2, 50, 47);
        [btn setImage:[UIImage imageNamed:animg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:asimselect] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:asimselect] forState:UIControlStateHighlighted];
//common_btn_shaixuan_normal
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 47)];  //直接设置 btn.frame x=-10 不好使
        view.backgroundColor=[UIColor clearColor];
        [view addSubview:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(5, 2, 50, 47);
        [btn setImage:[UIImage imageNamed:ranimg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:rasimselect] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:rasimselect] forState:UIControlStateHighlighted];
        //common_btn_shaixuan_normal
        [btn addTarget:target action:raction forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];

        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithCustomView:view];
        return item;
    }
}
#pragma mark -
#pragma mark requestProductListInfo
- (void)requestProductListInfoWithType:(int)typeQ{
    
    self.productListOperation = [ApplicationDelegate.camelProductListNetworkEngine searchtopicId:_topicId categoryId:_categoryId brandId:_brandId keyword:_keyword filterQuery:_filterquery sortBy:_sortBy sortOrder:_sortOrder pageIndex:_pageIndex pageSize:_pageSize completionHandler:^(YKProductList *keywordli) {
        self.listData = keywordli;
        [self.listView reloadData];
        [self insertListDateAtZero];
        
        if (staicCount==0) {
            YKFilterList *filterL = self.listData.filterList;
            self.filterqueryIndexPathArray = [NSMutableArray array];
            for (int i=0; i<[filterL count]; i++) {
                [self.filterqueryIndexPathArray addObject:[NSIndexPath indexPathForRow:0 inSection:i]];
            }
            self.filterOnlyFirst = filterL;
            
        }
        staicCount++;
        
    } errorHandler:^(NSError *error) {
        
    }];
//    if (typeQ==KREQUESTTYPELOADDOWN) {
//        if (totoalProductCount!=NSNotFound) {
//            if (_pageIndex.intValue*_pageSize.intValue>totoalProductCount) {
//                [self.listView finishedLoadingBottom];
//                [self.listView hiddenLoadButtom];
//                YKLog(@"请求的总数大于总数就不要再请求了222222222");
//                return;
//            }
//        }
//    }
//    YKLog(@"request:categoryId:%@,keyword:%@,filterquery:%@,sortBy:%@,sortOrder:%@,pageIndex:%@,pageSize:%@",_categoryId,_keyword,_filterquery, _sortBy, _sortOrder,_pageIndex, _pageSize);
//    if (typeQ==KREQUESTTYPEFIRST) {
////        [self showActivityIndicator];
//    }
//    [[[YKModuleManager shareInstance] shareDataSourceModule] requestProductListWithParams:@{@"categoryId": _categoryId,@"keyword":_keyword,@"filterquery":_filterquery,@"sortBy":_sortBy,@"sortOrder":_sortOrder,@"pageIndex":_pageIndex,@"pageSize":_pageSize} onSuccess:^(YKProductList *productList) {
//        if (typeQ==KREQUESTTYPEFIRST) {
//            [self hideActivityIndicator];
//        }
//        
//        _pageIndex  = [NSString stringWithFormat:@"%d",_pageIndex.intValue+1];
//        totoalProductCount = productList.totalCount;
//
//        if (typeQ == KREQUESTTYPELOADUP) {
//            self.listData = productList;
//            [self insertListDateAtZero];
//
//            [self.listView finishedLoadingTop];
//        }
//        if (typeQ == KREQUESTTYPELOADDOWN) {
//            for (int i=0; i<productList.count; i++) {
//                [self.listData addObject:[productList objectAtIndex:i]];
//            }
//            [self.listView finishedLoadingBottom];
//        }
//        if (typeQ==KREQUESTTYPEFIRST) {
//            self.listData = productList;
//            [self insertListDateAtZero];
//
//            [self.listView finishedLoadingScrollTop];
//        }
//        if (totoalProductCount!=NSNotFound) {
//            if (_pageIndex.intValue*_pageSize.intValue>totoalProductCount) {
//                [self.listView finishedLoadingBottom];
//                [self.listView hiddenLoadButtom];
//                YKLog(@"请求的总数大于总数就不要再请求了");
//            }
//        }
//        
//        //对于历史搜索结果的操作
//        if (staticOnlyOnce==0) {
//            
//            if (self.requestSuccess) {
//                self.requestSuccess();
//            }
//            staticOnlyOnce=1;
//        }
//
//        
//    } onFail:^(NSError *error) {
//        if (typeQ==KREQUESTTYPEFIRST) {
//            [self hideActivityIndicator];
//        }
//
//        if (typeQ==KREQUESTTYPELOADUP) {
//            [self.listView finishedLoadingTop];
//        }else if (typeQ==KREQUESTTYPELOADDOWN){
//            [self.listView finishedLoadingBottom];
//        }
//        
//        //对于历史搜索结果的操作
//        if (staticOnlyOnce==0) {
//            if (self.requestFail) {
//                self.requestFail();
//            }
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason.length>0?error.localizedFailureReason:@"网络连接失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
////            [alert show];
//            staticOnlyOnce=1;
//        }
//    }];
    
    
}

//给筛选列表添加第一个“全部”

- (void)insertListDateAtZero{
    [self.listView showLoadButtom];

    YKFilterList *filterL = self.listData.filterList;
    for (int i=0; i<filterL.count; i++) {
        YKFilterOption *fiterOption = [[YKFilterOption alloc] init];
        fiterOption.text = @"全部";
        fiterOption.value = @"";
        YKFilterOptionList *fList = ((YKFilter*)[filterL objectAtIndex:i]).optionList;
        assert(fiterOption);
        assert(fList);
        if (fList.count>0) {
            [fList insertObject:fiterOption atIndex:0];
        }
    }

}

- (void)dealloc{
    DLog(@"%@",self);
}


@end
