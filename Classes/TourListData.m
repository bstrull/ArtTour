//
//  TourListData.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/1/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "TourListData.h"
#import "TourData.h"
#import "ParseOperationDelegate.h"

@implementation TourListData


@synthesize tours, rssParser, tour, currentElement, ready,tourDelegate;


- (id) init:(id<ParseOperationDelegate>) theDelegate
{
	self = [super init];
	if (self) {
		ready = FALSE;
		tourDelegate = theDelegate;
		self.tours = [[NSMutableArray alloc] initWithCapacity:10];
		
		// load works from xml
		 NSString* path = [[NSBundle mainBundle] pathForResource:@"TourData" ofType:@"xml"];
        // @"http://192.168.0.16/lofa.org/tour/data/TourData.xml";
        // @"http://www.artscouncillo.org/tour/data/TourData.xml";
		[self parseXMLFileAtURL:path];
	}
	return self;
}


/*
 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyFile" ofType:@"txt"];
 NSData *myData = [NSData dataWithContentsOfFile:filePath];  */

- (void) retry
{
	// load works from xml
	 NSString* path = [[NSBundle mainBundle] pathForResource:@"TourData" ofType:@"xml"];
    // @"http://192.168.0.8/~skifreak/lofa.org/tour/data/TourData.xml";
    //  @"http://www.artscouncillo.org/tour/data/TourData.xml";
	[self parseXMLFileAtURL:path];	
}


- (void)parseXMLFileAtURL:(NSString *)URL
{ 
	//you must then convert the path to a proper NSURL or it won't work 
	// NSURL *xmlURL = [NSURL URLWithString:URL];
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, 
	// otherwise you will get an object not found error 
	// this may be necessary only for the toolchain 
	// rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks. 
	
	// for now, XML is local, not a URL
    rssParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:URL]];

	[rssParser setDelegate:self]; 
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser. 
	[rssParser setShouldProcessNamespaces:NO]; 
	[rssParser setShouldReportNamespacePrefixes:NO]; 
	[rssParser setShouldResolveExternalEntities:NO]; 
	[rssParser parse]; 	
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser 
{ 
	//NSLog(@"found file and started parsing"); 
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{ 
	NSString * errorString = [NSString stringWithFormat:@"Unable to download information from web site (Error code %li )", (long)[parseError code]]; 
	//NSLog(@"error parsing XML: %@", errorString); 
	UIAlertView * errorAlert = 
	[[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[errorAlert show]; 
	[tourDelegate parseErrorOccurred:parseError];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{ 
	//NSLog(@"found this element: %@", elementName); 
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"tour"]) {
		// init to get next element ...
		self.tour = [[TourData alloc] init];
	}
} 

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{ 
	//NSLog(@"ended element: %@", elementName); 
	if ([elementName isEqualToString:@"tour"]) 
	{ // save art to list of artwork
		[tours addObject:tour];
		// NSLog(@"adding tour: %@ %@", tour.name); 
	} 
} 

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{ 
	//NSLog(@"found characters: %@", string); 
	// save the characters for the current item... 
	
	NSMutableString* test = [NSMutableString stringWithCapacity:[string length]];
	[test appendString:string];
	[test replaceOccurrencesOfString:@"\t" withString:@"" options:NSLiteralSearch range:NSMakeRange (0,[test length])];
	[test replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange (0,[test length])];
	if ([test length] != 0) 
	{
		if ([currentElement isEqualToString:@"name"]) {
			[tour.name appendString:string];
		}
		else if ([currentElement isEqualToString:@"desc"]) {
			[tour.desc appendString:string]; 
		} 
		else if ([currentElement isEqualToString:@"ids"]) {
			[tour.ids appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]; 
		}
	}
} 


- (void)parserDidEndDocument:(NSXMLParser *)parser 
{ 
	//NSLog(@"Found %d items", [tours count]); 
	self.ready = TRUE;
	rssParser.delegate = nil;
	[tourDelegate didFinishParsing];
}

@end
