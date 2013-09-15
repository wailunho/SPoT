//
//  RecentPhotos.h
//  SPoT
//
//  Created by William Ho on 9/14/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+(NSArray*)allPhotos;
+(void)addPhoto:(NSDictionary*)photo;

@end
