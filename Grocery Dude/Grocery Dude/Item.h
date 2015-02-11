//
//  Item.h
//  Grocery Dude
//
//  Created by qihaijun on 2/11/15.
//  Copyright (c) 2015 Victor Chee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * collected;
@property (nonatomic, retain) NSNumber * listed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSNumber * quantity;

@end
