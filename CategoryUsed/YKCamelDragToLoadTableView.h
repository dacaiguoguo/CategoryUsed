/*
 * This file is part of the DragToLoadTableView package.
 * (c) Thongchai Kolyutsakul <thongchaikol@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Created on 27/1/2011.
 *
 *
 *
 *
 *
 *
 * 图片名称如下：a-j  framework 不打包图片的话，应该提供如下名称的图片。
 *         NSArray  *names = @[@"common_img_loadinga",@"common_img_loadingb",@"common_img_loadingb",@"common_img_loadingc",@"common_img_loadingd",@"common_img_loadinge",@"common_img_loadingf",@"common_img_loadingg",@"common_img_loadingh",@"common_img_loadingi",@"common_img_loadingj"];
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    YKCamelDragToLoadTableStateIdle,
    YKCamelDragToLoadTableStateLoadingTop,
	YKCamelDragToLoadTableStateLoadingBottom
} YKCamelDragToLoadTableState;

@protocol YKCamelDragToLoadTableViewDelegate,YKCamelDragTableDelegate;



@interface YKCamelDragToLoadTableView : UITableView <UITableViewDelegate,UITableViewDataSource> {

	
	UIView *topView;
	UIImageView  *idViewTop;
	UILabel *labelTop;
	UILabel *labelDateTop;
	UIImageView *arrowTop;
	BOOL isArrowOn;
	
	UIView *bottomView;
	UIImageView *idViewBottom;
	UILabel *labelBottom;
	UIImageView *arrowBottom;
    
	int offset_old; //preserve old offset when loadingTop for animation
	int num_bottom_row; //show or hide bottomView in the last table section, normally 0 or 1
	int kCellHeight, kStatusBarHeight, kTriggerDist, kDateLabelOffset;
	
	BOOL isLoadingTop;
	YKCamelDragToLoadTableState state;
}
@property (nonatomic, assign) IBOutlet NSObject <YKCamelDragToLoadTableViewDelegate> *dragDelegate;
@property (nonatomic, assign) IBOutlet NSObject <YKCamelDragTableDelegate> *tableDelegate;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, assign) int num_bottom_row, kCellHeight, kStatusBarHeight, kTriggerDist, kDateLabelOffset;
-(void)stopAllLoadingAnimation;

// enable or disable pull up to load
-(void)enableLoadBottom;
-(void)disableLoadBottom;

-(void)triggerLoadTop;
-(void)triggerLoadBottom;
@end

@protocol YKCamelDragToLoadTableViewDelegate
@optional
-(void)startLoadTop;
-(void)startLoadBottom;
@end

@protocol YKCamelDragTableDelegate
@optional
// delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
// dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)itableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
@end