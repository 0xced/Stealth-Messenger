//
//  StealthSender.m
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "StealthSender.h"

#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

@interface StealthSender ()

@property (nonatomic, assign) BOOL isMailViewController;
@property (nonatomic, assign) BOOL isMessageViewController;
@property (nonatomic, assign) BOOL isTweetViewController;

- (void) sendMail:(void (^)(BOOL success))completionHandler;
- (void) sendMessage:(void (^)(BOOL success))completionHandler;
- (void) sendTweet:(void (^)(BOOL success))completionHandler;

@end

@implementation StealthSender

@synthesize isMailViewController = _isMailViewController;
@synthesize isMessageViewController = _isMessageViewController;
@synthesize isTweetViewController = _isTweetViewController;

- (id) initWithComposeViewController:(UIViewController *)composeViewController
{
	if (!(self = [super init]))
		return nil;
	
	self.isMailViewController = [composeViewController isKindOfClass:[MFMailComposeViewController class]];
	self.isMessageViewController = [composeViewController isKindOfClass:[MFMessageComposeViewController class]];
	self.isTweetViewController = [composeViewController isKindOfClass:[TWTweetComposeViewController class]];
	
	if (!(self.isMailViewController || self.isMessageViewController || self.isTweetViewController))
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The composeViewController argument must be an instance of MFMailComposeViewController, MFMessageComposeViewController or TWTweetComposeViewController." userInfo:nil];
	
	return self;
}

- (void) sendWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
	if (self.isMailViewController)
		[self sendMail:completionHandler];
	else if (self.isMessageViewController)
		[self sendMessage:completionHandler];
	else if (self.isTweetViewController)
		[self sendTweet:completionHandler];
}

- (void) sendMail:(void (^)(BOOL success))completionHandler
{
	NSLog(@"TODO: send mail");
}

- (void) sendMessage:(void (^)(BOOL success))completionHandler
{
	NSLog(@"TODO: send message");
}

- (void) sendTweet:(void (^)(BOOL success))completionHandler
{
	NSLog(@"TODO: send tweet");
}

@end
