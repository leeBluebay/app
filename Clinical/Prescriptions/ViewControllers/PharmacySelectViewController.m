//
//  PharmacySelectViewController.m
//  Clinical Demo
//
//  Created by Lee Daniel on 04/03/2014.
//
//

#import "PharmacySelectViewController.h"
#import "Pharmacy.h"
#import "PharmacyTableCell.h"

@interface PharmacySelectViewController ()



@property (strong, nonatomic) NSMutableArray *pharmacies;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, strong) CLLocation *currentLocation ;
@end

@implementation PharmacySelectViewController

CLLocationManager *locationManager;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    [self populatePharmacyArray];
    
    [self showToolbar];
}

- (void) populatePharmacyArray
{
    _pharmacies = [[NSMutableArray alloc] init];
    
    [_pharmacies addObject:[self createPharmacy:@"BOOTS (Nottingham Victoria Centre)" postCode:@"NG1 3QS" line1:@"Nottingham Victoria Centre" line2:@"" city:@"Nottingham" latitude:52.95560472573446 longitude:-1.1466749906539]];
    [_pharmacies addObject:[self createPharmacy:@"BOOTS (Riverside Park)" postCode:@"NG2 1RU" line1:@"Riverside Park" line2:@"" city:@"Nottingham" latitude:52.93281190942965 longitude:-1.1661518812179]];
    [_pharmacies addObject:[self createPharmacy:@"BOOTS (31 High Road)" postCode:@"NG9 2JQ" line1:@"31 High Road" line2:@"" city:@"Nottingham" latitude:52.92766588278611 longitude:-1.2145081758499]];
    [_pharmacies addObject:[self createPharmacy:@"BOOTS (Giltbrook)" postCode:@"NG16 2RP" line1:@"Giltbrook Retail Park" line2:@"" city:@"Nottingham" latitude:53.002941304400366 longitude:-1.28213822841642]];
    [_pharmacies addObject:[self createPharmacy:@"BOOTS (Wyvern Way)" postCode:@"DE21 6NZ" line1:@"Wyvern Way" line2:@"" city:@"Derby" latitude:52.91764848770395 longitude:-1.4373439550399]];
    [_pharmacies addObject:[self createPharmacy:@"BOOTS (Market Place)" postCode:@"LE11 3EQ" line1:@"11-13 Market Place" line2:@"" city:@"Leicestershire" latitude:52.77185457200076 longitude:-1.2070869207382]];
}

- (void) calculateDistances:(CLLocation*) currentLocation
{
    for (Pharmacy *pharmacy in _pharmacies)
    {
        CLLocation *pharmacyLoc = [[CLLocation alloc] initWithLatitude:pharmacy.Latitude longitude:pharmacy.Longitude];
        CLLocationDistance kms = [pharmacyLoc distanceFromLocation:currentLocation] / 1000;
        
        
        pharmacy.Distance = kms;
    }
}

- (double) calculateDistance:(double) latitude longitude:(double) longitude
{
    CLLocation *pharmacyLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance kms = [pharmacyLoc distanceFromLocation:_currentLocation] / 1000;
        
        
    return kms;
    
}


- (Pharmacy *)createPharmacy:(NSString *)name postCode:(NSString *)postCode line1:(NSString *)line1 line2:(NSString *)line2 city:(NSString *)city latitude:(double)latitude longitude:(double)longitude
{
    Pharmacy *pharmacy = [[Pharmacy alloc] init];
    
    pharmacy.Name = name;
    pharmacy.PostCode = postCode;
    pharmacy.AddressLine1 = line1;
    pharmacy.AddressLine2 = line2;
    pharmacy.City = city;
    pharmacy.Latitude = latitude;
    pharmacy.Longitude = longitude;
    
    return pharmacy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    _currentLocation = newLocation;
    
    if (_currentLocation != nil) {
        [self calculateDistances:_currentLocation];
    }
    
    [locationManager stopUpdatingLocation];
    
    [self sortLocations];
    
    [[self tableView] reloadData];
}

-(void) sortLocations
{
    NSArray *sortedArray;
    sortedArray = [_pharmacies sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        double first = [(Pharmacy*)a Distance];
        double second = [(Pharmacy*)b Distance];
        
        return first > second;
    }];
    
    [_pharmacies removeAllObjects];
    
    [_pharmacies addObjectsFromArray:sortedArray];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_pharmacies count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PharmacyCell";
    
    PharmacyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[PharmacyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 

    Pharmacy *pharmacy = [_pharmacies objectAtIndex: indexPath.section];
    
    // Configure the cell...
    
    cell.nameLabel.text = pharmacy.Name;
    cell.addressLine1Label.text = pharmacy.AddressLine1;
    cell.addressLine2Label.text = pharmacy.City;
    cell.postCodeLabel.text = pharmacy.PostCode;
    pharmacy.Distance = [self calculateDistance:pharmacy.Latitude longitude:pharmacy.Longitude];
                         
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setPositiveFormat:@"0.##"];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@ KM", [formatter stringFromNumber:[NSNumber numberWithDouble:pharmacy.Distance]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pharmacy *pharmacy = [_pharmacies objectAtIndex:indexPath.section];
    
    NSString *strConfirm = [NSString stringWithFormat: @"Send prescription to %@?", pharmacy.Name];
    
    self.sheet = [[UIActionSheet alloc] initWithTitle:strConfirm delegate:self cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil otherButtonTitles:@"Confirm", nil];
    
    [self.sheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Confirm"]) {
        [self.pharmacySelectViewControllerDelegate returnHome:self];
    }
}

- (void) showToolbar
{
    UIImage *buttonImage = [UIImage imageNamed:kHomeImage];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(returnHome) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:buttonImage forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:leftBarButtonItem, spaceBarButtonItem, nil];
    [self setToolbarItems:arr animated:YES];
}

- (void)returnHome
{
    [self.pharmacySelectViewControllerDelegate returnHome:self];
}


- (IBAction)returnHome:(id)sender {
    [self.pharmacySelectViewControllerDelegate returnHome:self];
}



@end
