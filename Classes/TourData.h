//
//  TourData.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/1/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TourData : NSObject {

	NSMutableString* name;
	NSMutableString* desc;
	NSMutableString* ids;
}


@property (nonatomic, strong) NSMutableString* name;
@property (nonatomic, strong) NSMutableString* desc;
@property (nonatomic, strong) NSMutableString* ids;

@end
