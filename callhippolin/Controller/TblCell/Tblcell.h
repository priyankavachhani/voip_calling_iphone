//
//  Tblcell.h
//  CallHippoV2_LIN
//
//  Created by Hippo on 30/04/19.
//  Copyright © 2019 Hippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "ACFloatingTextField.h"

NS_ASSUME_NONNULL_BEGIN

//@interface Tblcell : UITableViewCell
@interface Tblcell : SWTableViewCell


// dialvc
@property (weak, nonatomic) IBOutlet UIImageView *img_select_con_num;
@property (weak, nonatomic) IBOutlet UILabel *lbl_select_con_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_select_con_number;

//Drawer
@property (weak, nonatomic) IBOutlet UIImageView *imgIcone;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;









@property (nonatomic, assign) SWCellState stagecell;







@end

NS_ASSUME_NONNULL_END
