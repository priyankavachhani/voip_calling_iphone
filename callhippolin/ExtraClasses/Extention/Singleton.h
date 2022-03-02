//
//  Singleton.h
//  callhippolin
//
//  Created by Admin on 27/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject
@property (nonatomic, retain) NSMutableArray * arrContactList1;
@property (nonatomic, retain) NSMutableArray * Mixallcontact1;
@property (nonatomic, retain) NSMutableArray * Papiarray;
@property (nonatomic, retain) NSMutableArray * final_globalArray;

+(Singleton*)singleton;
+(NSMutableArray*)global_array_data_get;
@end
NS_ASSUME_NONNULL_END
