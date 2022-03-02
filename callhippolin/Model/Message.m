//
//  Message.m
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)init
{
    self = [super init];
    if (self)
    {
        self.sender = @"chetan";
        self.status = MessageStatusSending;
        self.text = @"";
        self.heigh = 44;
        self.date = [NSDate date];
        self.identifier = @"";
        self.chat_id = @"";
        self.SmsUUID = @"";
        self.SmsId = @"";
    }
    return self;
}

+(Message *)messageFromDictionary:(NSDictionary *)dictionary
{
    Message *message = [[Message alloc] init];
    message.text = dictionary[@"text"];
    NSLog(@"S<<<<M<<<S : %@",dictionary);
    message.SmsId = dictionary[@"_id"];
    message.SmsUUID = dictionary[@"smsUUID"];
    message.identifier = dictionary[@"message_id"];
    message.status = [dictionary[@"status"] integerValue] + 1;
    
    NSString *dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
    
    //Date in UTC
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:dateFormat];
    NSDate *date = [inputDateFormatter dateFromString:dictionary[@"sent"]];
    
    //Convert time in UTC to Local TimeZone
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:dateFormat];
    NSString *outputString = [outputDateFormatter stringFromDate:date];
    
    message.date = [outputDateFormatter dateFromString:outputString];
    
    return message;
}

@end
