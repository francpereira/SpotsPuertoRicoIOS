//
//  CreateSpotViewController.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 8/31/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "CreateSpotViewController.h"
#import <MapKit/MapKit.h>
#import <AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>





@interface CreateSpotViewController ()

@end

@implementation CreateSpotViewController

double currentLatitude;
double currentLongitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    
    //self.pinCreated = false;
    
	// Do any additional setup  after loading the view.
    self.scrollView.delegate = self;
    self.scrollView.contentSize =CGSizeMake(320, 1250);
    self.scrollView.scrollEnabled = TRUE;
    
    
    self.txtDescription.layer.borderWidth = 1.0f;
    self.txtDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.txtDescription.delegate = self;
    self.txtName.delegate = self;
    
   // self.mapViewer.showsUserLocation = TRUE;
    self.mapViewer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
  
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.spotPhoto.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    
    if (userLocation.location == nil)
        return;
    
    //if (self.pinCreated == false)
    //{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100);
    [self.mapViewer setRegion:[self.mapViewer regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Nuevo Spot";
    
    
    
    if (self.mapViewer.annotations.count < 1)
    {
        currentLatitude = userLocation.coordinate.latitude;
        currentLongitude = userLocation.coordinate.longitude;
        
        [self.mapViewer addAnnotation:point];
    }
    //}
    //else
   // {
    //   self.pinCreated = true;
    //}
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
     NSLog(@"viewForAnnotation");
    
     if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
     static NSString *reuseId = @"pin";
     MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
     if (pav == nil)
     {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = YES;
        pav.canShowCallout = YES;
     }
     else
     {
        pav.annotation = annotation;
     }
    
     return pav;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    NSLog(@"New Position");
    
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        currentLatitude = droppedAt.latitude;
        currentLongitude = droppedAt.longitude;
        
        NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)btnCreateSpot:(id)sender {
    
    
    UIAlertView *validationAlert;
    
    if (self.txtName.text.length < 1)
    {
        validationAlert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                             message:@"El nombre del spot es requerido."
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
     
        [validationAlert show];
        return;
    }
    
    
    if (self.txtDescription.text.length < 1)
    {
        validationAlert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                     message:@"La descripcion del spot es requerida."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        
        [validationAlert show];
        return;
    }
    
    
    
    NSString *requestURL = @"http://api.franchali.com/Spotiao/api/Spots";
    
    
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithString:self.txtName.text] forKey:@"SpotName"];
    [_params setObject:[NSString stringWithString:self.txtDescription.text] forKey:@"SpotDescription"];
    [_params setObject:[NSString stringWithFormat:@"%f", currentLatitude] forKey:@"SpotLatitude"];
    [_params setObject:[NSString stringWithFormat:@"%f", currentLongitude] forKey:@"SpotLongitude"];
    [_params setObject:[NSString stringWithString:self.chkPaddleBoarding.isOn ? @"1" : @"0"] forKey:@"mcaPaddleBoarding"];
    [_params setObject:[NSString stringWithString:self.chkKayaking.isOn ? @"1" : @"0"] forKey:@"mcaKayaking"];
    [_params setObject:[NSString stringWithString:self.chkSnorkeling.isOn ? @"1" : @"0"] forKey:@"mcaSnorkeling"];
    [_params setObject:[NSString stringWithString:self.chkKiteSurfing.isOn ? @"1" : @"0"] forKey:@"mcaKiteSurfing"];
    [_params setObject:[NSString stringWithString:self.chkFoodTruck.isOn ? @"1" : @"0"] forKey:@"mcaFoodTrucks"];
    [_params setObject:[NSString stringWithString:self.chkSurfing.isOn ? @"1" : @"0"] forKey:@"mcaSurfing"];
    [_params setObject:[NSString stringWithString:self.chkSkateBoarding.isOn ? @"1" : @"0"] forKey:@"mcaSkateboarding"];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.spotPhoto.image, 0.4)
                                    name:@"spot"
                                fileName:@"spotimage.jpg"
                                mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        UIAlertView *createdSpotAlert;
        
        createdSpotAlert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                     message:@"Gracias! El nuevo spot ha sido creado."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        
        [createdSpotAlert show];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (UIImage*) resizedImageWithSize:(UIImage *)imagen_cap
{
    CGSize size_img = CGSizeMake(240, 320);
    
	UIGraphicsBeginImageContext(size_img);
    
	[imagen_cap drawInRect:CGRectMake(0.0f, 0.0f, size_img.width, size_img.height)];
    
	// An autoreleased image
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return newImage;
}

@end
