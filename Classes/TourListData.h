//
//  TourListData.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/1/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseOperationDelegate.h"

@class TourData;

@interface TourListData : NSObject  <NSXMLParserDelegate> {

	NSMutableArray* tours;
	BOOL ready;
	
@private
	
	NSXMLParser * rssParser; 
	TourData *tour;
	NSString *currentElement;
	id <ParseOperationDelegate> __weak tourDelegate;
}

@property (nonatomic, strong) NSMutableArray* tours;

@property (nonatomic, strong) NSXMLParser *rssParser;
@property (nonatomic, strong) TourData *tour;
@property (nonatomic, strong) NSString *currentElement;
@property (assign) BOOL ready;
@property (nonatomic,weak) id <ParseOperationDelegate> tourDelegate;

- (id) init:(id <ParseOperationDelegate>) theDelegate;
- (void)parseXMLFileAtURL:(NSString *)URL;
-(void) retry;

@end


