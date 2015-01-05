//
//  Speise.h
//  HTWDresden
//
//  Created by Benjamin Herzog on 05.01.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Speise : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * mensa;
@property (nonatomic, retain) NSString * title;

@end
