//
//  SpotDetailCell.h
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 3/17/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageSpot;
@property (weak, nonatomic) IBOutlet UILabel *labelSpotName;
@property (weak, nonatomic) IBOutlet UITextView *descSpot;

@end
