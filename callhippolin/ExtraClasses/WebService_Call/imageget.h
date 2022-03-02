//
//  imageget.h
//  pdfreader
//
//  Created by Ratnakala13 on 1/23/16.
//  Copyright © 2016 Ratnakala13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface imageget : NSObject

+ (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef pageNumber:(size_t)pagenum;
+ (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
+ (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize;
+(NSString *) getgroupid:(NSString *)user1 second:(NSString *)user2;


@end
