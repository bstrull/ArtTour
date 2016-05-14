//
//  RootViewController.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 1/25/11.
//  Copyright 2011 Brian Strull. All rights reserved.
//

#import "RootViewController.h"
#import "TourListView.h"
#import "ArtDetailView.h"
#import "ArtList.h"
#import "ArtMapView.h"
#import "ArtLocation.h"
#import "TourListData.h"
#import "TourData.h"
#import "AboutView.h"
#import "Lake_Oswego_ArtAppDelegate.h"
#import "UIViewController+Helpers.h"

@implementation RootViewController

@synthesize otherList, artworks, locations, tours, message;

#pragma mark -
#pragma mark View lifecycle


- (void) showAbout:(id)sender
{
	AboutView *aboutController = [[AboutView alloc] initWithNibName:@"AboutView" bundle:nil];
	[self.navigationController pushViewController:aboutController animated:YES];
}


- (void)viewDidLoad {
	
	message = [[NSMutableString alloc] initWithString:@"Loading Tour Information"];
	
	// add info button	
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(showAbout:) forControlEvents:UIControlEventTouchUpInside];
	//[infoButton setFrame:CGRectMake(0, 0, 32, 32)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];	

	otherList = [[NSMutableArray alloc] initWithObjects: 
					 @"Find Closest Art", @"Show All Art", @"Arts Council of Lake Oswego", nil]; 
	
	locations = [[ArtLocation alloc] init];
	[locations startLooking];
	
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
				

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {

    [locations restartLooking];
	[super viewDidAppear:animated];
    [self defaultBackButtonTitle];

}


- (void)viewWillDisappear:(BOOL)animated {

	[locations stopLooking];
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {

	[super viewDidDisappear:animated];
}


/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 0) {
		if (tours && tours.ready)
			return [tours.tours count];
		else
			return 1;
	}
	else {
		return [otherList count];
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    
	// Configure the cell.
	if (indexPath.section == 0)
	{
		if (tours && tours.ready) {
			TourData* td = [tours.tours objectAtIndex:indexPath.row];
			[[cell textLabel]setText: td.name];
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			[cell.imageView setImage:nil];
		}
		else {
			[[cell textLabel]setText:message];
			if ([message isEqualToString:@"Loading Tour Information"])
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			else
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
		}
	}
	else {		
		if (indexPath.row == 0  && artworks.ready)
		{
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			[[cell textLabel]setText: [otherList objectAtIndex:indexPath.row]];
			[cell.imageView	setImage:[UIImage imageWithContentsOfFile:
									  [[NSBundle mainBundle] pathForResource:@"icon_search" ofType:@"png"]]];			
		}
		else if (indexPath.row == 1 && artworks.ready)
		{
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			[[cell textLabel]setText: [otherList objectAtIndex:indexPath.row]];
			[cell.imageView	setImage:[UIImage imageWithContentsOfFile:
										  [[NSBundle mainBundle] pathForResource:@"maps" ofType:@"png"]]];
		}
		else if (indexPath.row == 2)	
		{
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			[[cell textLabel]setText: [otherList objectAtIndex:indexPath.row]];
			[cell.imageView	setImage:[UIImage imageWithContentsOfFile:
									  [[NSBundle mainBundle] pathForResource:@"icon-small" ofType:@"png"]]];
		}
	}

	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (tours && tours.ready && artworks && artworks.ready)
	{
		if (indexPath.section == 0)
		{
			TourData* td = [tours.tours objectAtIndex:indexPath.row];
			NSArray *listItems = [td.ids componentsSeparatedByString:@","];
			TourListView *tourListViewController = [[TourListView alloc] initWithNibName:@"TourListView" bundle:nil];
			[tourListViewController tourList:artworks ids:listItems	desc:td.desc];
			
			// ...
			// Pass the selected object to the new view controller.
			[self.navigationController pushViewController:tourListViewController animated:YES];
			tourListViewController.title = td.name;
		}
		else
		{
			// handle 2nd section links
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			
			if (indexPath.row == 0)
			{
				Artwork* closest = nil;
				if (locations != nil)
					closest = [locations findClosest:artworks];
				
				// find closest art	
				if (closest == nil)
				{
					UIAlertView * errorAlert = 
					[[UIAlertView alloc] initWithTitle:@"Location not available" message:@"Location services not enabled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
					[errorAlert show]; 
				}
				else {
                    /*
					ArtDetailView *detailViewController = [[ArtDetailView alloc] initWithNibName:@"ArtDetailView" bundle:nil];
					detailViewController.art = closest;
					detailViewController.mapButton = YES;
					[self.navigationController pushViewController:detailViewController animated:YES];
					[detailViewController release];
                     */
                    ArtMapView *mapViewController = [[ArtMapView alloc] initWithNibName:@"ArtMapView" bundle:nil];
                    [self.navigationController pushViewController:mapViewController animated:YES];

                    dispatch_async(dispatch_get_main_queue(), ^{
                      [mapViewController showArtNearMe:[artworks.works allValues] nearby:closest];
                  });
				}
			}
			else if (indexPath.row == 1)
			{
				// show all art				
				ArtMapView *mapViewController = [[ArtMapView alloc] initWithNibName:@"ArtMapView" bundle:nil];
                [mapViewController showArtList:[artworks.works allValues]];
 				[self.navigationController pushViewController:mapViewController animated:YES];
			}
			else 
			{		
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.artscouncillo.org"]];
			}
		}
	}
	else {
		// no data loaded, this link might still work
		if (indexPath.section == 0) {
			id<UIApplicationDelegate> me = [UIApplication sharedApplication].delegate;
			[((Lake_Oswego_ArtAppDelegate*) me).tours retry];
		}
		else if(indexPath.section == 1 && indexPath.row == 2)
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.artscouncillo.org"]];
		}
		
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	if (locations) [locations stopLooking];
	
}


@end

