//
//  ArtMapView.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/22/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "ArtMapView.h"
#import "Artwork.h"
#import "artAnnotation.h"
#import "ArtDetailView.h"
#import "ArtLocation.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Helpers.h"

@implementation ArtMapView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    self.viewLoaded = NO;
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotations = [[NSMutableArray alloc] initWithCapacity:60];
	self.artmap.delegate = self;
	[self setTitle:@"Map"];
}

-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:YES];
  [self defaultBackButtonTitle];
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if (!self.viewLoaded) {
    self.viewLoaded = YES;
    if ([self.artworkToDisplay count] == 1)
        [self doShowArt:[self.artworkToDisplay objectAtIndex:0]];
    else if ([self.artworkToDisplay count] > 1)
      [self doShowArtList:self.artworkToDisplay];
  }
}


 - (void)viewDidDisappear:(BOOL)animated {

	 for (artAnnotation* art in self.annotations)
		 [self.artmap deselectAnnotation:art animated:YES];
	 [super viewDidDisappear:animated];
 }


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(void) showArt:(Artwork*)art
{
  self.artworkToDisplay = [NSArray arrayWithObject:art];
}

-(void) doShowArt:(Artwork*)art
{
    artAnnotation* theAnnotation = [artAnnotation alloc];
	CLLocationCoordinate2D location;
	location.latitude = [art getlat];
	location.longitude = [art getlng];
	
	theAnnotation._coordinate = location;
	theAnnotation.art = art;
	[self.artmap addAnnotation:theAnnotation];
	
	[self.annotations insertObject:theAnnotation atIndex:0];
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.05;
	span.longitudeDelta=0.05;
	region.span=span;
	region.center=location;
	
	[self.artmap setRegion:region animated:TRUE];
	[self.artmap regionThatFits:region];
	
}

-(void) showArtList:(NSArray*) arts
{
  self.artworkToDisplay = [NSArray arrayWithArray:arts];
}


-(void) doShowArtList:(NSArray*) arts
{
    CLLocationCoordinate2D location;
	CLLocationDegrees minLat = 180.0;
	CLLocationDegrees minLng = 180.0;
	CLLocationDegrees maxLat = -180.0;
	CLLocationDegrees maxLng = - 180.0;
	artAnnotation* theAnnotation;
	
	int i =0;
	
	for (Artwork *art in arts) {

		location.latitude = [art getlat];
		location.longitude = [art getlng];
	
		if (location.latitude < minLat) minLat = location.latitude;
		if (location.latitude > maxLat) maxLat = location.latitude;
		if (location.longitude < minLng) minLng = location.longitude;
		if (location.longitude > maxLng) maxLng = location.longitude;
		
		theAnnotation = [artAnnotation alloc];
	
		theAnnotation._coordinate = location;
		theAnnotation.art = art;
		[self.artmap addAnnotation:theAnnotation];
		
		[self.annotations insertObject:theAnnotation atIndex:i];
		i++;
	}
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta= 1.15*(maxLat - minLat);
	span.longitudeDelta= 1.15*(maxLng - minLng);
	region.span=span;
	region.center.latitude = minLat + (maxLat - minLat)/2;
	region.center.longitude = minLng + (maxLng - minLng)/2;
	
	[self.artmap setRegion:region animated:TRUE];
	[self.artmap regionThatFits:region];
	
}

