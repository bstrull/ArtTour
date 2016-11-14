//
//  ArtLocation.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/27/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Artwork;
@class ArtList;

@interface ArtLocation : NSObject <CLLocationManagerDelegate> {
	
	CLLocationManager *locManager;
	CLLocation *myLocation;

}

@property (nonatomic, strong) 	CLLocationManager *locManager;
@property (nonatomic, strong) CLLocation *myLocation;

-(void) prepareToLook;
-(void) resumeLooking;
-(void) stopLooking;
-(Artwork*) findClosest:(ArtList*) works;

+(CLLocation*) currentLocation;

@end
