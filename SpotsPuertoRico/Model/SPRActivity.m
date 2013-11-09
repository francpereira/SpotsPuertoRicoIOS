//
//  SPRActivity.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 2/25/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "SPRActivity.h"

@interface SPRActivity()

@property (nonatomic, strong) NSMutableData *responseData;
@property (retain, nonatomic) NSURLConnection *connection;

@end


@implementation SPRActivity

- (void) GetAllActivities{

    //NSMutableData *responseData = [NSMutableData data];
    
    NSURL *url = [NSURL URLWithString:@"http://api.franchali.com/Spotiao/api/Activity"];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection start];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSMutableData *responseData = [[NSMutableData alloc] init];
    
    [responseData appendData:data];
    
    NSDictionary*   json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers  error:nil];
    
    self.listOfActivities = [json allValues];
    
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError");
    
}

@end



