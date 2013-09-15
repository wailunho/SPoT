//
//  RecentPhotos.m
//  SPoT
//
//  Created by William Ho on 9/14/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrFetcher.h"

@implementation RecentPhotos

#define KEY_RECENT_PHOTOS @"Recent Photos"
#define MAX_RECENT_PHOTOS 30

+(NSArray *)allPhotos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_RECENT_PHOTOS];
}

+(void)addPhoto:(NSDictionary *)newphoto
{
    NSMutableArray *allPhotos = [[NSMutableArray alloc] initWithArray:[RecentPhotos allPhotos]];
    NSString *newphotoTitle = [newphoto[FLICKR_PHOTO_TITLE] description];
    NSString *newphotoDescription = [newphoto valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    //Check if the new photo already existed, if yes, remove it.
    for(int i = 0; i < [allPhotos count]; i++)
    {
        NSDictionary *photo = allPhotos[i];
        NSString *photoTitle = [photo[FLICKR_PHOTO_TITLE] description];
        NSString *photoDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        
        //Checking only the photo's title and description
        if([photoTitle isEqualToString:newphotoTitle] && [photoDescription isEqualToString:newphotoDescription])
        {
            [allPhotos removeObjectAtIndex:i];
            break;
        }
    }
    //always add the new photo to the very beginning
    [allPhotos insertObject:newphoto atIndex:0];
    if(MAX_RECENT_PHOTOS < [allPhotos count])
       [allPhotos removeLastObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:allPhotos forKey:KEY_RECENT_PHOTOS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
