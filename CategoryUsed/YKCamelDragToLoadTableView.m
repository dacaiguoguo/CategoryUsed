/*
 * This file is part of the DragToLoadTableView package.
 * (c) Thongchai Kolyutsakul <thongchaikol@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Created on 27/1/2011.
 */

#import "YKCamelDragToLoadTableView.h"


@interface YKCamelDragToLoadTableView (private)
-(void)setTableViewRefresh;
-(void)setTableViewNormal;
-(int)calcBottomOffset:(UIScrollView*)scrollView;
-(NSString*)getCurrentDateString;
@end

// Top labels
#define kLABEL_TOP	 @"下拉刷新..."
#define kRELEASE_TOP @"松手刷新..."
#define kLOADING_TOP @"正在加载..."

// Bottom labels
#define kLABEL_BOTTOM   @"上拉加载..."
#define kRELEASE_BOTTOM @"松手加载..."
#define kLOADING_BOTTOM @"正在加载..."

@implementation YKCamelDragToLoadTableView

@synthesize dragDelegate,tableDelegate;
@synthesize bottomView,num_bottom_row,kCellHeight, kStatusBarHeight, kTriggerDist, kDateLabelOffset;

#define applyAutoResizeToView(v)    v.autoresizesSubviews = YES; \
v.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

-(id)initWithCoder:(NSCoder*)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		kCellHeight = 40.f; // height of top and bottom loading views
		kTriggerDist = 5.0f; // releasing distance before triggering load
		kStatusBarHeight = 20.0f;
		kDateLabelOffset = 10.0f;
		int arrow_offset = 100.0f;
        int defaultWidth = 320;
        
		state = YKCamelDragToLoadTableStateIdle;
		num_bottom_row = 0;
		
		// --- TOP ---
		topView = [[UIView alloc] initWithFrame:CGRectMake(0, -kCellHeight, defaultWidth, kCellHeight-1)]; // kCellHeight-1 to leave some space for the line
        applyAutoResizeToView(topView)
		topView.backgroundColor = [UIColor clearColor];
		
		labelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, kCellHeight)]; // -8 to move label up a bit
		labelTop.textAlignment = UITextAlignmentCenter;
		labelTop.backgroundColor = [UIColor clearColor];
		labelTop.text = kLABEL_TOP;
		[topView addSubview:labelTop];
		
//		labelDateTop = [[UILabel alloc] initWithFrame:CGRectMake(0, kDateLabelOffset, defaultWidth, kCellHeight)];
//		labelDateTop.textAlignment = UITextAlignmentCenter;
//		labelDateTop.backgroundColor = [UIColor clearColor];
//		labelDateTop.textColor = [UIColor grayColor];
//		labelDateTop.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
//		labelDateTop.text = [self getCurrentDateString];
//		[topView addSubview:labelDateTop];
        NSArray  *names = @[@"common_img_loadinga",@"common_img_loadingb",@"common_img_loadingb",@"common_img_loadingc",@"common_img_loadingd",@"common_img_loadinge",@"common_img_loadingf",@"common_img_loadingg",@"common_img_loadingh",@"common_img_loadingi",@"common_img_loadingj"];
        NSMutableArray *images= [NSMutableArray arrayWithCapacity:1];
        for (NSString *name in names) {
            [images addObject:[UIImage imageNamed:name]];
        }
		idViewTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        idViewTop.contentMode = UIViewContentModeScaleAspectFit;
		idViewTop.center = CGPointMake(arrow_offset, kCellHeight/2);
