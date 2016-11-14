//
//  ArtList.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/16/11.
//  Copyright 2011 Brian Strull. All rights reserved.
//

#import "ArtList.h"
#import "Artwork.h"

@implementation ArtList

@synthesize works, rssParser,art, currentElement, ready, artDelegate;



- (id) init:(id <ParseOperationDelegate>)theDelegate
{
	self = [super init];
	if (self) {
		ready = FALSE;
		artDelegate = theDelegate;
		works = [[NSMutableDictionary alloc] initWithCapacity:75];
		
		art = [[Artwork alloc] init];
		
		// load works from xml
      NSString* path = [[NSBundle mainBundle] pathForResource:@"GWWData" ofType:@"xml"];
        // @"http://192.168.0.16/lofa.org/tour/data/GWWData.xml";
        // @"http://www.artscouncillo.org/tour/data/GWWData.xml";
		[self parseXMLFileAtURL:path];
	}
	return self;
}

- (Artwork*) findArt:(NSString*)workid
{
	if (works) {
		return [works objectForKey:workid];
	}
	else {
		return NULL;
	}
}


	
- (void)parseXMLFileAtURL:(NSString *)URL
{ 
	//you must then convert the path to a proper NSURL or it won't work 
	// NSURL *xmlURL = [NSURL URLWithString:URL];
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, 
	// otherwise you will get an object not found error 
	// this may be necessary only for the toolchain 
	//rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];

    rssParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:URL]];

    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self]; 
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser. 
	[rssParser setShouldProcessNamespaces:NO]; 
	[rssParser setShouldReportNamespacePrefixes:NO]; 
	[rssParser setShouldResolveExternalEntities:NO]; 
	[rssParser parse]; 	
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser 
{ 
	// NSLog(@"found file and started parsing"); 
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{ 
	NSString * errorString = [NSString stringWithFormat:@"Unable to download information from web site (Error code %li )", (long)[parseError code]]; 
	//NSLog(@"error parsing XML: %@", errorString); 
	UIAlertView * errorAlert = 
		[[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[errorAlert show]; 
	[artDelegate parseErrorOccurred:parseError];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{ 
	//NSLog(@"found this element: %@", elementName); 
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"PhoneData"]) {
		// clear out our artwork ...
		art = [[Artwork alloc] init];
	}
}

-(void)cleanupImageLink:(NSMutableString *)url
{
  if ([url hasPrefix:@"images"])
  {
    [url replaceOccurrencesOfString:@"images" withString:@"http://www.artscouncillo.org/tour/images" options:NSLiteralSearch range:NSMakeRange (0,6)];
  }
  [self cleanupLink:url];
}


-(void)cleanupLink:(NSMutableString *)url
{
  if ([url hasPrefix:@"#"])
  {
    [url replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
  }
  NSRange hashRange = [url rangeOfString:@"#" options:NSCaseInsensitiveSearch];
  if (hashRange.location != NSNotFound)
  {
    [url setString:[url substringToIndex:hashRange.location]];
  }

  if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])
  {
    [url setString:[NSString stringWithFormat:@"http://%@", url]];
  }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{ 
	//NSLog(@"ended element: %@", elementName); 
	if ([elementName isEqualToString:@"PhoneData"]) 
	{ // save art to list of artwork
		[works setObject:art forKey:art.artid];
		//NSLog(@"adding story: %@ %@", art.title, art.artid); 
	}
    else if ([elementName isEqualToString:@"SponsorLink"])
    {
      [self cleanupLink:art.sponsorLink];
    }
    else if ([elementName isEqualToString:@"ArtistWeb"])
    {
      [self cleanupLink:art.artistWeb];
    }
    else if ([elementName isEqualToString:@"ImageLink"])
    {
      [self cleanupImageLink:art.imageLink];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{ 
	//NSLog(@"found characters: %@", string); 
	// save the characters for the current item... 
	
	NSMutableString* test = [[NSMutableString alloc] initWithCapacity:[string length]];
	[test appendString:string];
	[test replaceOccurrencesOfString:@"\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange (0,[test length])];
    [test replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange (0,[test length])];

    if ([test length] == 0)
	{	
		return;
	}
	else {
	}
		
	if ([currentElement isEqualToString:@"ID"]) {
		[art.artid appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
	else if ([currentElement isEqualToString:@"Title"]) {
		[art.title appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"ArtistName"]) {
		[art.artistName appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"ArtistWeb"]) {
		[art.artistWeb appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	} 
	else if ([currentElement isEqualToString:@"Description"]) {
		[art.description appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"ImageLink"]) {
		[art.imageLink appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	} 
	else if ([currentElement isEqualToString:@"LatLng"]) {
		[art.latlng appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Sponsor"]) {
		[art.sponsor appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"SponsorLink"]) {
		[art.sponsorLink appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	} 
	else if ([currentElement isEqualToString:@"Materials"]) {
		[art.materials appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Medium"]) {
		[art.medium appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Challenge"]) {
		[art.challenge appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Elements1"]) {
		[art.element1 appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Elements2"]) {
		[art.element2 appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Elements3"]) {
		[art.element3 appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Details"]) {
		[art.details appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Story"]) {
		[art.story appendString:string]; 
	} 
	else if ([currentElement isEqualToString:@"Style2"]) {
		[art.style appendString:string]; 
	} 	
    else if ([currentElement isEqualToString:@"Misc"]) {
		[art.misc appendString:string]; 
	} 	
} 


- (void)parserDidEndDocument:(NSXMLParser *)parser 
{ 
	ready = TRUE;
	rssParser.delegate = nil;
	
	// NSLog(@"Found %d items", [works count]); 
	[artDelegate didFinishParsing];
}

@end
