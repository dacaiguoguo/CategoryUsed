//
//  YKCamelNoticeView.m
//  HomeUpView
//
//  Created by yanguo.sun on 13-5-20.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import"YKCamelNoticeView.h"



@implementation YKCamelNoticeView{
    int count;
    BOOL toEnd;
}
@synthesize totalRow;
- (void)runloop:(id)sender{

    count++;
    if (count==totalRow) {
        toEnd = YES;
    }
    if ([self.interTableView numberOfRowsInSection:0]>count-1) {

    [self.interTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    count = count%totalRow;
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (toEnd) {
        if ([self.interTableView numberOfRowsInSection:0]>0) {
            [self.interTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];

        }
        count = 0;
        toEnd = NO;
    }
}
- (void)remove:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(noticeView:closeAction:)]) {
        [self.delegate noticeView:self closeAction:sender];
    }
}

- (void)interInit{
    count = 0;
    self.interTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.interTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.interTableView.delegate = self;
    self.interTableView.dataSource = self;
    self.interTableView.scrollEnabled = NO;
    self.interTableView.scrollsToTop = NO;
    self.interTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye_bg_tixing.png"]];
    self.interTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.interTableView];

    
    self.accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accessoryButton setImage:[UIImage imageNamed:@"shouye_btn_guanbi.png"] forState:UIControlStateNormal];
    [self.accessoryButton addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    CGRect accessoryFrame = self.bounds;
    accessoryFrame.origin.x = self.bounds.size.width-self.bounds.size.height;
    accessoryFrame.size.width = accessoryFrame.size.height;
    self.accessoryButton.frame = accessoryFrame;
    [self addSubview:self.accessoryButton];
    self.moveTimer =  [NSTimer timerWithTimeInterval:YK_NOTICE_VIEW_ANIM_DURATION target:self selector:@selector(runloop:) userInfo:nil repeats:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self interInit];
    }
    return self;
}

- (void)startUp{
    //
    if (totalRow==1) {
        
    }else{

            [[NSRunLoop mainRunLoop] addTimer:self.moveTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopUp{
    [self.moveTimer invalidate];

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self interInit];
    }
    return self;
}

- (void)reloadData{
    [self.interTableView reloadData];
}
- (void)setDataSource:(id<YKCamelNoticeViewDataSource>)dataSource{
    assert([dataSource respondsToSelector:@selector(titleForRow:)]);
    _dataSource = dataSource;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    YKLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(noticeView:didSelectRow:)]) {
        [self.delegate noticeView:self didSelectRow:indexPath.row];
    }
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalRow*2;
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idfi = @"YKTableViewCellCamelNoticeViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfi];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idfi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = YK_TITLE_TEXT_COLOR;
        cell.textLabel.font = YK_TITLE_TEXT_FONT;
    }

    cell.textLabel.text = [self.dataSource titleForRow:indexPath.row%totalRow];
    return cell;
}

@end

@interface YKCamelNoticeView2 ()

@end

#define maxTtt 200
@implementation YKCamelNoticeView2


- (void)runloop:(id)sender{
    static  int a = 0;

    a++;
    if (a==_titlesArray.count*maxTtt) {
        a=0;
        [self.interTableView setContentOffset:CGPointZero animated:NO];
    }else{
        [self.interTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:a inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
    
}


- (void)remove:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(noticeView:closeAction:)]) {
        [self.delegate noticeView:self closeAction:sender];
    }
}

- (void)interInit{
    self.interTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.interTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.interTableView.delegate = self;
    self.interTableView.dataSource = self;
    self.interTableView.scrollEnabled = NO;
    self.interTableView.scrollsToTop = NO;
    self.interTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye_bg_tixing.png"]];
    self.interTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.interTableView];
    

    self.accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accessoryButton setImage:[UIImage imageNamed:@"shouye_btn_guanbi.png"] forState:UIControlStateNormal];
    [self.accessoryButton addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    CGRect accessoryFrame = self.bounds;
    accessoryFrame.origin.x = self.bounds.size.width-self.bounds.size.height;
    accessoryFrame.size.width = accessoryFrame.size.height;
    self.accessoryButton.frame = accessoryFrame;
    [self addSubview:self.accessoryButton];
    self.moveTimer =  [NSTimer timerWithTimeInterval:YK_NOTICE_VIEW_ANIM_DURATION target:self selector:@selector(runloop:) userInfo:nil repeats:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self interInit];
    }
    return self;
}

- (void)startUp{
    //
    if (_titlesArray.count>1) {
        [[NSRunLoop mainRunLoop] addTimer:self.moveTimer forMode:NSRunLoopCommonModes];

    }else{
        
    }
}

- (void)stopUp{
    [self.moveTimer invalidate];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self interInit];
    }
    return self;
}

- (void)reloadData{
    [self.interTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    YKLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(noticeView:didSelectRow:)]) {
        [self.delegate noticeView:self didSelectRow:indexPath.row%_titlesArray.count];
    }
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesArray.count*maxTtt;
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idfi = @"YKTableViewCellCamelNoticeView2Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfi];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idfi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = YK_TITLE_TEXT_COLOR;
        cell.textLabel.font = YK_TITLE_TEXT_FONT;
    }
    
    cell.textLabel.text = [_titlesArray objectAtIndex:indexPath.row%_titlesArray.count];
    return cell;
}

@end








