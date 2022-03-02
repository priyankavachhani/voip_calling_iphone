//
//  Constants.m
//  racecustomer
//
//  Created by MacOS on 1/28/16.
//  Copyright © 2016 MacOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

//http://chefsby.onusinfotech.com/

#pragma mark- Declaration
#pragma mark-


NSString *const URL_LOGIN = @"login.json";
NSString *const URL_REGISTER = @"register.json";
NSString *const URL_EDIT_PROFILE = @"edituser/";
NSString *const URL_CHANGE_PASSWORD = @"changePassword.json";
NSString *const URL_FORGET_PASSWORD = @"forgotPassword.json";
NSString *const URL_BUILDING_DETAILS = @"buildings/manage/1.json";
NSString *const URL_USER_DETAILS = @"buildings/manageuser/1.json";
NSString *const URL_DOC_DETAILS = @"documents/index/";
NSString *const URL_UPDATE_BUILDNG = @"buildings/manage/";

// notification
NSString *const URL_SEND_NOTIFICATION = @"notifications/send_message/";
NSString *const URL_NOTIFICATION_LIST = @"notifications/notificationlist/";
NSString *const URL_USER_LIST = @"buildings/usersdetail/";

// board
NSString *const URL_COMMUNITY_BOARD = @"boards/index/";
NSString *const URL_COMMUNITY_BOARD_ADD = @"boards/add_thread/";
NSString *const URL_COMMUNITY_BOARD_COMMENT = @"boards/thread_comment/";
NSString *const URL_COMMUNITY_BOARD_DELETE = @"boards/deleteComment/";


// laws
NSString *const URL_LAWS = @"laws/get_law/";
NSString *const URL_AG_DIS = @"laws/voting/";
NSString *const URL_LAWS_COMMENT = @"laws/comments/";

// log screen
NSString *const URL_MAINTENANCE = @"logs/index/";
NSString *const URL_MAINTENANCE_COMMENT = @"logs/log_comment/";
NSString *const URL_ADD_MAINTENANCE = @"logs/add_log/";
NSString *const URL_LOG_DELETE = @"logs/delete/";




// event screen
NSString *const URL_EVENT_LISTING  = @"events/index/";
NSString *const URL_EVENT_ADD = @"events/add/";
NSString *const URL_EVENT_EDIT = @"events/edit/";
NSString *const URL_EVENT_DELETE = @"events/delete/";
NSString *const URL_EVENT_ATTENDANCE = @"events/attendance/";


//amenities
NSString *const URL_AMENITIES = @"amenities/index/";
NSString *const URL_BOOKING_LIST = @"amenities/view/";
NSString *const URL_BOOKING = @"amenities/view/";

// concierges screen
NSString *const URL_CONCIERGES_LISTING = @"concierges/index/";

// profile
NSString *const URL_PROFILE_EDIT = @"buildings/edituser/";
NSString *const URL_PROFILE = @"buildings/changeproperty/";
NSString *const URL_PROFILE_TYPE = @"buildings/change_profile_type/";
NSString *const URL_PROFILE_BYID = @"Users/userDetail/";



// directory
NSString *const URL_DIRECTORY_LISTING = @"buildings/directory/";
NSString *const URL_AROUNDME_LISTING =@"google_places/index/";
NSString *const URL_AROUNDME_LISTING_DETAIL =@"https://maps.googleapis.com/maps/api/place/details/json?";

// streaming
NSString *const URL_STREAMAING_SEND = @"notifications/user_message/";


// employee_manage
NSString *const URL_EMPLOYEEMANAGE = @"users/manageemployee/";
NSString *const URL_EMPLOYEEMANAGE_COMMENT = @"buildings/shift_employee_comment/";


// amenityies_manage
NSString *const URL_AMENITESMANAGE = @"amenities/maintenanceAmenities/";
NSString *const URL_AMENITESMANAGE_BYID = @"amenities/manageMaintenanceEmployee/";
NSString *const URL_AMENITESMANAGE_BYID_COMMENT = @"amenities/amenities_comment/";



