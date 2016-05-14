//
//  RootViewController.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TourListData;
@class ArtList;
@class ArtLocation;

@interface RootViewController : UITableViewController {

	TourListData *tours;
	NSMutableArray *otherList;
	ArtList *artworks;
	ArtLocation *locations;
	NSMutableString *message;
}

@property (nonatomic, strong) NSMutableArray *otherList;
@property (nonatomic, strong) ArtList *artworks;
@property (nonatomic, strong) ArtLocation *locations;
@property (nonatomic, strong) TourListData *tours;
@property (nonatomic, strong) NSMutableString *message;



@end
