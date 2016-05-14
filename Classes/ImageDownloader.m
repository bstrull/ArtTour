//
//  ImageLoader.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/1/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import "ImageDownloader.h"
#import "Artwork.h"

#define kArtIconHeight 90
#define kArtIconWidth 60

@implementation ImageDownloader

@synthesize artRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)dealloc
{
    
    
    [imageConnection cancel];
    
}

- (void)startDownload
{
	if ([artRecord.imageLink hasPrefix:@"images"])	
	{
		[artRecord.imageLink replaceOccurrencesOfString:@"images" withString:@"http://www.artscouncillo.org/tour/images" options:NSLiteralSearch range:NSMakeRange (0,6)];
	}
	
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
							 [NSURL URLWithString:artRecord.imageLink]] delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
	self.artRecord.artImage = image;
	
    if (image.size.width != kArtIconWidth && image.size.height != kArtIconHeight)
	{
        CGSize itemSize = CGSizeMake(kArtIconWidth, kArtIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.artRecord.artIcon = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.artRecord.artIcon = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
}

@end


