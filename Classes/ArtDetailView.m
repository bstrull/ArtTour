//
//  ArtDetailView.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/21/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "ArtDetailView.h"
#import "ArtMapView.h"
#import "Artwork.h"
#import "UIViewController+Helpers.h"
#import "SDWebImageManager.h"

@implementation ArtDetailView


@synthesize info, img, header, art, style, zoomed, mapButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];

    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
      self.edgesForExtendedLayout = UIRectEdgeNone;
    }

	header.delegate = self;
	
	
	style = @"<style type='text/css'>   \
	a {   \
	font-family:Geneva, Arial, Helvetica, sans-serif;  \
	color:#333333;  \
	text-decoration:none; \
	font-size:1em; \
	} \
	a:link {  \
	text-decoration:none; \
	color:#5D9731; \
	font-weight:bold; \
	font-size:1em; \
	} \
	a:visited { \
	text-decoration:none; \
	color:#DAA520;  \
	font-size:1em; \
	} \
	a:hover {  \
	text-decoration:none; \
	color:#333333;  \
	border-bottom-width:thin;  \
	border-bottom-style:dashed;  \
	border-bottom-color:#B8CC6E; \
	} \
	</style>";
	
	
	[self setTitle:art.title];
	
	if (art.artImage  == nil) {
		if ([art.imageLink hasPrefix:@"images"])	
		{
			[art.imageLink replaceOccurrencesOfString:@"images" withString:@"http://www.artscouncillo.org/tour/images" options:NSLiteralSearch range:NSMakeRange (0,6)];
		}
        else
        {
          [self cleanupUrl:art.imageLink];
        }

      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [manager downloadWithURL:[NSURL URLWithString:art.imageLink]
                       options:0
                      progress:^(NSInteger receivedSize, NSInteger expectedSize)
       {
         // progression tracking code
       }
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
       {
         if (image)
         {
           // do something with image
           art.artImage = image;
         }
         [self finishView];

       }];

      //NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:art.imageLink]];
	  //	art.artImage = [[UIImage alloc] initWithData:imageData];
      // [self finishView];
	}
    else
    {
      [self finishView];
    }
}

-(void) finishView
{
	[self.img setImage:art.artImage];
	
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
	[self.img addGestureRecognizer:doubleTap];
	
	zoomed = NO;
	
	[self fillHeader];
	[self fillInfo];
	
	// add map button	
	
	if (mapButton == YES)
	{
		UIButton* mapButtonUI = [UIButton buttonWithType:UIButtonTypeCustom];
		[mapButtonUI setImage:[UIImage imageNamed:@"maps.png"] forState:UIControlStateNormal];
		[mapButtonUI addTarget:self action:@selector(showMapView:) forControlEvents:UIControlEventTouchUpInside];
		[mapButtonUI setFrame:CGRectMake(0, 0, 32, 32)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButtonUI];	
	}

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
      self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self defaultBackButtonTitle];
}

- (void)cleanUp{
	

}

