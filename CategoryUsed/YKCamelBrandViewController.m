//
//  YKCamelBrandViewController.m
//  YKCamelBrandViewModuleApp
//
//  Created by yanguo.sun on 13-4-21.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelBrandViewController.h"
#import "YKLoopScrollView.h"
#import "UIImageView+WebCache.h"
@interface YKCamelBrandViewController ()<YKLoopScrollViewDelegate>
@property (nonatomic, retain) IBOutlet YKLoopScrollView *loopScrollView ;
@property (strong, nonatomic) IBOutlet UIImageView *loopBackImageView;
@property (strong, nonatomic)  NSMutableDictionary *loopCacheDic;
@property (strong, nonatomic)  NSMutableArray *loopCacheArray;

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@end

@implementation YKCamelBrandViewController



/*
 总共有多少页
 */
-(int) numOfPageForScrollView:(YKLoopScrollView*) ascrollView{
    if (self.brandList!=nil) {
        return self.brandList.count;

    }else{
        _pageControl.numberOfPages = self.loopCacheArray.count;
        _pageControl.currentPage = 0;
       return self.loopCacheArray.count;
    }
}

/*
 第apageIndex 页的图片网址,  view会被设置为新的frame
 @param viewAtPageIndex:[0- viewAtPageIndex];
 */
-(UIView*) scrollView:(YKLoopScrollView*) ascrollView viewAtPageIndex:(int) apageIndex{
    
    UIView *ret = [self.loopCacheDic objectForKey:[NSString stringWithFormat:@"image%d",apageIndex]];
    if (ret) {
        NSLog(@"%p",ret);
        return ret;
    }
    NSURL *url;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 260)];
    if (self.brandList) {
        YKBrand *brand = (YKBrand *)[self.brandList objectAtIndex:apageIndex];
        url = [NSURL URLWithString:brand.imageUrl];
        [image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img_pinpai.png"]];

    }

    assert(url);

    

    
    [self.loopCacheDic setObject:image forKey:[NSString stringWithFormat:@"image%d",apageIndex]];
    return image;
} 



-(void) scrollView:(YKLoopScrollView*) ascrollView didSelectedPageIndex:(int) apageIndex{
    [self.pageControl setCurrentPage:apageIndex];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"品牌馆";
        self.tabBarItem.image = [UIImage imageNamed:[self navTabNormalImageNames][1]];
        self.loopCacheDic = [NSMutableDictionary new];
        // Custom initialization
    }
    return self;
}

- (NSString *)imagesFilePath{
    NSArray *psths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [psths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"brandimage.plist"];
}

- (void)requestBrandInfo{

    
    self.brandOperation = [ApplicationDelegate.camelBrandNetworkEngine completionHandler:^(YKBrandList *brandList) {
        self.brandList = brandList;
        NSLog(@"dacaiguoguo&&&:%@",brandList);
        self.pageControl.numberOfPages = self.brandList.count;
        self.pageControl.currentPage = 0;
        [self.loopScrollView reloadData];

        
    } errorHandler:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    BOOL isPhone5 = [[UIScreen mainScreen] bounds].size.height==568;
    if (isPhone5) {
        self.loopBackImageView.frame = CGRectMake(15, 60, 290, 260);
        self.loopScrollView.frame = self.loopBackImageView.frame;
    }else{
        self.loopBackImageView.frame = CGRectMake(15, 15, 290, 260);
        self.loopScrollView.frame = self.loopBackImageView.frame;
    }
    [self requestBrandInfo];
    [self.loopScrollView reloadData];
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}
//@property (strong) NSString* brandId;
//@property (strong) NSString* title;
//@property (strong) NSString* content;
//@property (strong) NSString* imageUrl;

- (void)goBrandCategoryForBI:(NSString *)_braid{

}
- (IBAction)goBrandCategory:(id)sender {
#ifdef DEBUG
    [self.brandList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        *stop = NO;
    }];
    [self.brandList enumerateObjectsUsingBlock:^(YKBrand* obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"brandId:%@,title:%@,content:%@,imageUrl:%@",obj.brandId,obj.title,obj.content,obj.imageUrl);
    }];
#endif
    NSString *brandid = ((YKBrand*)[self.brandList objectAtIndex:self.pageControl.currentPage]).brandId;
    NSString *title = ((YKBrand*)[self.brandList objectAtIndex:self.pageControl.currentPage]).title;
    [self goBrandCategoryForBI:brandid];
    if (brandid.length==0) {

        return;
    }
    brandid  = brandid.length>0?brandid:@"";
    title = title.length>0 ?title:@"品牌分类";
//    [[[YKModuleManager shareInstance] shareNavModule] gotoControllerWithName:YK_MODULE_NAME_BRAND_CATEGORY params:@{@"brandId":brandid,@"title":title} fromController:self sender:sender];
}
- (void)viewDidUnload {
    [self setLoopBackImageView:nil];
    [super viewDidUnload];
}
@end
