//
//  SPRActivity.h
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 2/25/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SPRActivity : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSArray *listOfActivities;


- (void) GetAllActivities;


@end

