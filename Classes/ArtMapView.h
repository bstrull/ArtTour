//
//  ArtMapView.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/22/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class Artwork;
@class artAnnotation;

@interface ArtMapView : UIViewController <MKMapViewDelegate> 

@property (nonatomic,strong) IBOutlet MKMapView *artmap;
@property (nonatomic,strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSArray *artworkToDisplay;
@property (nonatomic) BOOL setupCompleted;

-(void) showArt:(Artwork*) art;
-(void) showArtList:(NSArray*) arts;
-(void) showArtNearMe:(NSArray*) arts nearby:(Artwork*)nearby;


@end
