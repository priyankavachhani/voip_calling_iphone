//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@property (nonatomic, strong) IBOutlet UIImageView *imgProUser;
@property (nonatomic, strong) IBOutlet UIButton *btnCloseSideMenu;
@property (nonatomic, strong) IBOutlet UIView *viewMainLeftSideMenu;
@property (nonatomic, strong) IBOutlet UITableView *tblLeftSideMenuView;
@property (nonatomic, strong) IBOutlet UILabel *lblUserName;
@property (nonatomic, strong) IBOutlet UILabel *lblUserEmailID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_version;
@property (strong, nonatomic) IBOutlet UILabel *lbl_badgetag;
@property (strong, nonatomic) IBOutlet UIImageView *img_badge;


@end
