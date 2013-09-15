//
//  StandFordFlickrPhotoTVC.m
//  SPoT
//
//  Created by William Ho on 9/13/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "TagsFlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface TagsFlickrPhotoTVC ()

@property (strong, nonatomic) NSDictionary *photosByTags; //of NSArray of NSDictionary
@property (strong, nonatomic) NSArray *sortedTagsInArray; //of NSString

@end

@implementation TagsFlickrPhotoTVC

#pragma mark - Init

-(void)setPhotosByTags:(NSDictionary *)photosByTags
{
    _photosByTags = photosByTags;
    _sortedTagsInArray = [[NSArray alloc] initWithArray:[[self.photosByTags allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *tag1 = obj1;
        NSString *tag2 = obj2;
        return [tag1 compare:tag2];
    }]];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.photos = [FlickrFetcher stanfordPhotos];
    self.photosByTags = [self groupByTags];
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *tag = self.sortedTagsInArray[indexPath.row];
    cell.textLabel.text = [tag capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos",[self countForTag:tag]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.photosByTags allKeys] count];
}

#pragma mark - Helpers

-(NSUInteger)countForTag:(NSString*)tag
{
    return [self.photosByTags[tag] count];
}

-(NSString*)tagForRow:(NSUInteger)row
{
    return [self.photosByTags allKeys][row];
}

-(NSString*)titleForPhoto:(NSDictionary*)photo
{
    return [photo[FLICKR_PHOTO_TITLE] description];
}

#pragma mark - Main Functions
-(NSDictionary*)groupByTags
{
    NSMutableDictionary *photosByTags = [[NSMutableDictionary alloc] init];
    for(NSDictionary *photo in self.photos)
    {
        NSArray *tags = [photo[FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        for(NSString *tag in tags)
        {
            if([tag isEqualToString:@"cs193pspot"])continue;
            if([tag isEqualToString:@"portrait"])continue;
            if([tag isEqualToString:@"landscape"])continue;
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:photosByTags[tag]];
            [tempArray addObject:photo];
            
            [photosByTags addEntriesFromDictionary:@{tag:tempArray}];
        }
    }
    return [photosByTags copy];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show PhotoTable"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
                {
                    NSString *tag = [self tagForRow:indexPath.row];
                    //Photos are sorted by their titles only.
                    NSArray *sortedPhotos = [[NSArray alloc] initWithArray:[self.photosByTags[tag] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        NSDictionary *photo1 = obj1;
                        NSDictionary *photo2 = obj2;
                        return [[self titleForPhoto:photo1] compare:[self titleForPhoto:photo2]];
                    }]];
                    
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:sortedPhotos];
                    [segue.destinationViewController setTitle:[tag capitalizedString]];
                }
            }
        }
    }
}


@end
