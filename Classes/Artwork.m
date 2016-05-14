//
//  Artwork.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Artwork.h"


@implementation Artwork


@synthesize artid, title, artistName, artistWeb, description, imageLink, latlng,
	sponsor, sponsorLink, materials, medium, challenge, element1, element2, element3, details, 
	story, style, misc , lat,lng;
@synthesize artImage, artIcon;

- (id)init
{
	self = [super init];
	if (self) {
		/* class-specific initialization goes here */
		
		artid = [[NSMutableString alloc] init];
		title = [[NSMutableString alloc] init];
		artistName = [[NSMutableString alloc] init];
		artistWeb= [[NSMutableString alloc] init]; 
		description= [[NSMutableString alloc] init]; 
		imageLink= [[NSMutableString alloc] init];
		latlng= [[NSMutableString alloc] init];
		sponsor= [[NSMutableString alloc] init];
		sponsorLink= [[NSMutableString alloc] init]; 
		materials= [[NSMutableString alloc] init]; 
		medium = [[NSMutableString	alloc] init];
		challenge= [[NSMutableString alloc] init]; 
		element1= [[NSMutableString alloc] init]; 
		element2= [[NSMutableString alloc] init]; 
		element3= [[NSMutableString alloc] init]; 
		details= [[NSMutableString alloc] init]; 
		story= [[NSMutableString alloc] init]; 
		style = [[NSMutableString alloc] init]; 
        misc = [[NSMutableString alloc] init]; 
    
		lat = 0.0;
		lng = 0.0;
		
		artImage = nil;
		artIcon	 = nil;
		
	}
	return self;
}

-(void) parseLatLng
{
	if ([latlng length] > 0)
	{
		NSArray *chunks = [latlng componentsSeparatedByString: @","];
		lng = [[chunks objectAtIndex:0] floatValue];
		lat = [[chunks objectAtIndex:1] floatValue];

      // check that the values are reasonable
      if (lat < 0.0 && lng > 0.0)
      {
        // likely values were swapped
        float temp = lat;
        lat = lng;
        lng = temp;
      }
      else if (lng > 120.0)
      {
        // likely minus sign missing from lng
        lng = -lng;
      }
    }
}

-(double) getlng
{
	if (lng == 0.0)
	{
		[self parseLatLng];
	}
	return lng;
}


-(double) getlat
{
	if (lat == 0.0)
	{
		[self parseLatLng];
	}
	return lat;
}



@end

