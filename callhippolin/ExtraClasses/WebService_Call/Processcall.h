//
//  Processcall.h
//  teacher_module
//
//  Created by Ratnakala55 on 7/1/15.
//  Copyright (c) 2015 Ratanakala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Processcall : NSObject

+(void) showLoadingWithView:(UIView *)view1 withLabel:(NSString *)labelstring;
+(void) hideLoadingWithView;

@end
