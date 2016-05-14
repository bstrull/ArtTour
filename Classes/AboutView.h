//
//  AboutView.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/2/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutView : UIViewController <UIWebViewDelegate> {

	IBOutlet UIWebView		*info;

}

@property (nonatomic, strong) UIWebView *info;


@end
