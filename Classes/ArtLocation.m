//
//  ArtLocation.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/27/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "ArtLocation.h"
#import "ArtList.h"
#import	"Artwork.h"

CLLocation* currentLoc = nil;

@implementation ArtLocation

@synthesize locManager, myLocation;


-(void) startLooking
{
	self.myLocation = nil;
	currentLoc = nil;
	locManager = [[CLLocationManager alloc] init];
	locManager.delegate = self;
	locManager.desiredAccuracy = kCLLocationAccuracyBest;
	locManager.distanceFilter = 20;
	[locManager startUpdatingLocation];
	
	[self performSelector:@selector(stopLooking) withObject:nil  afterDelay:60.0];
}

-(void) resumeLooking
{
    
    // authorizationStatus - check version support?  crash on 4.1?
	if (locManager && [CLLocationManager locationServicesEnabled])
    {    
        if (![CLLocationManager respondsToSelector:@selector(authorizationStatus)] ||
             [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
		[locManager startUpdatingLocation];
		[self performSelector:@selector(stopLooking) withObject:nil  afterDelay:60.0];
        }
    }
}	

-(void) restartLooking
{
    self.myLocation = nil;
    [self resumeLooking];
}

-(void) stopLooking
{
	if (locManager)
		[locManager stopUpdatingLocation];
}	




-(Artwork*) findClosest:(ArtList*) works
{
	if (myLocation == nil)
		return nil;
	
	CLLocationDistance best = 100000000.0;
	
	CLLocation* artLoc;
	CLLocationDistance next;
	Artwork* close = nil;
	
	for (Artwork* art in [works.works allValues])
	{
		artLoc = [[CLLocation alloc] initWithLatitude:[art getlat] longitude:[art getlng]];
		
		next =  [artLoc distanceFromLocation:myLocation];
		if (next < best)
		{
			best = next;
			close = art;
		}
	}
	
	return close;
}
	

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	// test the age of the location measurement to determine if the measurement is cached
	// in most cases you will not want to rely on cached measurements
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];

	if (locationAge > 5.0) return;

	// test that the horizontal accuracy does not indicate an invalid measurement
	if (newLocation.horizontalAccuracy < 0) return;

	// test the measurement to see if it is more accurate than the previous measurement
	if (myLocation == nil || myLocation.horizontalAccuracy >= newLocation.horizontalAccuracy 
        || newLocation.horizontalAccuracy <= locManager.desiredAccuracy) {
		// store the location as the "best effort"
		self.myLocation = newLocation;
		currentLoc = newLocation;
//		[currentLoc retain];
	
		// test the measurement to see if it meets the desired accuracy
		//
		// IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
		// accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
		// acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
		//
		if (newLocation.horizontalAccuracy <= locManager.desiredAccuracy) {
			// we have a measurement that meets our requirements, so we can stop updating the location
			// 
			// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
			//
			[self stopLooking];
		
			// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopLooking) object:nil];
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// NSLog (@"Unable to get your location.");
	if (kCLErrorDenied == error.code)
	{
		locManager.delegate = nil;
		locManager = nil;
	}
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopLooking) object:nil];

	if (locManager) [locManager stopUpdatingLocation];
//	[currentLoc release];
	currentLoc = nil;
	
}

+(CLLocation*) currentLocation
{
	return currentLoc;
}

@end
