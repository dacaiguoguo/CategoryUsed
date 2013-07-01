//
//  YKCamelHomeViewController.m
//  YKCamelHomeModule
//
//  Created by TFH on 13-4-15.
//  Copyright (c) 2013年 yek. All rights reserved.
//

#import "YKCamelHomeViewController.h"
#import"YKCamelNoticeView.h"


//test by dacaiguoguo 

@interface YKCamelHomeViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *bannerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *htmlCell;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet YKCamelNoticeView2 *noticeView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIPageControl *topicPageControl;
@property (strong, nonatomic) YKHome* home;
@property (unsafe_unretained, nonatomic) IBOutlet YKLoopScrollView *topicScrollView;
@end

@implementation YKCamelHomeViewController{
    int webcellHeight;
}
@synthesize topicScrollView;
@synthesize bannerCell;
@synthesize htmlCell;
@synthesize webView;
@synthesize noticeView;
@synthesize tableView;

+(NSString *)moduleName{
    return @"home";
}
+ (int)priority{
    return 1;
}
+(id)shareInstance{
    static dispatch_once_t onceToken;
    static YKCamelHomeViewController* ret=nil;
    dispatch_once(&onceToken, ^{
        ret=[[YKCamelHomeViewController alloc] initWithNibName:@"YKCamelHomeViewController" bundle:nil];
    });
    assert(ret!=nil);
    return ret;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:[self navTabNormalImageNames][0]];
        
        {//navbar 左侧的logo
            UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 46)];
            v.clipsToBounds=YES;
            UIImageView* iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye_img_logo.png"]];
            [v addSubview:iv];
            UIBarButtonItem* btnitem=[[UIBarButtonItem alloc] initWithCustomView:v];
            self.navigationItem.leftBarButtonItem=btnitem;
            self.navigationItem.title = nil;
        }
        self.navigationItem.rightBarButtonItem=[self createNavRightItemButtonWithNormalImageName:@"common_btn_sousuo_normal.png" selectedImageName:@"common_btn_sousuo_selected.png" target:self action:@selector(onSearchButtonTap:)];
    }
    return self;
}

//添加 右边按钮
-(UIBarButtonItem*) createNavRightItemButtonWithNormalImageName:(NSString*) animg selectedImageName:(NSString*) asimselect target:(id) target action:(SEL)action{
    {//创建右边返回按钮
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(5, 1.5, 50, 47);
        [btn setImage:[UIImage imageNamed:animg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:asimselect] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:asimselect] forState:UIControlStateHighlighted];
        //common_btn_shaixuan_normal
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 47)];  //直接设置 btn.frame x=-10 不好使
        view.backgroundColor=[UIColor clearColor];
        [view addSubview:btn];
        
        UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithCustomView:view];
        return item;
    }
}


-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    首页不应该cancel
//    if(self.homeOperation) {
//        
//        [self.homeOperation cancel];
//        self.homeOperation = nil;
//    }
}

- (void)requestData{
    
    self.homeOperation = [ApplicationDelegate.camelHomeNetworkEngine completionHandler:^(YKHome *home) {
        self.home = home;
        [self.webView loadHTMLString:home.htmlUrl baseURL:nil];
        
        if([self.home.noticeList count]>0){

            
//TEST
           if(1) {
                YKNotice *notice = [YKNotice new];
                notice.title = @"2222";
                notice.noticeId = @"223";
                notice.actionUrl = @"afsdf";
                [self.home.noticeList addObject:notice];
                YKNotice *notice2 = [YKNotice new];
                notice2.title = @"3333";
                notice2.noticeId = @"33223";
                notice2.actionUrl = @"afsdf";
                [self.home.noticeList addObject:notice2];

            }
            
            
            //显示 noticeview
            [self showNotice];
            
        }else{
            //隐藏 noticeview
            [self hideNotice];
        }
        
        //todo:计算高度
        [self.tableView reloadData];
        [self.topicScrollView reloadData];
        self.topicPageControl.numberOfPages = self.home.topicList.count;
        
    } errorHandler:^(NSError *error) {
        
    }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    {
    webcellHeight= self.tableView.frame.size.height-170;
        //禁止webview 滚动
        for (UIView *view in self.webView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.scrollEnabled = NO;
            }
        }
    }

    
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestData) object:nil];
        [self requestData];
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}
- (void)viewDidUnload
{
    [self setBannerCell:nil];
    [self setHtmlCell:nil];
    [self setWebView:nil];
    [self setNoticeView:nil];
    [self setTableView:nil];
    [self setTopicScrollView:nil];
    [self setTopicPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) onSearchButtonTap:(id) sender{
}


#pragma mark table method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array=@[self.bannerCell,self.htmlCell];
    UITableViewCell* ret=[array objectAtIndex:indexPath.row];
    return ret;
}

