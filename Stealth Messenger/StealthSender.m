//
//  StealthSender.m
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "StealthSender.h"

#import <objc/message.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

@interface StealthSender () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, assign) BOOL isMailViewController;
@property (nonatomic, assign) BOOL isMessageViewController;
@property (nonatomic, assign) BOOL isTweetViewController;
@property (nonatomic, strong) UIViewController *composeViewController;
@property (nonatomic, copy) ComposeViewControllerCompletionHandler completionHandler;

- (void) sendMail;
- (void) sendMessage;
- (void) sendTweet;

@end

@implementation StealthSender

@synthesize isMailViewController = _isMailViewController;
@synthesize isMessageViewController = _isMessageViewController;
@synthesize isTweetViewController = _isTweetViewController;
@synthesize composeViewController = _composeViewController;
@synthesize completionHandler = _completionHandler;

- (id) initWithComposeViewController:(UIViewController *)composeViewController
{
	if (!(self = [super init]))
		return nil;
	
	self.isMailViewController = [composeViewController isKindOfClass:[MFMailComposeViewController class]];
	self.isMessageViewController = [composeViewController isKindOfClass:[MFMessageComposeViewController class]];
	self.isTweetViewController = [composeViewController isKindOfClass:[TWTweetComposeViewController class]];
	self.composeViewController = composeViewController;
	
	if (!(self.isMailViewController || self.isMessageViewController || self.isTweetViewController))
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The composeViewController argument must be an instance of MFMailComposeViewController, MFMessageComposeViewController or TWTweetComposeViewController." userInfo:nil];
	
	return self;
}

- (void) sendWithCompletionHandler:(ComposeViewControllerCompletionHandler)completionHandler
{
	((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"retain"));

	self.completionHandler = completionHandler;
	
	if (self.isMailViewController)
		[self sendMail];
	else if (self.isMessageViewController)
		[self sendMessage];
	else if (self.isTweetViewController)
		[self sendTweet];
}

- (void) executeCompletionHandler:(BOOL)success
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.completionHandler)
			self.completionHandler(success);
		
		((void(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"release"));
	});
}

// MARK: - Email

- (void) sendMail
{
	MFMailComposeViewController *mailComposeViewController = (MFMailComposeViewController*)self.composeViewController;
	mailComposeViewController.mailComposeDelegate = self;
	
	[mailComposeViewController viewWillAppear:NO];
	[mailComposeViewController view];
	[mailComposeViewController viewDidAppear:NO];
	
	[self performSelector:@selector(failMail) withObject:nil afterDelay:3.0];
}

- (void) failMail
{
	[self executeCompletionHandler:NO];
}

- (void) mailComposeController:(MFMailComposeViewController*)mailComposeViewController bodyFinishedLoadingWithResult:(NSInteger)result error:(NSError*)error
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(failMail) object:nil];
	
	@try
	{
		Class MFMailComposeController = NSClassFromString(@"MFMailComposeController");
		id mailComposeController = [mailComposeViewController valueForKeyPath:@"internal"];
		if (![mailComposeController isKindOfClass:MFMailComposeController])
			mailComposeController = [mailComposeController valueForKey:@"mailComposeController"]; // iOS < 5: internal isa MFMailComposeRootViewController
		
		id sendButtonItem = nil;
		@try
		{
			sendButtonItem = [mailComposeController valueForKey:@"sendButtonItem"];
		}
		@catch (NSException *exception)
		{
			sendButtonItem = [mailComposeViewController valueForKeyPath:@"internal.mailComposeView.sendButtonItem"];
		}
		[mailComposeController performSelector:@selector(send:) withObject:sendButtonItem];
	}
	@catch (NSException *exception)
	{
		[self failMail];
	}
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self executeCompletionHandler:result == MFMailComposeResultSent];
}

// MARK: - SMS

- (void) sendMessage
{
	MFMessageComposeViewController *messageComposeViewController = (MFMessageComposeViewController*)self.composeViewController;
	messageComposeViewController.messageComposeDelegate = self;
	
	NSLog(@"TODO: send message");
	[self executeCompletionHandler:NO];
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self executeCompletionHandler:result == MessageComposeResultSent];
}

// MARK: - Tweet

- (void) sendTweet
{
	NSLog(@"TODO: send tweet");
	[self executeCompletionHandler:NO];
}

@end