- (void) cleanupUrl:(NSMutableString *)url
{
  if ([url hasPrefix:@"www"])
  {
    [url replaceCharactersInRange:NSMakeRange(0, 3) withString:@"http://www"];
  }
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer 
{
	
	[UIView beginAnimations:@"" context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDidStopSelector:@selector(cleanUp)];

	CGRect frame;
	if (zoomed == YES) {
		 frame = self.img.frame;
		frame.size.height *= .5;
		frame.size.width *=.5;
		frame.origin.x -=10;
		frame.origin.y -=2;
		zoomed = NO;
		[header setAlpha:1.0];
		[info setAlpha:1.0];
		
	}
	else {
		 frame = self.img.frame;
		frame.size.height *= 2;
		frame.size.width *=2;
		frame.origin.x +=10;
		frame.origin.y +=2;
		zoomed = YES;
		[header setAlpha:0.0];
		[info setAlpha:0.0];
	}
	
	[self.view bringSubviewToFront:img];
	self.img.frame = frame;
	[UIView commitAnimations];
	
}


- (void) showMapView:(id)sender
{
	ArtMapView *mapViewController = [[ArtMapView alloc] initWithNibName:@"ArtMapView" bundle:nil];
    [mapViewController showArt:art];
	[self.navigationController pushViewController:mapViewController animated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



-(void) fillHeader
{
	NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1000];
	
	[html appendString:@"<html><head>"];
	[html appendString:style];
	[html appendString:@"</head><body>"];
	[html appendString:@"<div style='padding-top:0px;padding-left:0px;padding-right:5px;font-size:.875em;'>"];
	
	[html appendString:@"</td><td><ul style='margin-left: .75em;padding-left: .75em; margin-top:0px; margin-bottom:0px;padding-top:0px;'>"];
	[html appendString:@"<li><div style='font-size:1em;font-weight:bold;'>"];
	[html appendString:art.artistName];
	[html appendString:@"</div></li>"];
	[html appendString:@"<li><div style='font-style:italic;font-size:1em;'>"];
	[html appendString:art.title];
	[html appendString:@"</div></li>"];
	
	if ([art.materials length] > 0){
		[html appendString:@"<li>"];
		[html appendString:art.materials];
		[html appendString:@"</li>"];	
	}
	else if ([art.medium length] > 0) {
		[html appendString:@"<li>"];
		[html appendString:art.medium];
		[html appendString:@"</li>"];			
	}
	
	if ([art.artistWeb length] > 0) {
		[html appendString:@"<li><a target='_blank' href='"];
		[html appendString:art.artistWeb];
		[html appendString:@"'>artist&#39;s website</a></li>"];
	}
	
	if ([art.sponsor length] > 0) {
		[html appendString:@"<li>Sponsor:  "];
		if ([art.sponsorLink length] > 0){
			[html appendString:@"<a href="];
			[html appendString:art.sponsorLink];
			[html appendString:@" target='_blank'>"];
		}
		[html appendString:art.sponsor];
		if ([art.sponsorLink length] > 0){
			[html appendString:@"</a>"];
		}
		[html appendString:@"</li>"];
	}	
	
	
	[html appendString:@"</ul></td></tr></table>"];    
	
	[html appendString:@"</div></body></html>"];
	
	[header loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.artscouncillo.org/tour"]];  
}

-(void) fillInfo
{
	NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1000];
	
	[html appendString:@"<html><head>"];
	[html appendString:style];
	[html appendString:@"</head><body>"];
	[html appendString:@"<div style='padding-top:0px;padding-left:5px;padding-right:5px;font-size:.875em;'>"];
	
	if ([art.challenge length] > 0) {
		[html appendString:@"<p><b>Viewer&#39;s Challenge: </b>"];
		[html appendString:art.challenge];
		[html appendString:@"</p>"];
		
		
		if ([art.details length] > 0) {
			[html appendString:@"<p><b>Details: </b>"];
			[html appendString:art.details];
			[html appendString:@"</p>"];
		}	
		
		
		if ([art.element1 length] > 0)  {
			[html appendString:@"<p style='margin:0;padding-bottom:0px;'><b>Key Elements:</b></p>"];
			[html appendString:@"<ul style='margin-left: .75em;padding-left: .75em; margin-top:0px; margin-bottom:0px;padding-top:0px;'><li>"];
			[html appendString:art.element1];
			[html appendString:@"</li>"];
			
			if ([art.element2 length] > 1) {
				[html appendString:@"<li>"];
				[html appendString:art.element2];
				[html appendString:@"</li>"];
			}
			if ([art.element3 length] > 1) {
				[html appendString:@"<li>"];
				[html appendString:art.element3];
				[html appendString:@"</li>"];
			}
			[html appendString:@"</ul>"];
		}
		
		if ([art.story length] > 0) {
			[html appendString:@"<p><b>Story: </b>"];
			[html appendString:art.story];
			[html appendString:@"</p>"];
		}
		
		if ([art.style length] > 0) {
			[html appendString:@"<p><b>Style: </b>"];
			[html appendString:art.style];
			[html appendString:@"</p>"];
		}
        
        if ([art.misc length] > 0) {
			[html appendString:@"<p><b>"];
			[html appendString:art.misc];
			[html appendString:@"</b></p>"];
		}
	}
	else {
		[html appendString:art.description];
	}
	
	[html appendString:@"</div><p/></body></html>"];
	
	
	[info loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.artscouncillo.org/tour"]];  
	
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
	self.img = nil;
	self.header = nil;
	self.info = nil;	
}




-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {

	if (inType == UIWebViewNavigationTypeLinkClicked){
		[[UIApplication sharedApplication] openURL:[inRequest URL]];
		return NO;
	}
	else {
		return YES;
	}

}

@end