//		idViewTop.hidesWhenStopped = YES;
        idViewTop.animationImages = images;
        idViewTop.animationDuration = 3;
		[topView addSubview:idViewTop];
		
		UIImage *arrow = [UIImage imageNamed:@"liebiao_img_xiangshang.png"];
		int arrow_W = arrow.size.width;
		int arrow_H = arrow.size.height;
		
		arrowTop = [[UIImageView alloc] initWithFrame:
					CGRectMake(idViewTop.center.x-arrow_W/2, idViewTop.center.y-arrow_H/2, arrow_W, arrow_H)];
		arrowTop.image = arrow;
		arrowTop.transform = CGAffineTransformMakeRotation(M_PI);
		[topView addSubview:arrowTop];
		arrowTop.alpha = 1;
		
		[self addSubview:topView];
		
		
		// --- BOTTOM ---
		bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, kCellHeight)];
        applyAutoResizeToView(bottomView)
		bottomView.backgroundColor = [UIColor clearColor];
		
		labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, kCellHeight)];
		labelBottom.textAlignment = UITextAlignmentCenter;
		labelBottom.backgroundColor = [UIColor clearColor];
		labelBottom.text = kLABEL_BOTTOM;
		[bottomView addSubview:labelBottom];
		
		idViewBottom = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, 16, 16)];
		idViewBottom.center = CGPointMake(arrow_offset, kCellHeight/2);
        idViewBottom.animationImages = images;
        idViewBottom.contentMode = UIViewContentModeScaleAspectFit;
        idViewBottom.animationDuration = 3;
		[bottomView addSubview:idViewBottom];
		
		arrowBottom = [[UIImageView alloc] initWithFrame:
                       CGRectMake(idViewBottom.center.x-arrow_W/2, idViewBottom.center.y-arrow_H/2, arrow_W, arrow_H)];
		arrowBottom.image = arrow;
		[bottomView addSubview:arrowBottom];
		arrowBottom.alpha = 1;
		//**later release bottomView in dealloc, unlike topView**
		
		self.delegate = self;
		self.dataSource = self; //can overwrite dataSource inside parent nib or viewDidLoad
	}
	return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Did select
    if ([tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:) ]) {

        [tableDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
 
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:) ]) {
        
       return [tableDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:) ]) {
        
        [tableDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }

    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:) ]) {
        
        return [tableDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark -
#pragma mark External

-(void)stopAllLoadingAnimation {
	[idViewTop stopAnimating];
	labelTop.text = kLABEL_TOP;
	[idViewBottom stopAnimating];
	labelBottom.text = kLABEL_BOTTOM;
	if (state == YKCamelDragToLoadTableStateLoadingTop) {
		labelDateTop.text = [self getCurrentDateString];
	}
	if (self.contentOffset.y <= 0)  {
		[self performSelector:@selector(setTableViewNormal) withObject:nil afterDelay:0];
	}
	arrowTop.alpha = arrowBottom.alpha = 1;
	state = YKCamelDragToLoadTableStateIdle;
}

-(void)enableLoadBottom {
      
	num_bottom_row = 1;
	[self reloadData];
}

-(void)disableLoadBottom {
      
	
	num_bottom_row = 0;
	
	[self reloadData];  // need reloadData here cuz the relaodSection method in 'disableLoadBottom'
    // will check numberOfRowsInSection consistency. And since we add rows to
    // the first section we need to update the numberOfRowsInSection to avoid SIGABRT
	
	// smoothly remove bottom section
	[self reloadSections:[NSIndexSet indexSetWithIndex:[self numberOfSectionsInTableView:self]-1] withRowAnimation:UITableViewRowAnimationBottom];
	
	[self reloadData];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
      
	if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return nil;
	}
	else {
		if ([tableDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:) ]) {
			return [tableDelegate tableView:tableView viewForHeaderInSection:section];
		}
		return nil;
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	  
    if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return nil;
	}
	else {
		if ([tableDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:) ]) {
			return [tableDelegate tableView:tableView viewForFooterInSection:section];
		}
		return nil;
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      
	if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return 0.0;
	}
	else {
		if ([tableDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:) ]) {
			return [tableDelegate tableView:tableView heightForHeaderInSection:section];
		}
		return 0.0;
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	  
    if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return 0.0;
	}
	else {
		if ([tableDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:) ]) {
			return [tableDelegate tableView:tableView heightForFooterInSection:section];
		}
		return 0.0;
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	  
    if (indexPath.section == [self numberOfSectionsInTableView:tableView]-1) {
		return kCellHeight;
	}
	else {
		if ([tableDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:) ]) {
			return [tableDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
		}
		return kCellHeight;
	}
}


#pragma mark -
#pragma mark UITableView Delegates (DragTableDelegate)



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     
    // Return the number of sections.
	if ([tableDelegate respondsToSelector:@selector(numberOfSectionsInTableView:) ]) {
		//NSLog(@"numberOfSectionsInTableView %d",[tableDelegate numberOfSectionsInTableView:tableView]+1);
		return [tableDelegate numberOfSectionsInTableView:tableView]+1;
	}
	else return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
      
    if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return self.num_bottom_row;
	}
	else {
		//*** place your row count here ***//
		if ([tableDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:) ]) {
#ifdef DEBUG
			NSLog(@"numRow %d",[tableDelegate tableView:tableView numberOfRowsInSection:section]);
#endif
			return [tableDelegate tableView:tableView numberOfRowsInSection:section];
		}
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)itableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
      
    if ([indexPath section] == [self numberOfSectionsInTableView:itableView]-1) {
		static NSString *reuseIden = @"cellMore";
		UITableViewCell *cell = [itableView dequeueReusableCellWithIdentifier:reuseIden];
		if(cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIden] ;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			[cell addSubview:bottomView];
		}
		return cell;
	}
	else {
		//*** place your cells here ***//
		if ([tableDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:) ]) {
			return [tableDelegate tableView:itableView cellForRowAtIndexPath:indexPath];
		}
	}
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
     

    if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return nil;
	}
	if ([tableDelegate respondsToSelector:@selector(tableView:titleForHeaderInSection:) ]) {
		return [tableDelegate tableView:tableView titleForHeaderInSection:section];
	}
	return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	
     

    if (section == [self numberOfSectionsInTableView:tableView]-1) {
		return nil;
	}
	if ([tableDelegate respondsToSelector:@selector(tableView:titleForFooterInSection:) ]) {
		return [tableDelegate tableView:tableView titleForFooterInSection:section];
	}
	return nil;
}

