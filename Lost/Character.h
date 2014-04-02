//
//  Character.h
//  Lost
//
//  Created by Marion Ano on 4/1/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * passenger;
@property (nonatomic, retain) NSString * sex;

@end
