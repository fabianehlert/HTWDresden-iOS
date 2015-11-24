//
//  Note.h
//  HTWDresden
//
//  Created by Benjamin Herzog on 05.01.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * credits;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * note;
@property (nonatomic, retain) NSNumber * nr;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * versuch;
@property (nonatomic, retain) NSDate * datum;
@property (nonatomic, retain) NSString * form;
@property (nonatomic, retain) NSString * vermerk;
@property (nonatomic, retain) NSDate * voDatum;
@property (nonatomic, retain) User *user;

@end
