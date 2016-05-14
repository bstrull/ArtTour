//
//  AboutView.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/2/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "AboutView.h"
#import "UIViewController+Helpers.h"

@implementation AboutView

@synthesize info;

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

	info.delegate = self;
	
    [super viewDidLoad];
	self.title = @"About";
  
	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"htm"];
    if (thePath) {
        NSData *theData = [[NSData alloc]  initWithContentsOfFile:thePath];
        [self.info loadData:theData MIMEType:@"text/html"
					textEncodingName:@"utf-8" 
					baseURL:nil];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:YES];
  [self defaultBackButtonTitle];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if([error code] == NSURLErrorCancelled) return;
	
    // load error, hide the activity indicator in the status bar
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.info loadHTMLString:errorString baseURL:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
