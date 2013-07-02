//
//  YKHeaderDetailListView.m
//  Category
//
//  Created by  yanguo.sun on 13-4-3.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKFilterHeaderDetailListView.h"
#import "YKFilterCategoryClasses.h"
#import "YKBaseModel.h"
@interface YKFilterHeaderDetailListView()<UITableViewDataSource,UITableViewDelegate,YKFilterSectionHeaderViewDelegate>
@property (nonatomic, strong) UITableView *interTable;
/*!@var openSectionIndex 当前打开的Section*/
@property (nonatomic, assign) NSInteger openSectionIndex;
/*!@var openSectionIndex 当前打开的Section*/
@property (nonatomic, assign) NSInteger numberOfColumn;
/*!@var sectionInfoArray 分类信息数组*/
@property (nonatomic, strong) NSMutableDictionary* sectionInfoDic;

@property (assign) CGRect orgFrame;
- (void)delegateAction:(UIButton*)sender;
@end
@implementation YKFilterHeaderDetailListView
- (YKFilterSectionHeaderView *)sectionHeaderViewForSection:(NSUInteger)section{
    YKFilterDataMoudleList *mod =   [self changeSubFromDatasourceItemsAtRow:section];
    if (!mod.headerView_cate) {
        return nil;
    }
    return mod.headerView_cate;
}

- (void)dealloc{
    _datasource = nil;
    _delegate = nil;
}
- (id)initWithFrame:(CGRect)frame withDataSource:(id<YKFilterHeaderDetailListViewDataSource>)datas withDelegate:(id<YKFilterHeaderDetailListViewDelegate>)dele indxArray:(NSMutableArray *)indexArray
{
    _orgFrame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.datasource = datas;
        self.delegate = dele;
        self.indexPathMutArray = [NSMutableArray array];
        [self.indexPathMutArray addObjectsFromArray:indexArray];
        self.sectionInfoDic = [NSMutableDictionary dictionary];
        [self reloadData];
    }
    return self;
}

- (UITableView*)interTable{
    if (!_interTable) {
           _interTable = [[UITableView alloc] initWithFrame:_orgFrame style:UITableViewStylePlain] ;
        _interTable.dataSource = self;
        _interTable.delegate = self;
        _interTable.backgroundColor = [UIColor clearColor];
        _interTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _interTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_interTable];
    }
    return _interTable;
}

