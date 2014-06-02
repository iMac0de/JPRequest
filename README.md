JPRequest
=========

JPRequest is a simple Objective-C object to send and receive POST and GET data from a webservice

How To Use It ?
===============

JPRequest is very easy to use.

In your code, import the JPRequest.h file and use it like it :

``` Objective-c

-(void)yourFunctionName {
  // POST request example
  NSString *replyPOST = [JPRequest postRequestWithUrl:@"http://www.example.com" andPostData:@"parameter1=1&parameter2=2"];

  // GET request example
  NSString *replyGET = [JPRequest getRequestWithUrl:@"http://www.example.com"];
}

How to know if the request is finished ?
========================================

JPRequest use the NSNotificationCenter to send notifications in the app to say when the request start and finish. You can launch a loader listening NSNotificationCenter.

The key for the start of the request is : @"START_LOADING_JP_REQUEST"

The key for the end of the request is : @"STOP_LOADING_JP_REQUEST"

