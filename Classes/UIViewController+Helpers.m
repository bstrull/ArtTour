//
//  UIViewController+Helpers.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 6/1/14.
//  Copyright (c) 2014 Last Mountain Software. All rights reserved.
//

#import "UIViewController+Helpers.h"

@implementation UIViewController (Helpers)

- (UIBarButtonItem *) defaultBackButtonTitle
{
  NSString *backTitle = @"";

  if (!IS_OS_7_OR_LATER)
    backTitle = @"Back";

  if (self.navigationItem.backBarButtonItem == nil)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backTitle style:UIBarButtonItemStylePlain target:nil action:nil];
  else
    self.navigationItem.backBarButtonItem.title = backTitle;
  return self.navigationItem.backBarButtonItem;
}


@end
