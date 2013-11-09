//
//  SpotsViewController.h
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 2/25/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString * activityToDisplay;
@end
