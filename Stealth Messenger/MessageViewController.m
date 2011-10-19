//
//  MessageViewController.m
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "MessageViewController.h"

#import "ABGetMe.h"
#import "StealthSender.h"

NSString *myEmail(void)
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	ABRecordRef me = ABGetMe(addressBook);
	NSString *email = nil;
	if (me)
	{
		ABMultiValueRef emails = ABRecordCopyValue(me, kABPersonEmailProperty);
		if (emails)
		{
			CFIndex emailCount = ABMultiValueGetCount(emails);
			if (emailCount > 0)
				email =  CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, 0));
			
			CFRelease(emails);
		}
	}
	CFRelease(addressBook);
	
	return email;
}

NSString *myMobilePhoneNumber(void)
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	ABRecordRef me = ABGetMe(addressBook);
	NSString *mobilePhoneNumber = nil;
	if (me)
	{
		ABMultiValueRef phones = ABRecordCopyValue(me, kABPersonPhoneProperty);
		if (phones)
		{
			for (CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
			{
				NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
				if ([label isEqualToString:(id)kABPersonPhoneIPhoneLabel] || [label isEqualToString:(id)kABPersonPhoneMobileLabel])
				{
					mobilePhoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
					break;
				}
			}
			CFRelease(phones);
		}
	}
	CFRelease(addressBook);
	
	return mobilePhoneNumber;
}

@implementation MessageViewController

@synthesize messageSegmentedControl = _messageSegmentedControl;
@synthesize recipientLabel = _recipientLabel;
@synthesize recipientField = _recipientField;
@synthesize sendButton = _sendButton;
@synthesize statusLabel = _statusLabel;
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
	
	self.statusLabel.text = nil;
	
	NSString *title = [[self.messageSegmentedControl titleForSegmentAtIndex:self.messageSegmentedControl.selectedSegmentIndex] lowercaseString];
	self.textView.text = [NSString stringWithFormat:@"This %@ was sent with Stealth Messenger - https://github.com/0xced/StealthMessenger", title];
	
	switch (self.messageSegmentedControl.selectedSegmentIndex)
	{
		case 0: // Email
			self.recipientField.text = myEmail();
			self.sendButton.enabled = [MFMailComposeViewController canSendMail];
			break;
		
		case 1: // SMS
			self.recipientField.text = myMobilePhoneNumber();
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
			[mailComposeViewController setSubject:@"Stealth email"];
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
	
	self.statusLabel.text = @"\u2026";
	
	StealthSender *stealthSender = [[StealthSender alloc] initWithComposeViewController:composeViewController];
	[stealthSender sendWithCompletionHandler:^(BOOL success) {
		self.statusLabel.text = success ? @"\u2714" : @"\u2718";
	}];
}

// MARK: - UITextField delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[self sendMessage:textField];
	return YES;
}

@end
