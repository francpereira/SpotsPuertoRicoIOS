//
//  SpotsViewController.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 2/25/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "SpotsViewController.h"
#import "SpotViewController.h"
#import "SpotDetailCell.h"
#import <SDWebImage/UIImageView+WebCache.h>




@interface SpotsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblViewSpots;
@property (nonatomic, strong) NSMutableArray *arrayOfSpots;
@property (nonatomic, strong) NSMutableArray *arrayOfSpotsIds;
@property (nonatomic, strong) NSMutableArray *arrayOfSpotsDesc;
@property (nonatomic, strong) NSMutableArray *arrayOfSpotsImages;
@property (retain, nonatomic) NSURLConnection *connectionSpots;
@property (nonatomic, strong) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SpotsViewController

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
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
    
    [super viewDidLoad];
    
    [[self tblViewSpots] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    self.tblViewSpots.opaque = NO;
    
    
	
    self.tblViewSpots.delegate = self;
    self.tblViewSpots.dataSource = self;
    
    NSString *urlSpots = [NSString stringWithFormat:@"http://api.franchali.com/Spotiao/api/Spots?actividad=%@&top=100",self.activityToDisplay];
    NSLog(@"%@", urlSpots);
    NSURL *url = [NSURL URLWithString:urlSpots];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self arrayOfSpots] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MySpotCell";
    
    SpotDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[SpotDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    cell.labelSpotName.text = [[self arrayOfSpots] objectAtIndex:[indexPath row]];
    cell.descSpot.text = [[self arrayOfSpotsDesc ] objectAtIndex:[indexPath row]];
    
    NSString *imageStringUrl = [NSString stringWithFormat:@"http://api.franchali.com/Uploads/%@", [[self arrayOfSpotsImages] objectAtIndex:[indexPath row]]];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageStringUrl]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //NSURL * imageURL = [NSURL URLWithString:imageStringUrl];
    //NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    //UIImage * image = [UIImage imageWithData:imageData];
    
    //cell.imageView.image = image;
    
    return cell;
}



- (void)connection:(NSURLConnection *)connectionSpots didReceiveData:(NSData *)data {
    
    // NSMutableData *responseData = [[NSMutableData alloc] init];
    
    [self.responseData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSArray*   json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions  error:nil];
    
    if (_arrayOfSpots == nil)
    {
        _arrayOfSpots = [[NSMutableArray alloc] init];
    }
    
    
    if (_arrayOfSpotsIds == nil)
    {
        _arrayOfSpotsIds = [[NSMutableArray alloc] init];
    }
    
    if (_arrayOfSpotsDesc == nil)
    {
        _arrayOfSpotsDesc = [[NSMutableArray alloc] init];
    }
    
    if (_arrayOfSpotsImages == nil)
    {
        _arrayOfSpotsImages = [[NSMutableArray alloc] init];
    }
    
    
    
    //[self.arrayOfSpots removeAllObjects];
    
    for (int x = 0; x < [json count]; x++) {
        
        NSLog(@"%@", [[json objectAtIndex:x] objectForKey:@"Name"]);
        NSLog(@"%@", [[json objectAtIndex:x] objectForKey:@"MapLatitude"]);
        NSLog(@"%@", [[json objectAtIndex:x] objectForKey:@"MapLongitude"]);
        
        
        
        
        [self.arrayOfSpots addObject:[[json objectAtIndex:x] objectForKey:@"Name"]];
        [self.arrayOfSpotsIds addObject:[[json objectAtIndex:x] objectForKey:@"Id"]];
        [self.arrayOfSpotsDesc addObject:[[json objectAtIndex:x] objectForKey:@"Description"]];
        [self.arrayOfSpotsImages addObject:[[json objectAtIndex:x] objectForKey:@"MainPhoto"]];
        
        
    }
    
    [self.tblViewSpots reloadData];
    [self.activityIndicator stopAnimating];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError");
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"SpotsToSpotSegue"])
    {
        NSIndexPath *path = [self.tblViewSpots indexPathForSelectedRow];
        
        SpotViewController *spvc =  segue.destinationViewController;
        
        spvc.spotToDisplay = [NSString stringWithFormat:@"%@", [[self arrayOfSpotsIds] objectAtIndex:path.row]];
        
    }
}

@end
