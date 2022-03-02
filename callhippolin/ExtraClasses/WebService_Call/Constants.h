//
//  Constants.h
//  racecustomer
//
//  Created by MacOS on 1/28/16.
//  Copyright © 2016 MacOS. All rights reserved.
//


#define refresh_background_color [UIColor blackColor]
#define refresh_tin_color [UIColor whiteColor]
#define main_orrange_clolor [UIColor colorWithRed:0.75 green:0.02 blue:0.07 alpha:1.0]

#define main_orrange_clolor_final [UIColor colorWithRed:228.0/255.0 green:122.0/255.0 blue:74.0/255.0 alpha:1.0]

#pragma mark- Declartions
#pragma mark-

extern NSString *const URL_LOGIN;
extern NSString *const URL_REGISTER;
extern NSString *const URL_EDIT_PROFILE;
extern NSString *const URL_CHANGE_PASSWORD;
extern NSString *const URL_FORGET_PASSWORD;
extern NSString *const URL_BUILDING_DETAILS;
extern NSString *const URL_USER_DETAILS;
extern NSString *const URL_DOC_DETAILS;
extern NSString *const URL_UPDATE_BUILDNG;


// notification
extern NSString *const URL_SEND_NOTIFICATION;
extern NSString *const URL_NOTIFICATION_LIST;
extern NSString *const URL_USER_LIST;


// bord
extern NSString *const URL_COMMUNITY_BOARD;
extern NSString *const URL_COMMUNITY_BOARD_ADD;
extern NSString *const URL_COMMUNITY_BOARD_COMMENT;
extern NSString *const URL_COMMUNITY_BOARD_DELETE;


// laws
extern NSString *const URL_LAWS;
extern NSString *const URL_AG_DIS;
extern NSString *const URL_LAWS_COMMENT;


// log screen
extern NSString *const URL_MAINTENANCE;
extern NSString *const URL_MAINTENANCE_COMMENT;
extern NSString *const URL_ADD_MAINTENANCE;
extern NSString *const URL_LOG_COMMENT;
extern NSString *const URL_LOG_DELETE;


// event screen
extern NSString *const URL_EVENT_LISTING;
extern NSString *const URL_EVENT_ADD;
extern NSString *const URL_EVENT_EDIT;
extern NSString *const URL_EVENT_DELETE;
extern NSString *const URL_EVENT_ATTENDANCE;


//amenities
extern NSString *const URL_AMENITIES;
extern NSString *const URL_BOOKING_LIST;
extern NSString *const URL_BOOKING;


//directory screen
extern NSString *const URL_DIRECTORY_LISTING;
extern NSString *const URL_AROUNDME_LISTING;
extern NSString *const URL_AROUNDME_LISTING_DETAIL;

// concierges screen

extern NSString *const URL_CONCIERGES_LISTING;

// profile edit
extern NSString *const URL_PROFILE_EDIT;
extern NSString *const URL_PROFILE;
extern NSString *const URL_PROFILE_TYPE;
extern NSString *const URL_PROFILE_BYID;

// sreaming
extern NSString *const URL_STREAMAING_SEND;

// employee_manage
extern NSString *const URL_EMPLOYEEMANAGE;
extern NSString *const URL_EMPLOYEEMANAGE_COMMENT;
// amenityies_manage
extern NSString *const URL_AMENITESMANAGE;
extern NSString *const URL_AMENITESMANAGE_BYID;
extern NSString *const URL_AMENITESMANAGE_BYID_COMMENT;

#define Default [NSUserDefaults standardUserDefaults]