-(CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int ret=0;
    switch (indexPath.row) {
        case 0:
            ret=170;
            break;
        case 1:
            ret=webcellHeight;
            //TODO:IMP
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark webview
- (NSString *)classNameFrom:(NSURL *)aurl{
    NSString* className=nil;

        NSArray* pathCompones=[aurl pathComponents];
        assert([pathCompones count]>0);

        if([pathCompones count]>1){
            className=[pathCompones objectAtIndex:1];
        }
    return className.length>0?className:@"";
}

- (void)BIOperationWith:(NSString *)classname{
    if([classname isEqualToString:@"SecKillList"]) {
        
    }
    if ([classname isEqualToString:@"ProductList"]) {
        
    }
    if ([classname isEqualToString:@"BonusList"]) {
        
    }
    if ([classname isEqualToString:@"GrouponList"]) {
        
    }
    if ([classname isEqualToString:@"SkillList"]||[classname isEqualToString:@"SecKillList"]) {
        
#ifdef DEBUG
        NSLog(@"className：%@",classname);
#endif
        
    }
    if ([classname isEqualToString:@"LotteryDetail"]) {
        
        
        
    }
}



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL ret=YES;
    if([[[request URL] scheme] isEqualToString:@"app"]){
        
        NSString *className = [self classNameFrom:request.URL];
        [self BIOperationWith:className];
#ifdef DEBUG
        NSLog(@"className：%@",className);
#endif
        ret=NO;
    }
    return ret;
}
-(void)webViewDidFinishLoad:(UIWebView *)aWebView{
    {//设置cell高度

        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0){
            //self.webView.contentMode
        }
        NSString* heightString=[aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('body').clientHeight"];

//        NSString* heightString=[aWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
        int h=MAX([heightString intValue], self.tableView.frame.size.height-170);

        webcellHeight=h;

        [self.tableView reloadData];
    }
}

#pragma mark notice
- (void)noticeView:(YKCamelNoticeView2 *)noticeV didSelectRow:(int)row{
    NSString *title =  ((YKNotice *)[self.home.noticeList objectAtIndex:row]).actionUrl;
    NSURL *url = [NSURL URLWithString:title];
#ifdef DEBUG
 NSLog(@"tourl:%@",url);
#endif
    
    

}
- (void)noticeView:(YKCamelNoticeView2 *)noticeV closeAction:(UIButton*)sender{
    [self hideNotice];
}

- (NSString *)titleForRow:(int)_r{
    NSString *title  = @"";
    if (_r<self.home.noticeList.count) {
        title =  ((YKNotice *)[self.home.noticeList objectAtIndex:_r]).title;
        
    }
    return title;
    //TEST
    //    return [NSString stringWithFormat:@"%@:%d",title,_r];
}

-(void) hideNotice{
    self.noticeView.hidden=YES;
    CGRect tableFrame=self.view.bounds;
    self.tableView.frame=tableFrame;
}

-(void) showNotice{
    //显示 noticeview
    self.noticeView.hidden=NO;
    assert([self.home.noticeList count]>0);
    CGRect tableFrame=CGRectMake(0, self.noticeView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.noticeView.frame.size.height);
    self.tableView.frame=tableFrame;
    
    NSMutableArray *tits = [NSMutableArray new];
    for (int i=0; i<self.home.noticeList.count; i++) {
        YKNotice *tesmtp = self.home.noticeList[i];
        [tits addObject:tesmtp.title];
    }
    self.noticeView.titlesArray = tits;
    [self.noticeView reloadData];
    if (self.home.noticeList.count==1) {
        
    }else
        [self.noticeView startUp];
    
}




#pragma mark loop scroll view
-(int)numOfPageForScrollView:(YKLoopScrollView *)ascrollView{
    int ret=0;

    if (self.home) {
        ret=[self.home.topicList count];
    }    
    return ret;
}

-(void) scrollView:(YKLoopScrollView*) ascrollView didSelectedPageIndex:(int) apageIndex{
    [self.topicPageControl setCurrentPage:apageIndex];
}

-(UIView *)scrollView:(YKLoopScrollView *)ascrollView viewAtPageIndex:(int)apageIndex{
    UIView* ret=[[UIView alloc] initWithFrame:ascrollView.bounds];
    UIImageView* iv=[[UIImageView alloc] initWithFrame:ret.bounds];
    [ret addSubview:iv];
//    UILabel* label=[[UILabel alloc] initWithFrame:ret.bounds];
//    label.backgroundColor=[UIColor clearColor];
//    [ret addSubview:label];
//    label.text=[NSString stringWithFormat:@"%d",apageIndex];
    
    if (self.home) {
        YKTopic* t=[self.home.topicList objectAtIndex:apageIndex];
        
        //测试数据
        //    NSURL* url=[NSURL URLWithString:@"http://www.baidu.com/img/shouye_b5486898c692066bd2cbaeda86d74448.gif"];
        NSURL* url=[NSURL URLWithString:t.imageUrl];
        
        [iv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img_shouyebanner.png"]];
    }
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=ret.bounds;
    [ret addSubview:button];
    button.tag=apageIndex;
    [button addTarget:self action:@selector(onTopicButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

-(void) onTopicButtonTap:(UIButton*) sender{
    
    int topicIndex=sender.tag;
#ifdef DEBUG
    NSLog(@"%s topicIndex=%d",__func__,topicIndex);
#endif
    YKTopic* t=[self.home.topicList objectAtIndex:topicIndex];
    if (t.actionUrl.length==0) {

        return;
    }
    assert(t.actionUrl!=nil);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onTopicButtonTap" object:t.actionUrl];
}

@end





