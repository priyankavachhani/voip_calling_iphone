//
//  Processcall.m
//  teacher_module
//
//  Created by Ratnakala55 on 7/1/15.
//  Copyright (c) 2015 Ratanakala. All rights reserved.
//

#import "Processcall.h"
#import "DejalActivityView.h"

@implementation Processcall

+(void) showLoadingWithView:(UIView *)view1 withLabel:(NSString *)labelstring {
    
     [DejalBezelActivityView activityViewForView:view1 withLabel:labelstring];
}
+(void) hideLoadingWithView
{
    [DejalBezelActivityView removeViewAnimated:NO];
    
}

+(void) showblurView:(UIView *)view1 withLabel:(NSString *)labelstring {
    
    [DejalBezelActivityView activityViewForView:view1 withLabel:labelstring];
}
+(void) hideblurView
{
    [DejalBezelActivityView removeViewAnimated:NO];
    
}

@end
