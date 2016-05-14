//
//  TourListView.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 1/25/11.
//  Copyright 2011 Brian Strull. All rights reserved.
//

#import "TourListView.h"
#import "ArtList.h"
#import "Artwork.h"
#import "ArtDetailView.h"
#import "ArtMapView.h"
#import "ImageDownloader.h"
#import "UIViewController+Helpers.h"
#import "UIImageView+WebCache.h"
#import "FixedSizedImageCell.h"

@implementation TourListView


@synthesize artdata, tourids, intro, sortedArt;
@synthesize imageDownloadsInProgress;

#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
 	
    [super viewDidLoad];
    [self defaultBackButtonTitle];

	// add map button	
	UIButton* mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mapButton setImage:[UIImage imageNamed:@"maps.png"] forState:UIControlStateNormal];
	[mapButton addTarget:self action:@selector(showMapView:) forControlEvents:UIControlEventTouchUpInside];
	[mapButton setFrame:CGRectMake(0, 0, 32, 32)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];	
	//[mapButton release];
	// reported as leak but crashes if released?
	
	// download storage
	imageDownloadsInProgress = [[NSMutableDictionary alloc] initWithCapacity:10];
	reappearing = false;
	// check for leaks
}


- (void) showMapView:(id)sender
{
	ArtMapView *mapViewController = [[ArtMapView alloc] initWithNibName:@"ArtMapView" bundle:nil];
  [mapViewController showArtList:self.sortedArt];

	[self.navigationController pushViewController:mapViewController animated:YES];
 }






- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	// resume loading icon images if needed
	if (reappearing) {
	//	[self loadImagesForOnscreenRows];
		reappearing = false;
	}
}



- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
	
	// terminate all pending download connections
 /*   NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
	
    [super viewWillDisappear:animated];
	[imageDownloadsInProgress removeAllObjects];
	reappearing = true;
  */
}



-(void) tourList:(ArtList*)data ids:(NSMutableArray*)ids desc:(NSMutableString*) desc
{
	self.artdata = data;
	self.tourids = ids;
	self.intro = desc;

  // sort the art
  NSMutableArray *unsortedArt = [[NSMutableArray alloc] initWithCapacity:[ids count]];
  for (NSString *id in ids)
  {
    Artwork *art = [self.artdata findArt:id];
    if (art)
      [unsortedArt addObject:art];
  }
  self.sortedArt = [unsortedArt sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    Artwork *first = obj1;
    Artwork *second = obj2;
    return [first.title localizedCaseInsensitiveCompare:second.title];
  }];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0)
		return 1;
	else 
		return [self.sortedArt count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0)
	{
		if (intro)
			// very roughly 50 chars per line * 20 pixels per line
			return 50 + ([intro length]/50)*20;
		else
			return 105.0;
	}
	else
	{
		return 90.0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0)
	{
		static NSString *CellIdentifier = @"Intro";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		// tour intro
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.font = [UIFont systemFontOfSize:13.0];
		[[cell textLabel]setText:intro];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	else {
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[FixedSizedImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
		
		
		Artwork* art = [sortedArt objectAtIndex:indexPath.row];
		[[cell textLabel]setText:art.artistName];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
		[[cell detailTextLabel]setText:art.title];
		
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;

		// Only load cached images; defer new downloads until scrolling ends
		if (!art.artIcon)
		{
          __weak UITableViewCell *weakCell = cell;
          [cell.imageView setImageWithURL:[NSURL URLWithString:art.imageLink]
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]
           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
             [weakCell layoutSubviews];
           }];

          /*
			if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
			{
				[self startImageDownload:art forIndexPath:indexPath];
			}
			// if a download is deferred or in progress, return a placeholder image
			cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];    
           */
		}
		else
		{
          cell.imageView.image = art.artIcon;
		}

		return cell;
	}
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
    // Navigation logic may go here. Create and push another view controller.
    
	if (indexPath.section == 1)
	{
		ArtDetailView *detailViewController = [[ArtDetailView alloc] initWithNibName:@"ArtDetailView" bundle:nil];
		Artwork* art = [self.sortedArt objectAtIndex:indexPath.row];
		detailViewController.art = art;
		detailViewController.mapButton = YES;
		
		// ...
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:detailViewController animated:YES];
		
	}
}

#pragma mark -
#pragma mark Table cell image support

/*
- (void)startImageDownload:(Artwork *)artRecord forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.artRecord = artRecord;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.artdata.works count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
			if (indexPath.section == 1)
			{
				Artwork* artRecord = [artdata findArt:[tourids objectAtIndex:indexPath.row]];
				
				if (!artRecord.artIcon) // avoid the app icon download if the app already has an icon
				{
					[self startImageDownload:artRecord forIndexPath:indexPath];
				}
			}
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = imageDownloader.artRecord.artIcon;
    }
}
*/

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

/*
// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
*/


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	
	// terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
	
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

