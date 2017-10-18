//
//  TuyChinhViewController.h
//  iost3h
//
//  Created by Hoang on 9/12/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

@interface TuyChinhViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblMonAnMoi;
@property (weak, nonatomic) IBOutlet UILabel *lblSoMonAnMoi;
@property(nonatomic)NSUserDefaults *userDefault;
@property (weak, nonatomic) IBOutlet UISwitch *switchHienMonMoi;
@property (weak, nonatomic) IBOutlet UIStepper *stepperSoMonMoi;

- (IBAction)hienMonAnMoi:(id)sender;
- (IBAction)soMonAnMoi:(id)sender;
- (IBAction)openMenu:(id)sender;

@end
