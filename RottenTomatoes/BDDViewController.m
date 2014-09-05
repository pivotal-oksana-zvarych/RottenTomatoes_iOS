//
//  BDDViewController.m
//  RottenTomatoes
//
//  Created by DX133-XL on 2014-09-04.
//  Copyright (c) 2014 DX133-XL. All rights reserved.
//

#import "BDDViewController.h"

@interface BDDViewController ()
@end

@implementation BDDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cachedImages = [[NSMutableDictionary alloc] init];
    self.tableItems = [[NSMutableArray alloc] init];
    
	self.data = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=6akfhv5xp54e8m7pzmdhwxr2&page_limit=20&page=6&country=ca"]];
    NSLog(@"DEBUG: got here 2");
    NSURLConnection *Conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!Conn)
        NSLog(@"bad");
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

-(NSString*) cacheMovieImagesName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheMovieImagesName = [documentsDirectory stringByAppendingPathComponent:@"RottenTomatoesImages"];
    return cacheMovieImagesName;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) result {
    NSLog(@"DEBUG: receive response");
    
    self.data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)Conn {
    NSLog(@"DEBUG: receive data");
    [self.data appendData:Conn];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    self.responseDict = [NSJSONSerialization JSONObjectWithData:self.data options:nil error:nil];
    self.results = [self.responseDict objectForKey:@"movies"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.view = tableView;
    
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.results count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    //cell.imageView.image = [self.cachedImages valueForKey:identifier];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    cell.textLabel.text = [[self.results objectAtIndex:indexPath.row] objectForKey:@"title"];
    //cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                            indexPath.row];
    //self.img = [UIImage imageNamed:@"placeholder.jpg"];
    
    if([self.cachedImages objectForKey:identifier] != nil){
        cell.imageView.image = [self.cachedImages valueForKey:identifier];
    }else{
        
        //self.img = [UIImage imageNamed:@"placeholder.jpg"];
        
        char const * s = [identifier  UTF8String];
        
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^{
            
            NSString *url = [[[[self.responseDict objectForKey:@"movies" ] objectAtIndex:indexPath.row ] objectForKey:@"posters"] objectForKey:@"thumbnail"];
            
            //NSString *url = @"http://ovidos.com/img/logo.png";
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            self.img = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    
                    [self.cachedImages setValue:self.img forKey:identifier];
                    
                    cell.imageView.image = [self.cachedImages valueForKey:identifier];
                }
            });
        });
    }
    
    return cell;
}


@end