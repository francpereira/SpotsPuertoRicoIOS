//
//  LugaresViewController.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 2/26/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "LugaresViewController.h"
#import <MapKit/MapKit.h>


@interface LugaresViewController ()
 @property (weak, nonatomic) IBOutlet MKMapView *mapViewer;
 @property (retain, nonatomic) NSURLConnection *connectionSpots;
 @property (nonatomic, strong) NSMutableData *responseData;
@end


#define METERS_PER_MILE 1609.344

@implementation LugaresViewController

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
	// Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"http://api.franchali.com/Spotiao/api/Spots"];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url];
    
    self.responseData = [[NSMutableData alloc] init];
    
    NSURLConnection *connectionSpots = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connectionSpots start];
    
    self.mapViewer.delegate = (id)self;
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50000, 50000);
    [self.mapViewer setRegion:[self.mapViewer regionThatFits:region] animated:YES];
}


- (void)connection:(NSURLConnection *)connectionSpots didReceiveData:(NSData *)data {
    
   // NSMutableData *responseData = [[NSMutableData alloc] init];
    
    [self.responseData appendData:data];
        
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSArray*   json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions  error:nil];
    
    for (int x = 0; x < [json count]; x++) {
        
        NSLog(@"%@", [[json objectAtIndex:x] objectForKey:@"Name"]);
        NSLog(@"%@", [[json objectAtIndex:x] objectForKey:@"MapLatitude"]);
        NSLog(@"%@", [[json objectAtIndex:x] objectForKey:@"MapLongitude"]);
        
        
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        
        NSString *mapLatitude = [[json objectAtIndex:x] objectForKey:@"MapLatitude"];
        NSString *mapLongitude = [[json objectAtIndex:x] objectForKey:@"MapLongitude"];
        
        point.coordinate = CLLocationCoordinate2DMake(mapLatitude.doubleValue, mapLongitude.doubleValue);
        point.title = [[json objectAtIndex:x] objectForKey:@"Name"];
        //point.subtitle = @"I'm here!!!";
        
        
        [self.mapViewer addAnnotation:point];
        
    }
    
    //[self.mapViewer re
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError");
    
}

- (IBAction)SateliteMapButton:(id)sender {
     self.mapViewer.mapType = MKMapTypeSatellite;
}


- (IBAction)StandarMapButton:(id)sender {
    self.mapViewer.mapType = MKMapTypeStandard;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
    
  //  [super viewWillAppear:YES];
    
    // 1
    //CLLocationCoordinate2D zoomLocation;
    //zoomLocation.latitude = 39.281516;
    //zoomLocation.longitude= -76.580806;
    
    // 2
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
    //                                                                   0.5 * METERS_PER_MILE,
    //                                                                   0.5 * METERS_PER_MILE);
    
    // 3
    //[self.mapViewer setRegion:viewRegion animated:YES];
//}

@end
