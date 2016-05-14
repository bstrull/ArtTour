//
//  ArtDetailView.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 2/21/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artwork;

@interface ArtDetailView : UIViewController <UIWebViewDelegate> {

	IBOutlet UIImageView	*img;
	IBOutlet UIWebView		*header;
	IBOutlet UIWebView		*info;
	
	NSString *style;
	Artwork *art;
	BOOL zoomed;
	BOOL mapButton;
}

@property (nonatomic,strong) UIImageView *img;
@property (nonatomic, strong) UIWebView	*header;
@property (nonatomic, strong) UIWebView *info;
@property (nonatomic, strong) Artwork *art;
@property (nonatomic, strong) NSString *style;
@property (nonatomic) BOOL zoomed;
@property (nonatomic) BOOL mapButton;

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType;
-(void) showMapView:(id)sender;
-(void) fillHeader;
-(void) fillInfo;

@end


