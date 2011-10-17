//
//  MessageViewController.m
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "MessageViewController.h"

#import "StealthSender.h"

@implementation MessageViewController

@synthesize messageSegmentedControl = _messageSegmentedControl;
@synthesize recipientLabel = _recipientLabel;
@synthesize recipientField = _recipientField;
@synthesize sendButton = _sendButton;
@synthesize textView = _textView;

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[self.textView becomeFirstResponder];
}

- (void) updateView
{
	BOOL isTweet = self.messageSegmentedControl.selectedSegmentIndex == 2;
	self.recipientLabel.hidden = isTweet;
	self.recipientField.hidden = isTweet;
	
	switch (self.messageSegmentedControl.selectedSegmentIndex)
	{
		case 0: // Email
			self.sendButton.enabled = [MFMailComposeViewController canSendMail];
			break;
		
		case 1: // SMS
			self.sendButton.enabled = [MFMessageComposeViewController canSendText];
			break;
		
		case 2: // Twitter
			self.sendButton.enabled = [TWTweetComposeViewController canSendTweet];
			break;
		
		default:
			break;
	}
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self updateView];
}

// MARK: - Actions

- (IBAction) changeMessageKind:(UISegmentedControl *)segmentedControl
{
	[self updateView];
}

- (IBAction) sendMessage:(id)sender
{
	UIViewController *composeViewController = nil;
	switch (self.messageSegmentedControl.selectedSegmentIndex)
	{
		case 0: // Email
		{
			MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
			[mailComposeViewController setToRecipients:[NSArray arrayWithObject:self.recipientField.text]];
			[mailComposeViewController setSubject:@""];
			[mailComposeViewController setMessageBody:self.textView.text isHTML:NO];
			composeViewController = mailComposeViewController;
			break;
		}
		
		case 1: // SMS
		{
			MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
			messageComposeViewController.recipients = [NSArray arrayWithObject:self.recipientField.text];
			messageComposeViewController.body = self.textView.text;
			composeViewController = messageComposeViewController;
			break;
		}
		
		case 2: // Tweet
		{
			TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
			[tweetComposeViewController setInitialText:self.textView.text];
			composeViewController = tweetComposeViewController;
			break;
		}
		
		default:
			break;
	}
	
	StealthSender *stealthSender = [[StealthSender alloc] initWithComposeViewController:composeViewController];
	[stealthSender sendWithCompletionHandler:NULL];
}

// MARK: - UITextField delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[self sendMessage:textField];
	return YES;
}

@end
