//
//  Singleton.m
//  callhippolin
//
//  Created by Admin on 27/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "Singleton.h"
#import "UtilsClass.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Constant.h"
#import "OnCallVC.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


@implementation Singleton
@synthesize final_globalArray;
@synthesize arrContactList1;
@synthesize Mixallcontact1;
@synthesize Papiarray;




+(Singleton *)singleton {
    static dispatch_once_t pred;
    static Singleton *shared = nil;
    dispatch_once(&pred, ^{
        
        shared = [[Singleton alloc] init];
        shared.final_globalArray = [[NSMutableArray alloc]init];
        shared.arrContactList1 = [[NSMutableArray alloc]init];
        shared.Mixallcontact1 = [[NSMutableArray alloc]init];
        shared.Papiarray = [[NSMutableArray alloc]init];

        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if( status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
        {
            //NSLog(@"access denied");
        }
        else
        {
            //Create repository objects contacts
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            
            //Select the contact you want to import the key attribute  ( https://developer.apple.com/library/watchos/documentation/Contacts/Reference/CNContact_Class/index.html#//apple_ref/doc/constant_group/Metadata_Keys )
            
            NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
            
            // Create a request object
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            request.predicate = nil;
            
            [contactStore enumerateContactsWithFetchRequest:request
                                                      error:nil
                                                 usingBlock:^(CNContact* __nonnull contact, BOOL* __nonnull stop)
             {
                 // Contact one each function block is executed whenever you get
                 NSString *phoneNumber = @"";
                 if( contact.phoneNumbers)
                     phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
                 
               
                 
                 NSString *FullName = [NSString stringWithFormat:@"%@%@",contact.givenName,contact.familyName];
                 NSString *Number = [NSString stringWithFormat:@"%@",phoneNumber];
                 NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                 [dic setObject:FullName forKey:@"name"];
                 [dic setObject:Number forKey:@"number"];
                 
                 if(![FullName isEqualToString:@""] || ![Number isEqualToString:@""])
                 {
                     if([FullName isEqualToString:@""])
                     {
                         
                     }
                     else if ([Number isEqualToString:@""])
                     {
                         
                     }
                     else
                     {
                         [shared.arrContactList1 addObject:dic];
                         //NSLog(@"arr contact : %@",shared.arrContactList1);
                         [shared.Mixallcontact1 addObject:dic];
                         [shared.Papiarray addObject:dic];
                         [shared.final_globalArray addObject:shared.arrContactList1];
                     }
                     
                     
                 }
             }];
        }
        
        
        
     });
    return shared;
}
+(NSMutableArray*)global_array_data_get
{
    static Singleton *shared = nil;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    shared = [self singleton];
    arr = shared.final_globalArray;
    return arr;
}

@end
