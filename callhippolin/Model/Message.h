//
//  Message.h
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MessageStatus)
{
    MessageStatusSending,
    MessageStatusSent,
    MessageStatusReceived,
    MessageStatusRead,
    MessageStatusFailed
};

//typedef NS_ENUM(NSInteger, MessageSender)
//{
//    MessageSenderMyself,
//    MessageSenderSomeone
//};

//
// This class is the message object itself
//
@interface Message : NSObject

@property (strong, nonatomic) NSString *sender;
@property (assign, nonatomic) MessageStatus status;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *chat_id;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *SmsId;
@property (strong, nonatomic) NSString *SmsUUID;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) CGFloat heigh;

+(Message *)messageFromDictionary:(NSDictionary *)dictionary;

@end


