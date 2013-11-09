//
//  SpotViewController.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 3/16/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "SpotViewController.h"
#import <MapKit/MapKit.h>

@interface SpotViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *spotMap;
@property (weak, nonatomic) IBOutlet UITextView *spotDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spotImage;

@property (weak, nonatomic) IBOutlet UILabel *spotNameLabel;
@property (retain, nonatomic) NSURLConnection *connectionSpots;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation SpotViewController

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
    //self.spotNameLabel.text = self.spotToDisplay;
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    
    
    

    
    NSString *urlSpot = [NSString stringWithFormat:@"http://api.franchali.com/Spotiao/api/Spots/%@",self.spotToDisplay];
    NSLog(@"%@", urlSpot);
    NSURL *url = [NSURL URLWithString:urlSpot];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url];
    
    self.responseData = [[NSMutableData alloc] init];
    
    NSURLConnection *connectionSpots = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connectionSpots start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connection:(NSURLConnection *)connectionSpots didReceiveData:(NSData *)data {
    
    // NSMutableData *responseData = [[NSMutableData alloc] init];
    
    [self.responseData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary*   json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions  error:nil];
    
    self.spotNameLabel.text = [json objectForKey:@"Name"];
    self.spotDescLabel.text = [json objectForKey:@"Description"];
    
    
    //add image
    NSString *imageStringUrl = [NSString stringWithFormat:@"http://api.franchali.com/Uploads/%@", [json objectForKey:@"MainPhoto"]];
    NSURL * imageURL = [NSURL URLWithString:imageStringUrl];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    
    self.spotImage.image = image;
    
    
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    NSString *mapLatitude = [json objectForKey:@"MapLatitude"];
    NSString *mapLongitude = [json objectForKey:@"MapLongitude"];
    
    point.coordinate = CLLocationCoordinate2DMake(mapLatitude.doubleValue, mapLongitude.doubleValue);
    point.title = [json objectForKey:@"Name"];
    //point.subtitle = @"I'm here!!!";
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 3000, 3000);
    [self.spotMap setRegion:[self.spotMap regionThatFits:region] animated:YES];
    
    
    [self.spotMap addAnnotation:point];

    
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError");
    
}



@end
