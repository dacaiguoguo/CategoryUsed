//
//  YKCamelSearchViewController.m
//  YKCamelSearchViewMoudle
//
//  Created by yanguo.sun on 13-4-9.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelSearchViewController.h"

#import "YKSegmentView.h"
#import "YKSegTableView.h"
#import "YKCamelSearchHistory.h"
#import "YKCamelProductListViewController.h"


@interface YKCamelSearchViewController ()<YKSegTableViewDataSource,YKSegTableViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) YKSegTableView *segmentTable ;
@property (strong, nonatomic) YKSegmentView *segmentViewInter;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) IBOutlet UISearchBar *searbar;
@property (strong, nonatomic) YKKeywordList *hotSearchList;
@property (strong, nonatomic) YKKeywordList *mohuSearchList;
@property (strong, nonatomic) IBOutlet UIView *mengbanView;
@property (strong, nonatomic) IBOutlet UITableView *mohuTableView;

- (IBAction)resignSearchBar:(id)sender;

@end

@implementation YKCamelSearchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜索";
        DLog(@"alloc:%@",self);

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [YKCamelSearchHistory setNumberOfHistory:20];
    self.segmentTable = [[YKSegTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) andDataSource:self andDelegate:self];
    self.segmentTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.segmentTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.segmentTable];
    __weak YKCamelSearchViewController *weakSelf = self;
    self.hotSearchOperation = [ApplicationDelegate.camelHotSearchNetworkEngine completionHandler:^(YKKeywordList *keywordli) {
        weakSelf.hotSearchList = keywordli;
        [weakSelf.segmentTable reloadData];
    } errorHandler:^(NSError *error) {
        
    }];

//    


    
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark -
#pragma mark   UISearchBarDatasource
//@protocol UISearchBarDelegate <NSObject>
//
//@optional
//
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.view bringSubviewToFront:self.mengbanView];
    if (searchBar.text.length>0) {
        [self.view bringSubviewToFront:self.mohuTableView];
    }
    return YES;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}                        

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
#ifdef DEBUG
    NSLog(@"textDidChange:%@",searchText);
#endif
    
    if (searchText.length<1) {//当没有searchtext为空，不进行模糊请求
        [self.view sendSubviewToBack:self.mohuTableView];
        return;
    }

//    [[[YKModuleManager shareInstance] shareDataSourceModule] requestHotKeywordsWithParams:@{@"keyword":(searchText==nil?@"":searchText)} onSuccess:^(NSMutableArray *keywords) {
//
//        self.mohuSearchList = keywords;
//        [self.view bringSubviewToFront:self.mohuTableView];
//        [self.mohuTableView reloadData];
//    } onFail:^(NSError *error) {
//
//    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self goResultWithKeyWord:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.view sendSubviewToBack:self.mohuTableView];
    [self.view sendSubviewToBack:self.mengbanView];
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}                    // called when cancel button pressed

- (UIView *)segmentView{
    //    return nil;
    if (!_headerView) {
        self.headerView =[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 39+18)];
        self.headerView.backgroundColor = [UIColor colorWithRed:246./255. green:244./255. blue:238./255. alpha:1.];
;
        self.segmentViewInter =  [[YKSegmentView alloc] initWithFrame:CGRectMake(34, 18, 252, 39)
                                                buttonNumber:2
                                                normalImages:@[@"sousuo_btn_zuobiaoqian_normal.png",@"sousuo_btn_youbiaoqian_normal.png"]
                                                selectImages:@[@"sousuo_btn_zuobiaoqian_selected.png",@"sousuo_btn_youbiaoqian_selected.png"]
                                                      titles:@[@"热门推荐",@"搜索历史"]
                                            normalTitleColor:[UIColor colorWithRed:112./255. green:112./255. blue:112./255. alpha:1.] selectColor:[UIColor whiteColor]
                                                 selectIndex:0];
        [_segmentViewInter addTarget:self action:@selector(reloadDataSeg:) forControlEvents:UIControlEventValueChanged];
        [self.headerView addSubview:_segmentViewInter];
        
    }
    return _headerView;
}
- (int)showWhichOne{
    return _segmentViewInter.selectedIndex;
}
- (NSArray*)itemsForColom:(int)_colom{
    if (_colom==1) {
        return [YKCamelSearchHistory getSearchHistory];
    }else {
       return self.hotSearchList;
    }
}
- (int)numberOfColoms{
    return 2;
}
- (int)heightForFooterView{
    return 56;
}
- (void)clearSearchHistory:(UIButton*)sender{
    [YKCamelSearchHistory clearSearchHistoryOver];
    [self.segmentTable reloadData];
}
- (UIView *)buttomViewForColom:(int)_colom{
    UIView *ret = nil;
    
    if (_colom==1) {
        ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setFrame:CGRectInset(ret.bounds, 10, 8)];
        [clearButton addTarget:self action:@selector(clearSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bgImage = [UIImage imageNamed:@"common_btn_orangelarge_normal.png"];
        [clearButton setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        bgImage = [UIImage imageNamed:@"common_btn_orangelarge_selected.png"];
        [clearButton setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateSelected];
        [clearButton setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        clearButton.titleLabel.font= [UIFont boldSystemFontOfSize:16];
        [clearButton setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [ret addSubview:clearButton];
    }
    return ret;
    
}

#pragma mark -
#pragma mark YKSegTableViewDelegate

- (void)didSelectIndex:(NSIndexPath*)_indexPath withKeyWord:(NSString*)_key{
    [self goResultWithKeyWord:_key];
}



- (void)reloadDataSeg:(YKSegmentView*)segs{
    [self.segmentTable reloadData];
}



- (void)goResultWithKeyWord:(NSString *)keyWord{
    if (keyWord.length<1) {
        return;
    }
    [ApplicationDelegate.iHomeNav goProductListWithKeyword:keyWord];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goResultWithKeyWord:[self.mohuSearchList objectAtIndex:indexPath.row ]];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mohuSearchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idfi = @"YKTableViewCellForGategory";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfi];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfi];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
//        YKLineView *lineView = [[YKLineView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, 320, 1)];
//        lineView.backgroundColor = [UIColor clearColor];
//        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        [cell addSubview:lineView];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = [self.mohuSearchList objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMengbanView:nil];
    [self setMohuTableView:nil];
    [super viewDidUnload];
}
- (IBAction)resignSearchBar:(id)sender {
    [self.view sendSubviewToBack:self.mengbanView];
    [self.searbar setShowsCancelButton:NO animated:YES];
    [self.searbar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.segmentTable reloadData];

}


@end