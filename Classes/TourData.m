//
//  TourData.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/1/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "TourData.h"


@implementation TourData

@synthesize	name,desc, ids;

- (id)init
{
	self = [super init];
	if (self) {
		/* class-specific initialization goes here */
		name = [[NSMutableString alloc] init];
		desc = [[NSMutableString alloc] init];
		ids = [[NSMutableString alloc] init];
	}
	return self;
}


@end
