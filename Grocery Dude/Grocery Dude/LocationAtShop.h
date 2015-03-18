//
//  LocationAtShop.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/18.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface LocationAtShop : NSManagedObject

@property (nonatomic, retain) NSString * aisle;
@property (nonatomic, retain) NSSet *items;
@end

@interface LocationAtShop (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
