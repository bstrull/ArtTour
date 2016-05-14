//
//  ImageLoader.h
//  Lake Oswego Art
//
//  Created by Brian Strull on 3/1/11.
//  Copyright 2011 Last Mountain Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Artwork;
@class RootViewController;

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject
{
    Artwork *artRecord;
    NSIndexPath *indexPathInTableView;
    id <ImageDownloaderDelegate> __weak delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, strong) Artwork *artRecord;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol ImageDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
