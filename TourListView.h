//
//  TourListView.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 1/25/11.
//  Copyright 2011 Brian Strull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@class ArtList;
@class Artwork;

@interface TourListView : UITableViewController /*<ImageDownloaderDelegate>*/ {

	ArtList* artdata;
	NSArray *tourids;
	NSMutableString *intro;
	NSMutableDictionary *imageDownloadsInProgress;  // the set of ImageDownloader objects for each app
	BOOL reappearing;

}

@property (nonatomic, strong) ArtList* artdata;
@property (nonatomic, strong) NSArray* tourids;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSMutableString *intro;
@property (nonatomic, strong) NSArray *sortedArt;

- (void) tourList:(ArtList*)data ids:(NSArray*)ids desc:(NSString*)desc;
- (void) showMapView:(id)sender;

@end
