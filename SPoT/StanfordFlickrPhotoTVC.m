//
//  StandFordFlickrPhotoTVC.m
//  SPoT
//
//  Created by William Ho on 9/13/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "StanfordFlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface StanfordFlickrPhotoTVC ()

@end

@implementation StanfordFlickrPhotoTVC

#define DICTIONARY_TAG_KEY @"tag"
#define DICTIONARY_COUNT_KEY @"count"

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.photos = [FlickrFetcher stanfordPhotos];
    self.photos = [self groupByTags:self.photos];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self tagForRow:indexPath.row];
    cell.detailTextLabel.text = [self countForRow:indexPath.row];
    
    return cell;
}

#pragma mark - Helpers

-(NSString*)countForRow:(NSUInteger)row
{
    return [self.photos[row][DICTIONARY_COUNT_KEY] description];
}

-(NSString*)tagForRow:(NSUInteger)row
{
    return [self.photos[row][DICTIONARY_TAG_KEY] description];
}

#pragma mark - Main Functions

-(NSArray*)groupByTags:(NSArray*)photos
{
    NSMutableArray *allPhotos = [[NSMutableArray alloc] initWithArray:photos]; //of NSDictionary
    NSMutableArray *allUniqueTags = [[NSMutableArray alloc] init]; //of NSString
    
    for(NSDictionary* photoDictionary in allPhotos)
    {
        NSArray *tags = [photoDictionary[FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        for(NSString *tag in tags)
        {
            if(![tag isEqualToString:@"cs193pspot"] && ![tag isEqualToString:@"portrait"] && ![tag isEqualToString:@"landscape"])
                [allUniqueTags addObject:tag];
        }
    }
    
    NSCountedSet *uniqueTagsSet = [[NSCountedSet alloc] initWithArray:allUniqueTags];
    allUniqueTags = [[uniqueTagsSet allObjects] copy];
    
    NSMutableArray *groupedPhotos = [[NSMutableArray alloc] init];
    for(NSString *tag in allUniqueTags)
    {
        NSString *capTag = [tag capitalizedString];
        NSString *countString = [NSString stringWithFormat:@"%d photos", [uniqueTagsSet countForObject:tag]];
        
        [groupedPhotos addObject:@{DICTIONARY_TAG_KEY:capTag, DICTIONARY_COUNT_KEY: countString}];
    }
    
    return groupedPhotos;
}


@end
