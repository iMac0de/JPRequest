//
//  JPRequest.m
//
//  Created by Jeremy Peltier on 02/06/2014.
//  Copyright (c) 2014 Jérémy Peltier. All rights reserved.
//

#import "JPRequest.h"

@implementation JPRequest

-(id)init{
    self = [super init];
    if (self){
        // do something
    }
    return self;
}

+(JPRequest *)singleton{
    static JPRequest *singleton;
    
    if (singleton == nil){
        singleton = [[JPRequest alloc] init];
    }
    return singleton;
}

#pragma mark - SEND REQUEST TO SERVER

-(void)sendRequest:(NSMutableURLRequest *)request{
    // Create a group for the block threading
    dispatch_group_t group = dispatch_group_create();
    
    // Enter in the group
    dispatch_group_enter(group);
    
    // Launch the block threading
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Send a notification to launch a loading system
        [[NSNotificationCenter defaultCenter] postNotificationName:@"START_LOADING_JP_REQUEST" object:nil];
        
        // Send the request and download the reply
        NSError *error;
        NSURLResponse *response;
        NSData *data;
        data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        reply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        
        // When the reply is downloaded
        dispatch_async(dispatch_get_main_queue(), ^{
            // Send a notification to stop the loading system
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_LOADING_JP_REQUEST" object:nil];
            
            // Leave the group to stop the block threading
            dispatch_group_leave(group);
        });
    });
    
    // Wait system during the downloading of the reply
    while (dispatch_group_wait(group, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    }
}

#pragma mark - POST REQUEST

+(NSString *)postRequestWithUrl:(NSString *)myUrl andPostData:(NSString *)stringPostData{
    return [[JPRequest singleton] postRequestWithUrl:myUrl andPostData:stringPostData];
}

-(NSString *)postRequestWithUrl:(NSString *)myUrl andPostData:(NSString *)stringPostData{    
    NSURL *url = [NSURL URLWithString:myUrl];
    NSString *post = stringPostData;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [self sendRequest:request];
    
    return reply;
}

#pragma mark - GET REQUEST

+(NSString *)getRequestWithUrl:(NSString *)myUrl{
    return [[JPRequest singleton] getRequestWithUrl:myUrl];
}

-(NSString *)getRequestWithUrl:(NSString *)myUrl{
    NSURL *url = [NSURL URLWithString:myUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [self sendRequest:request];
    
    return reply;
}

@end
