//
//  Artwork.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Artwork : NSObject {
	
	NSMutableString *artid;
	NSMutableString *title;
	NSMutableString *artistName;
	NSMutableString *artistWeb;
	NSMutableString *description;
	NSMutableString *imageLink;
	NSMutableString *latlng;
	NSMutableString *sponsor;
	NSMutableString *sponsorLink;
	NSMutableString *materials;
	NSMutableString *medium;
	NSMutableString *challenge;
	NSMutableString *element1;
	NSMutableString *element2;
	NSMutableString *element3;
	NSMutableString *details;
	NSMutableString *story;
	NSMutableString *style;
    NSMutableString *misc;
	double lat;
	double lng;
	
	UIImage* artImage;
	UIImage* artIcon;

}

@property (nonatomic, strong) NSMutableString *artid;
@property (nonatomic, strong) NSMutableString *latlng;
@property (nonatomic, strong) NSMutableString *title;
@property (nonatomic, strong) NSMutableString *artistName;
@property (nonatomic, strong) NSMutableString *artistWeb;
@property (nonatomic, strong) NSMutableString *description;
@property (nonatomic, strong) NSMutableString *imageLink;
@property (nonatomic, strong) NSMutableString *sponsor;
@property (nonatomic, strong) NSMutableString *sponsorLink;
@property (nonatomic, strong) NSMutableString *materials;
@property (nonatomic, strong) NSMutableString *medium;
@property (nonatomic, strong) NSMutableString *challenge;
@property (nonatomic, strong) NSMutableString *element1;
@property (nonatomic, strong) NSMutableString *element2;
@property (nonatomic, strong) NSMutableString *element3;
@property (nonatomic, strong) NSMutableString *details;
@property (nonatomic, strong) NSMutableString *story;
@property (nonatomic, strong) NSMutableString *style;
@property (nonatomic, strong) NSMutableString *misc;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;

@property (strong) UIImage* artImage;
@property (strong) UIImage* artIcon;

// allocate the strings
- (id)init;

- (void) parseLatLng;
- (double) getlat;
- (double) getlng;

@end
