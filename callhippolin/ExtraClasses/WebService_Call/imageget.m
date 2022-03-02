//
//  imageget.m
//  pdfreader
//
//  Created by Ratnakala13 on 1/23/16.
//  Copyright © 2016 Ratnakala13. All rights reserved.
//

#import "imageget.h"

@implementation imageget


+ (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef pageNumber:(size_t)pagenum
{
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, pagenum);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
//    CGSize maxPageSize = CGSizeMake(595, 842);
//    UIGraphicsBeginImageContextWithOptions(maxPageSize, NO, 0);
//    //NSLog(@"w %f",pageRect.size.width);
//     //NSLog(@"h %f",pageRect.size.height);
    UIGraphicsBeginImageContextWithOptions(pageRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

+ (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSString *) getgroupid:(NSString *)user1 second:(NSString *)user2 {
    
    
    NSString *userId1 = user1;
    NSString *userId2 = user2;
    
//    NSString *groupId = ([userId1 compare:userId2] < 0) ? [userId1 stringByAppendingString:userId2] : [userId2 stringByAppendingString:userId1];
    
//     //NSLog(@"userId1 --> %@",userId1);
//     //NSLog(@"userId2 --> %@",userId2);
    
    NSString *groupId = ([userId1 compare:userId2] < 0) ? [[userId1 stringByAppendingString:@"--*--"] stringByAppendingString:userId2] : [[userId2 stringByAppendingString:@"--*--"] stringByAppendingString:userId1];
    
    //NSLog(@"groupId Genrate --> %@",groupId);
    
    return groupId;
   
}




+ (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
