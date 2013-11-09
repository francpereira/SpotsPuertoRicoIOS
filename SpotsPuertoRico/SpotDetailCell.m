//
//  SpotDetailCell.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 3/17/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "SpotDetailCell.h"



@implementation SpotDetailCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,7,80,60);
    self.imageView.bounds = CGRectMake(10, 7,80,60);
}

@end
