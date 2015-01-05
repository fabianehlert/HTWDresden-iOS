//
//  User.h
//  HTWDresden
//
//  Created by Benjamin Herzog on 05.01.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Stunde;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * dozent;
@property (nonatomic, retain) NSDate * letzteAktualisierung;
@property (nonatomic, retain) NSString * matrnr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * raum;
@property (nonatomic, retain) NSSet *stunden;
@property (nonatomic, retain) NSSet *noten;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStundenObject:(Stunde *)value;
- (void)removeStundenObject:(Stunde *)value;
- (void)addStunden:(NSSet *)values;
- (void)removeStunden:(NSSet *)values;

- (void)addNotenObject:(Note *)value;
- (void)removeNotenObject:(Note *)value;
- (void)addNoten:(NSSet *)values;
- (void)removeNoten:(NSSet *)values;

@end
