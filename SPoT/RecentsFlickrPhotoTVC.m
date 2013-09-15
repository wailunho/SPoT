//
//  RecentsFlickPhotoTVC.m
//  SPoT
//
//  Created by William Ho on 9/14/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "RecentsFlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentPhotos.h"

@interface RecentsFlickrPhotoTVC ()

@end

@implementation RecentsFlickrPhotoTVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photos = [RecentPhotos allPhotos];
}
@end