#pragma mark -
#pragma mark scrollView delegates

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
     

	if (state == YKCamelDragToLoadTableStateIdle) {
		// scroll over top
		if (scrollView.contentOffset.y <= -kCellHeight-kTriggerDist) {
			[self triggerLoadTop];
			
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setTableViewNormal) object:nil];
			offset_old = scrollView.contentOffset.y; //preserve old offset
			
			scrollView.bounces = NO; // disable off edge auto scroll, *xx* flash to top bug *xx*
			scrollView.scrollEnabled = NO;
			scrollView.showsVerticalScrollIndicator = NO;
			//scrollView.alpha = 0; // *** hide flash top bug ***
            
			[self performSelector:@selector(setTableViewRefresh) withObject:nil afterDelay:0];
		}
		// scroll below bottom
		else if (num_bottom_row > 0) { // if loadBottom enabled
			if (scrollView.contentOffset.y >= kTriggerDist+[self calcBottomOffset:scrollView]) {
				[self triggerLoadBottom];
			}
		}
	}
}


-(void)triggerLoadTop {

     

	[self stopAllLoadingAnimation];
	state = YKCamelDragToLoadTableStateLoadingTop;
	
	[UIView beginAnimations:nil context:nil]; // arrow spin back and fade out
	[UIView setAnimationDuration:0.f];
	arrowTop.alpha = 0;
	arrowTop.transform = CGAffineTransformMakeRotation(M_PI);
	[UIView commitAnimations];
	
	[idViewTop startAnimating];
    
	labelTop.text = kLOADING_TOP;
	
	if ([dragDelegate respondsToSelector:@selector(startLoadTop) ]){
		[dragDelegate performSelectorOnMainThread:@selector(startLoadTop) withObject:nil waitUntilDone:YES];
	}
}

-(void)triggerLoadBottom {
     

	[self stopAllLoadingAnimation];
	state = YKCamelDragToLoadTableStateLoadingBottom;
    
	[UIView beginAnimations:nil context:nil]; // arrow spin back and fade out
	[UIView setAnimationDuration:0.f];
	arrowBottom.alpha = 0;
	arrowBottom.transform = CGAffineTransformMakeRotation(0);
	[UIView commitAnimations];
    
	[idViewBottom startAnimating];
	labelBottom.text = kLOADING_BOTTOM;
	if ([dragDelegate respondsToSelector:@selector(startLoadBottom) ]){
		[dragDelegate performSelectorOnMainThread:@selector(startLoadBottom) withObject:nil waitUntilDone:YES];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

     

	scrollView.scrollEnabled = YES;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.bounces = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
     

    if (!scrollView.isDecelerating && state == YKCamelDragToLoadTableStateIdle) { // have to be dragging
		if (arrowTop.alpha){
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3f];
			if (scrollView.contentOffset.y <= -kCellHeight-kTriggerDist) {
				arrowTop.transform = CGAffineTransformIdentity;
				labelTop.text = kRELEASE_TOP;
			}
			else {
				arrowTop.transform = CGAffineTransformMakeRotation(M_PI);
				labelTop.text = kLABEL_TOP;
			}
			[UIView commitAnimations];
		}
		if (arrowBottom.alpha){
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3f];
			if (scrollView.contentOffset.y >= kTriggerDist+[self calcBottomOffset:scrollView]) {
				arrowBottom.transform = CGAffineTransformMakeRotation(M_PI);
				labelBottom.text = kRELEASE_BOTTOM;
			}
			else {
				arrowBottom.transform = CGAffineTransformIdentity;
				labelBottom.text = kLABEL_BOTTOM;
			}
			[UIView commitAnimations];
		}
	}
}


#pragma mark Internal

-(NSString*)getCurrentDateString {
     

	NSDateFormatter *format = [[NSDateFormatter alloc] init] ;
	[format setDateFormat:@"dd-MM-yyyy HH:mm"];
	NSDate *now = [[NSDate alloc] init] ;
	return [NSString stringWithFormat:@"最后更新日期: %@",[format stringFromDate:now]];
}

-(int)calcBottomOffset:(UIScrollView*)scrollView {
     

	int bottomOffset = scrollView.contentSize.height - scrollView.frame.size.height;
	if (bottomOffset < 0) bottomOffset = 0;
	return bottomOffset;
}

-(void)enableBounce { self.bounces = YES; }

-(void)setTableViewRefresh {
     

	//self.alpha = 1; // *** hide flash top bug ***
	[self setContentOffset:CGPointMake(0, offset_old) animated:NO];
	[self setContentOffset:CGPointMake(0, -kCellHeight) animated:YES];
}

-(void)setTableViewNormal {
     

	if (state == YKCamelDragToLoadTableStateLoadingTop) [self setContentOffset:CGPointMake(0, -kCellHeight) animated:NO];
	[self setContentOffset:CGPointMake(0, 0) animated:YES];
	state = YKCamelDragToLoadTableStateIdle;
}

// override reloadData to avoid immediate contentOffset change from original reloadData
- (void)reloadData {
     

    CGPoint oldPt = self.contentOffset;
    [super reloadData];
    [self setContentOffset:oldPt animated:NO];
}




@end
