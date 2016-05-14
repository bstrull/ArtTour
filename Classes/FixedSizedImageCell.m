//
//  FixedSizedImageCell.m
//  Lake Oswego Art
//
//  Created by Brian Strull on 6/15/14.
//  Copyright (c) 2014 Last Mountain Software. All rights reserved.
//

#import "FixedSizedImageCell.h"

@implementation FixedSizedImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      if ([self respondsToSelector:@selector(setSeparatorInset:)])
        self.separatorInset = UIEdgeInsetsMake(self.separatorInset.top, 82, self.separatorInset.bottom, self.separatorInset.right);
      [self.textLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
      [self.detailTextLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
      [self.imageView setAutoresizingMask:UIViewAutoresizingNone];
       self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, 60, 90);

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews
{
  [super layoutSubviews];

  float cellWidth = self.contentView.bounds.size.width;
  float desiredWidth = 60;
  float w=self.imageView.frame.size.width;
  if (w != desiredWidth) {
    float widthSub = w - desiredWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, 60, 90);
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x-widthSub,self.textLabel.frame.origin.y,cellWidth - 60,self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x-widthSub,self.detailTextLabel.frame.origin.y,cellWidth-60,self.detailTextLabel.frame.size.height);
  }
}


@end
