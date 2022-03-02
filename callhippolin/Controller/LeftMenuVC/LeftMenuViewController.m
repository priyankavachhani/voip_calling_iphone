//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "Tblcell.h"
#import "UtilsClass.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"

#import "DialerVC.h"
#include <stdio.h>
#include <stdlib.h>
#import "Processcall.h"

#import "AppDelegate.h"
#import "Constant.h"



@import Firebase;
@implementation LeftMenuViewController
{
  
    NSMutableArray *menuArr;
    NSMutableArray *imgArr;
  
    
}

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.slideOutAnimationEnabled = YES;
    

    
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    


    self.tblLeftSideMenuView.separatorColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.tblLeftSideMenuView.backgroundView = imageView;
    
      [self testing_label_display];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture addTarget:self action:@selector(userprofileClick:)];
    
    [_lblUserEmailID addGestureRecognizer:tapGesture];
    
   
    
    
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewWillAppear:(BOOL)animated
{
  
    
    menuArr = [[NSMutableArray alloc] initWithObjects:@"Dialer", nil];
    imgArr = [[NSMutableArray alloc] initWithObjects:@"menu_dial", nil];
    
    _tblLeftSideMenuView.delegate = self;
    _tblLeftSideMenuView.dataSource = self;
    [_tblLeftSideMenuView reloadData];

 
    
    
    [self testing_label_display];
}

-(void)testing_label_display
{
    if([Testing_version_display  isEqual: @"true"])
    {
        _lbl_version.text = Testing_version_display_count;
        _lbl_version.hidden = false;
    }
    else
    {
        _lbl_version.text = @"";
        _lbl_version.hidden = true;
    }
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tblLeftSideMenuView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tblcell *cell = [_tblLeftSideMenuView dequeueReusableCellWithIdentifier:@"Tblcell"];
    NSString *title = [menuArr objectAtIndex:indexPath.row];
    NSString *image = [imgArr objectAtIndex:indexPath.row];
    cell.lblTitle.text = title;
    cell.imgIcone.image = [UIImage imageNamed:image];
    
    

    NSString *strSelectedMenu = [Default valueForKey:SelectedSideMenu];
    NSString *strSelectedRow = title;
    
    if ([strSelectedRow isEqualToString:strSelectedMenu]) {
        cell.backgroundColor = [UIColor colorWithRed:0.135 green:0.135 blue:0.135 alpha:0.1];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.8519228101 green:0.8525723815 blue:0.8520234227 alpha:1]);
        NSString *image1 = [Default valueForKey:SelectedSideMenuImage];
        cell.imgIcone.image = [UIImage imageNamed:image1];
        
    }else{
        cell.backgroundColor =[UIColor colorWithRed:0.9996390939 green:1 blue:0.9997561574 alpha:1];
    }
    
    return cell;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    DialerVC *Dialer = [[self storyboard] instantiateViewControllerWithIdentifier: @"DialerVC"];
    
    
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    
    //    UIViewController *vc ;
    NSString *title = [menuArr objectAtIndex:indexPath.row];
    NSString *strSelectedMenu = [Default valueForKey:SelectedSideMenu];
    NSString *strSelectedRow = title;
    
    
    if (![strSelectedRow isEqualToString:strSelectedMenu])
    {
        if([title isEqualToString:@"Dialer"])
        {
            [FIRAnalytics logEventWithName:@"ch_dialer" parameters:nil];
            [navigationController setViewControllers:@[Dialer]];
            [Default setValue:@"dialpadon" forKey:SelectedSideMenuImage];
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
             [Default setValue:title forKey:SelectedSideMenu];
            
        }
     
        
     
       
    }else
    {
        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    
}




@end
