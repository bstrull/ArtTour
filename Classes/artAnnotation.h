//
//  artAnnotation.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/23/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class Artwork;

@interface artAnnotation : NSObject <MKAnnotation> {

	Artwork* art;
	CLLocationCoordinate2D _coordinate;
	
	
}

@property (nonatomic) CLLocationCoordinate2D _coordinate;
@property (nonatomic, strong) Artwork* art;

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