-(void) showArtNearMe:(NSArray*) arts nearby:(Artwork*)nearby
{
    CLLocationCoordinate2D location;
	CLLocationCoordinate2D mylocation;
	
  /*  MKUserLocation *userLoc = [artmap userLocation];
    if (userLoc != nil && userLoc.location != nil && userLoc.location.verticalAccuracy >= 0 && userLoc.location.horizontalAccuracy >= 0
        && userLoc.location.horizontalAccuracy < [ArtLocation currentLocation].horizontalAccuracy)
        mylocation = userLoc.location.coordinate;
    else
   */
   mylocation = [ArtLocation currentLocation].coordinate;
    
	location.latitude = [nearby getlat];
    location.longitude = [nearby getlng];
    
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta= fabs(mylocation.latitude - location.latitude)*2 + 0.001;
	span.longitudeDelta= fabs(mylocation.longitude - location.longitude)*2 + 0.001;
	region.span=span;
    region.center = mylocation;
    
    artAnnotation* theAnnotation;
	int i =0;
    int nearest=0;
	
	for (Artwork *art in arts) {
        
		location.latitude = [art getlat];
		location.longitude = [art getlng];
 		
		theAnnotation = [artAnnotation alloc];
        
		theAnnotation._coordinate = location;
		theAnnotation.art = art;
		[self.artmap addAnnotation:theAnnotation];
		
		[self.annotations insertObject:theAnnotation atIndex:i];
		if (art == nearby)
            nearest = i;
        
        i++;
	}
	
    [self.artmap setRegion:region animated:TRUE];
	[self.artmap regionThatFits:region];
    [self.artmap selectAnnotation:[self.annotations objectAtIndex:nearest] animated:FALSE];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	self.artmap.showsUserLocation = false;
	self.artmap.delegate = nil;
	[[self.artmap layer] removeAllAnimations];
  self.artworkToDisplay = nil;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	[self.artmap deselectAnnotation:view.annotation animated:YES];
	if (control.tag != 1) {
		// show walking directions     [NSString stringWithFormat:@"%f",doubleVariable];
		
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Use ios6 class
            MKPlacemark *destPlacemark = [[MKPlacemark alloc] initWithCoordinate:((artAnnotation*) view.annotation).coordinate addressDictionary:nil];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destPlacemark];
            
            NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
            [launchOptions setObject:MKLaunchOptionsDirectionsModeWalking forKey:MKLaunchOptionsDirectionsModeKey];
            [destination openInMapsWithLaunchOptions:launchOptions];
        }
        else
        {
            NSMutableString *url = [[NSMutableString alloc] init];
            [url appendString:@"http://maps.google.com/maps?saddr="];
            [url appendString:[NSString stringWithFormat:@"%f",self.artmap.userLocation.location.coordinate.latitude]];
            [url appendString:@","];
            [url appendString:[NSString stringWithFormat:@"%f",self.artmap.userLocation.location.coordinate.longitude]];
            [url appendString:@"&daddr="];
            [url appendString:[NSString stringWithFormat:@"%f",[((artAnnotation*) view.annotation).art getlat]]];
            [url appendString:@","];	
            [url appendString:[NSString stringWithFormat:@"%f",[((artAnnotation*) view.annotation).art getlng]]];
            [url appendString:@"&dirflg=w"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	
        }
	}
	else if ([self.annotations count] == 1) {
		[self.navigationController popViewControllerAnimated:YES];
	}	
	else {
		ArtDetailView *detailViewController = [[ArtDetailView alloc] initWithNibName:@"ArtDetailView" bundle:nil];
		detailViewController.art = ((artAnnotation*) view.annotation).art;		
		detailViewController.mapButton = NO;
		// ...
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:detailViewController animated:YES];
		
	}

		
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	// if it's the user location, just return nil.
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
	
	// handle our custom annotation
	//
	if ([annotation isKindOfClass:[artAnnotation class]]) 
	{		
		// try to dequeue an existing pin view first
		static NSString* artAnnotationIdentifier = @"artAnnotationIdentifier";
		MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[self.artmap dequeueReusableAnnotationViewWithIdentifier:artAnnotationIdentifier];
		if (!pinView)
		{
			// if an existing pin view was not available, create one
			MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:artAnnotationIdentifier];
			customPinView.pinColor = MKPinAnnotationColorPurple;
			customPinView.animatesDrop = YES;
			customPinView.canShowCallout = YES;
			
			// add a detail disclosure button to the callout which will open a new view controller page
			//
			// note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
			//  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
			//
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[rightButton setTag:1];
			customPinView.rightCalloutAccessoryView = rightButton;
			
			//UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
			//[leftButton setImage:[UIImage imageNamed:@"walk.png"] forState:UIControlStateNormal + UIControlStateHighlighted];
			//customPinView.leftCalloutAccessoryView = leftButton;
			
			UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walk.png"]];
			leftIconView.userInteractionEnabled = YES;
			UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:annotation action:@selector(handleTap:)];
			[singleTap setNumberOfTapsRequired:1];
			[leftIconView addGestureRecognizer:singleTap];
			customPinView.leftCalloutAccessoryView = leftIconView;
						
			//UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
			//[leftButton setTag:2];
			//customPinView.leftCalloutAccessoryView = leftButton;
			
			// show art image
			/*
			UIImage *img = [UIImage 
							imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theAnnotation.art.imageLink]]];
			UIImageView* imgview = [[UIImageView alloc] initWithImage:img];
			
			
			//set contentMode to scale aspect to fit
			imgview.contentMode = UIViewContentModeScaleAspectFit;
			
			//change width of frame
			CGRect frame = imgview.frame;
			frame.size.height = 32;
			imgview.frame = frame;
											
			customPinView.leftCalloutAccessoryView = imgview;
			*/
			
			return customPinView;
		}
		else
		{
			pinView.annotation = annotation;
			return pinView;
		}
	}
	return nil;
}


@end
