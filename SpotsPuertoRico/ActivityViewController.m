//
//  ActivityViewController.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 2/9/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "ActivityViewController.h"
#import "SpotsViewController.h"
#import "SPRActivity.h"

@interface ActivityViewController ()

    @property (weak, nonatomic) IBOutlet UITableView *activitiesTblView;
    @property (nonatomic, strong) NSMutableArray *arrayOfActivities;
    @property (nonatomic, strong) NSMutableArray *arrayOfActivitiesIds;
    @property (nonatomic, strong) NSMutableArray *arrayOfActivitiesDescription;
    @property (retain, nonatomic) NSURLConnection *connection;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
    @property (nonatomic, strong) NSMutableData *responseData;

@end


@implementation ActivityViewController

- (NSMutableArray *) _arrayOfActivities
{
   if (_arrayOfActivities == nil)
   {
       _arrayOfActivities = [[NSMutableArray alloc] init];
   }
   
   return _arrayOfActivities;
   
}

- (void) ActivityItems{
 
    SPRActivity *spractivity = [[SPRActivity alloc]init];
    
    [spractivity GetAllActivities];
    
}


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
    
    [[self activitiesTblView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    self.activitiesTblView.opaque = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://api.franchali.com/Spotiao/api/Activity"];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    self.responseData = [[NSMutableData alloc] init];

    
    [connection start];
       
    self.activitiesTblView.delegate = self;
    self.activitiesTblView.dataSource = self;

}

- (void)connection:(NSURLConnection *)connectionSpots didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSArray*   json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions  error:nil];
    
    for (int i = 0; i < [json count]; i++) {
        
        if (_arrayOfActivities == nil)
        {
            _arrayOfActivities = [[NSMutableArray alloc] init];
        }
        
        if (_arrayOfActivitiesIds == nil)
        {
            _arrayOfActivitiesIds = [[NSMutableArray alloc] init];
        }
        
        if (_arrayOfActivitiesDescription == nil)
        {
            _arrayOfActivitiesDescription = [[NSMutableArray alloc] init];
        }

        
        
        [self.arrayOfActivitiesIds addObject:[[json objectAtIndex:i] objectForKey:@"Id"]];
        [self.arrayOfActivities addObject:[[json objectAtIndex:i] objectForKey:@"Name"]];
        [self.arrayOfActivitiesDescription addObject:[[json objectAtIndex:i] objectForKey:@"Description"]];

        
        NSLog(@"%@", [self.arrayOfActivities[i] description]);
    }
    
    
    [self.activitiesTblView reloadData];
    [self.activityIndicator stopAnimating];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError");
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self arrayOfActivities] count];

}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
   if ([segue.identifier isEqualToString:@"ActivityToSpotSegue"])
   {
       NSIndexPath *path = [self.activitiesTblView indexPathForSelectedRow];
       
       SpotsViewController *spvc =  segue.destinationViewController;
       
       spvc.activityToDisplay = [[self arrayOfActivitiesIds] objectAtIndex:path.row];
       
   }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = [[self arrayOfActivities] objectAtIndex:[indexPath row]];
 
    return cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
