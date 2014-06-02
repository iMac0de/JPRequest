//
//  JPRequest.h
//
//  Created by Jeremy Peltier on 02/06/2014.
//  Copyright (c) 2014 Jeremy Peltier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPRequest : NSObject{
    NSString *reply;
}

+(JPRequest *)singleton;

+(NSString *)postRequestWithUrl:(NSString *)url andPostData:(NSString *)postData;
+(NSString *)getRequestWithUrl:(NSString *)url;

@end
