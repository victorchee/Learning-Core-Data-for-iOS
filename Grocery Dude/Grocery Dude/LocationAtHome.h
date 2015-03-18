//
//  LocationAtHome.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/18.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface LocationAtHome : NSManagedObject

@property (nonatomic, retain) NSString * storedIn;
@property (nonatomic, retain) NSSet *items;
@end

@interface LocationAtHome (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
