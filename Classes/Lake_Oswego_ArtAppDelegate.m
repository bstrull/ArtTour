//
//  Lake_Oswego_ArtAppDelegate.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lake_Oswego_ArtAppDelegate.h"
#import "RootViewController.h"
#import "ArtList.h"
#import "Artwork.h"
#import "TourListData.h"
#import "ArtLocation.h"

@implementation Lake_Oswego_ArtAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize rootViewController;
@synthesize artworks,tours;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    



    if ([navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
      [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3647 green:0.5922 blue:0.2 alpha:0.5]];
      [navigationController.navigationBar setTintColor:[UIColor whiteColor]];

      NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
      [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    }
    else
    {
      [navigationController.navigationBar
       performSelector:@selector(setTintColor:)
       withObject:[UIColor colorWithRed:0.3647 green:0.5922 blue:0.2 alpha:1.0] afterDelay:0.1];
    }
    // Add the navigation controller's view to the window and display.
    //[self.window addSubview:navigationController.view];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Override point for customization after application launch.
    // start downloading data
	tours = [[TourListData alloc] init:self];
    
    [self rateApp];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [rootViewController.locations stopLooking];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	
	if (artworks && artworks.ready)
	{
		for (Artwork* art in [artworks.works allValues]) {

			// release images 
			if (art.artImage) {
				art.artImage = nil;
			}
		}
	}
	
}

- (void)handleArtLoaded
{
	if (tours.ready && rootViewController.tours != tours)
	{
		rootViewController.tours = self.tours;
	}

	if (artworks == nil)
	{
		// start getting art;
		artworks = [[ArtList alloc] init:self];
		return;
	}
	else if (artworks.ready && rootViewController.artworks != artworks)
		rootViewController.artworks = self.artworks;
	
	if (tours.ready && artworks.ready)
	{
		// tell our table view to reload its data, now that parsing has completed
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[rootViewController.tableView reloadData];
	}
}

- (void)handleLoadFailed
{
	[rootViewController.message setString:@"Download failed. Click to try again."];
	[rootViewController.tableView reloadData];
}

// artwork delegates 

- (void)didFinishParsing
{
	[self performSelectorOnMainThread:@selector(handleArtLoaded) withObject:nil waitUntilDone:NO];
}

- (void)parseErrorOccurred:(NSError *)error
{
	[self performSelectorOnMainThread:@selector(handleLoadFailed) withObject:nil waitUntilDone:NO];
}






#pragma mark -

#pragma mark Rate App


- (void)rateApp {
    
    
    long launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchCount"];
    
    launchCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:@"launchCount"];
    
    BOOL neverRate = [[NSUserDefaults standardUserDefaults] boolForKey:@"neverRate"];
    
    
    if ((neverRate != YES) && (launchCount > 2)) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please rate L.O. Art Tour" message:@"Enjoying the tour?  Please write a review." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Rate now", @"Never ask again", @"Remind me later", nil];
        
        alert.delegate = self;
        
        [alert show];
        
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/l-o-art-tour/id425310949?mt=8"]];
        
    }
    
    else if (buttonIndex == 1) {
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
        
    }
    
    else if (buttonIndex == 2) {
        
   // Do nothing
        
    }
}

@end