- (NSInteger)numberOfColumn{
    NSInteger ret = 1;
    if (self.datasource) {
        ret = [self.datasource numOfColumn];
    }else{
        ret = 1;
    }
    return ret;
    
}
-(void) reloadData{
    _openSectionIndex = NSNotFound;
    [self.interTable reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.datasource heightForRow];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.datasource heightForHeader];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.datasource numOfTop];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YKFilterDataMoudleList *sectionInfo = [self changeSubFromDatasourceItemsAtRow:section];
    assert(sectionInfo);
    NSInteger numStoriesInSection  = 0;
    numStoriesInSection = [[sectionInfo subArray] count];

    numStoriesInSection = [sectionInfo open] ? (NSInteger)ceilf((CGFloat)numStoriesInSection/[self numberOfColumn]) : 0;
    return numStoriesInSection;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *idfi = @"YKTableViewCellForGategory";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfi];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idfi];
        int width = self.bounds.size.width/self.numberOfColumn;
        for (int i=0; i<self.numberOfColumn; ++i) {
            UIButton *addB = [UIButton buttonWithType:UIButtonTypeCustom];
            addB.frame = CGRectMake(i*width, 0, width, 40);
            [addB addTarget:self action:@selector(delegateAction:) forControlEvents:UIControlEventTouchUpInside];
            addB.titleLabel.font = [UIFont systemFontOfSize:14];
            addB.tag = 2013+i;


            [cell addSubview:addB];
        }
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //重用会有问题，button
    YKFilterDataMoudleList *list = [self changeSubFromDatasourceItemsAtRow:indexPath.section];
    assert(list);
    assert([list isKindOfClass:[YKFilterDataMoudleList class] ]);
    for (int i=0; i<self.numberOfColumn; ++i) {
        UIButton *formB = (UIButton *)[cell viewWithTag:2013+i];
        [formB setTitleColor:[UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.] forState:UIControlStateNormal];
        [formB setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        formB.selected = NO;
        int getN = indexPath.row*self.numberOfColumn+i;
        if (getN>=list.subArray.count) {
            formB.hidden = YES;
        }else{
            formB.hidden = NO;
            assert([formB isKindOfClass:[UIButton class]]);
            assert([[list.subArray objectAtIndex: getN] isKindOfClass:[YKFilterOption class]]);
            YKFilterOption *filter = [list.subArray objectAtIndex: getN];
            if ([self indexPathArrayInclude:[NSIndexPath indexPathForRow:getN inSection:indexPath.section]]) {
                [formB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            [formB setTitle:filter.text forState:UIControlStateNormal];
        }
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YKFilterDataMoudleList *mod =   [self changeSubFromDatasourceItemsAtRow:section];
    
    if (!mod.headerView_cate) {
        
        int lastSection = [self.datasource numOfTop]-1;
        if (section==lastSection) {
            YKFilterSectionHeaderView *view = [[YKFilterSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44) title:[self.datasource titleAtTopRow:section] subTitle:[self.datasource subTitleAtTopRow:section] section:section delegate:self];
            mod.headerView_cate = view;
        }else{
            mod.headerView_cate = [[YKFilterSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44) title:[self.datasource titleAtTopRow:section] subTitle:[self.datasource subTitleAtTopRow:section] section:section delegate:self];
        }
    }
    assert(mod.headerView_cate);
    return mod.headerView_cate;
}

- (BOOL)indexPathArrayInclude:(NSIndexPath *)_index{
  __block  BOOL ret = NO;
    [self.indexPathMutArray enumerateObjectsUsingBlock:^(NSIndexPath * obj, NSUInteger idx, BOOL *stop) {
        if ([obj compare:_index]==NSOrderedSame) {
            ret = YES;
//            YKLog(@"TT:%d-%d",obj.section,obj.row);
            *stop = YES;
        }
    }];
    
    return ret;
}

- (NSIndexPath *)fixIndex:(NSIndexPath *)_index fromButton:(UIButton *)_orgButton{
    int section = _index.section;
    int row = _index.row;
    row = (_orgButton.tag-2013)+row*self.numberOfColumn;
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}
- (void)delegateAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    assert([sender.superview isKindOfClass:[UITableViewCell class]]);
    UITableViewCell *cell = (UITableViewCell*)sender.superview;
    NSIndexPath *index =  [self.interTable indexPathForCell:cell];
    NSIndexPath *didIndex = [self fixIndex:index fromButton:sender];
    [self addIndexPathMutArrayObject:didIndex];
    [self.delegate headerDetailList:self didTapItemAtIndex:didIndex];
}
- (void)removeInclude:(int )object{
    [self.interTable reloadData];
}

- (void)addIndexPathMutArrayObject:(NSIndexPath *)object{
    if( [self indexPathArrayInclude:object]){
        return;
    }else{
        [self removeInclude:object.section];
        assert(object);
        assert(self.indexPathMutArray);
        assert(object.section<self.indexPathMutArray.count);
        [self.indexPathMutArray replaceObjectAtIndex:object.section withObject:object];
    }
}

#pragma mark Section header delegate
- (int)get_OpenSectionIndex{
    return _openSectionIndex;
}
- (YKFilterDataMoudleList  *)changeSubFromDatasourceItemsAtRow:(int)row{
    
  YKFilterDataMoudleList *dataMoudle  =   [self.sectionInfoDic objectForKey:[NSString stringWithFormat:@"%d",row]];


    if (!dataMoudle) {
        NSArray *ret = [self.datasource itemsAtRow:row];
        YKFilterDataMoudleList *dataMoudle = [[YKFilterDataMoudleList alloc] init];
        dataMoudle.subArray = ret;
        dataMoudle.open = NO;
        assert(dataMoudle);
        [self.sectionInfoDic setObject:dataMoudle forKey:[NSString stringWithFormat:@"%d",row]];
    }
    
    return  [self.sectionInfoDic objectForKey:[NSString stringWithFormat:@"%d",row]];
}
-(void)sectionHeaderView:(YKFilterSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
    YKFilterDataMoudleList *subdata = [self changeSubFromDatasourceItemsAtRow:sectionOpened];
    assert(subdata);
    assert([subdata isKindOfClass:[YKFilterDataMoudleList class] ]);

	subdata.open = YES;
    NSInteger countOfRowsToInsert = (NSInteger)ceilf((CGFloat)[subdata.subArray count]/self.numberOfColumn);
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		YKFilterDataMoudleList *previousOpenSection = [self changeSubFromDatasourceItemsAtRow:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView_cate toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = (NSInteger)ceilf((CGFloat)[previousOpenSection.subArray count]/self.numberOfColumn);
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.interTable beginUpdates];
    [self.interTable insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.interTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.interTable endUpdates];
    
    
    self.openSectionIndex = sectionOpened;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_openSectionIndex" object:nil];
    if ([self.interTable numberOfRowsInSection:_openSectionIndex]>0) {
        [self.interTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_openSectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


-(void)sectionHeaderView:(YKFilterSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	YKFilterDataMoudleList *sectionInfo = [self changeSubFromDatasourceItemsAtRow:sectionClosed];
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.interTable numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.interTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_openSectionIndex" object:nil];
    
}




@end
