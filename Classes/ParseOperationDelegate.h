//
//  ParseOperationDelegate.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/7/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ParseOperationDelegate
	- (void)didFinishParsing;
	- (void)parseErrorOccurred:(NSError *)error;
@end
