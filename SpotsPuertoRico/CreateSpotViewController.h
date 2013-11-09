//
//  CreateSpotViewController.h
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 8/31/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CreateSpotViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *spotPhoto;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewer;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnCreateSpot:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UISwitch *chkFoodTruck;

@property (weak, nonatomic) IBOutlet UISwitch *chkKayaking;

@property (weak, nonatomic) IBOutlet UISwitch *chkKiteSurfing;

@property (weak, nonatomic) IBOutlet UISwitch *chkPaddleBoarding;

@property (weak, nonatomic) IBOutlet UISwitch *chkSkateBoarding;

@property (weak, nonatomic) IBOutlet UISwitch *chkSnorkeling;

@property (weak, nonatomic) IBOutlet UISwitch *chkSurfing;


@end
