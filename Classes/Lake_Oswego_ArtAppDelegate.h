//
//  Lake_Oswego_ArtAppDelegate.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtList.h"

@class RootViewController;
@class TourListData;


@interface Lake_Oswego_ArtAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate, ParseOperationDelegate> {
    
    UIWindow *window;
    UINavigationController  *navigationController;
	RootViewController      *rootViewController;
	
	TourListData *tours;
	ArtList *artworks;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet RootViewController *rootViewController;

@property (nonatomic, strong) ArtList *artworks;
@property (nonatomic, strong) TourListData *tours;


- (void)rateApp;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

