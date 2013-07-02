//
//  YKXIBHelper.m
//  VANCL
//
//  Created by sihai on 10-11-24.
//  Copyright 2010 yek. All rights reserved.
//

#import "YKXIBHelper.h"


@implementation YKXIBHelper


+(id)loadObjectFromXIBName:(NSString*) xibName type:(Class) type {
	return [self loadObjectFromXIBName:xibName type:type index:0];
}
+(id)loadObjectFromXIBName:(NSString*) xibName type:(Class) type index:(int) index {
// NSLog(@"+(id)loadObjectFromXIBName:(NSString*) xibName=%@ type:(Class) type=%@ index:(int) index=%d ",xibName,type,index);
	assert(xibName!=nil);
	assert(type!=nil);
	id ret=nil;
	int objectIndex=0;
	NSArray* objectArray=[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
	for(id obj in objectArray){
		if([[obj class] isEqual:type]){
			if(objectIndex==index){
                ret = obj;
				break;
			}
			++objectIndex;
		}
	}
	assert(ret!=nil);
	return ret;
}

@end
