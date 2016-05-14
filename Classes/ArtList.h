//
//  ArtList.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/16/11.
//  Copyright 2011 Brian Strull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseOperationDelegate.h"

@class Artwork;


@interface ArtList : NSObject <NSXMLParserDelegate> {

	NSMutableDictionary *works;
	BOOL ready;

@private
	
	NSXMLParser * rssParser; 
	Artwork *art;
	NSString *currentElement;
	id <ParseOperationDelegate> __weak artDelegate;
}

@property (nonatomic, strong) NSMutableDictionary *works;
@property (nonatomic, strong) NSXMLParser *rssParser;
@property (nonatomic, strong) Artwork *art;
@property (nonatomic, strong) NSString *currentElement;
@property (assign) BOOL ready;
@property (nonatomic,weak) id <ParseOperationDelegate> artDelegate;

- (id) init:(id <ParseOperationDelegate>)theDelegate;
- (Artwork*) findArt:(NSString*)workid;
- (void)parseXMLFileAtURL:(NSString *)URL;

@end






