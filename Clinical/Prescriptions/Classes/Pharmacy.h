//
//  Pharmacy.h
//  Clinical Demo
//
//  Created by Lee Daniel on 04/03/2014.
//
//

#import <Foundation/Foundation.h>

@interface Pharmacy : NSObject

@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *PostCode;
@property (nonatomic, strong) NSString *AddressLine1;
@property (nonatomic, strong) NSString *AddressLine2;
@property (nonatomic, strong) NSString *City;
@property (nonatomic) double Latitude;
@property (nonatomic) double Longitude;
@property (nonatomic) double Distance;

@end
