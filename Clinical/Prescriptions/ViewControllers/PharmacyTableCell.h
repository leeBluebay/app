//
//  PharmacyTableCell.h
//  Clinical Demo
//
//  Created by Lee Daniel on 05/03/2014.
//
//

#import <UIKit/UIKit.h>



@interface PharmacyTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLine1Label;
@property (strong, nonatomic) IBOutlet UILabel *addressLine2Label;
@property (strong, nonatomic) IBOutlet UILabel *postCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
