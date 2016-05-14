//
//  artAnnotation.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/23/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "artAnnotation.h"
#import "Artwork.h"
#import "ArtLocation.h"
#import <MapKit/MapKit.h>

@implementation artAnnotation

@synthesize _coordinate,art;

- (CLLocationCoordinate2D)coordinate;
{
    return _coordinate; 
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return art.artistName;
}

// optional
- (NSString *)subtitle
{
    return art.title;
}


- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer 
{
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Use ios6 class
        CLLocationCoordinate2D location;
        location.latitude = [art getlat];
        location.longitude = [art getlng];
        MKPlacemark *destPlacemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destPlacemark];
        
        NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
        [launchOptions setObject:MKLaunchOptionsDirectionsModeWalking forKey:MKLaunchOptionsDirectionsModeKey];
        [destination openInMapsWithLaunchOptions:launchOptions];
    }
    else
    {
        NSMutableString *url = [[NSMutableString alloc] init];
        [url appendString:@"http://maps.google.com/maps?"];
         
        if ([ArtLocation currentLocation] != nil)
        {
            [url appendString:@"saddr="];
            [url appendString:[NSString stringWithFormat:@"%f",[ArtLocation currentLocation].coordinate.latitude]];
            [url appendString:@","];
            [url appendString:[NSString stringWithFormat:@"%f",[ArtLocation currentLocation].coordinate.longitude]];
            [url appendString:@"&"];
        }
        
        [url appendString:@"daddr="];
        [url appendString:[NSString stringWithFormat:@"%f",[art getlat]]];
        [url appendString:@","];	
        [url appendString:[NSString stringWithFormat:@"%f",[art getlng]]];
        [url appendString:@"&dirflg=w"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	
	}
	UIView* aView = gestureRecognizer.view;
	while (aView != nil && [aView isKindOfClass:[MKMapView class]] == 0){
		aView = aView.superview;
	}
	
	if (aView)
	{
		MKMapView *mView = (MKMapView*) aView;
		for (id currentAnnotation in [mView annotations]) {        
				[mView deselectAnnotation:currentAnnotation animated:YES];
		}
	}
}


@end
