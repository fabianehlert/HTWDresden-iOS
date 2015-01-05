//
//  Stunde.h
//  HTWDresden
//
//  Created by Benjamin Herzog on 05.01.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Stunde : NSManagedObject

@property (nonatomic, retain) NSDate * anfang;
@property (nonatomic, retain) NSNumber * anzeigen;
@property (nonatomic, retain) NSString * bemerkungen;
@property (nonatomic, retain) NSString * dozent;
@property (nonatomic, retain) NSDate * ende;
@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSString * kurzel;
@property (nonatomic, retain) NSString * raum;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSString * titel;
@property (nonatomic, retain) NSString * typ;
@property (nonatomic, retain) User *student;

@end
