//
//  MessageViewController.m
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController

@synthesize textView = _textView;
@synthesize recipientLabel = _recipientLabel;
@synthesize recipientField = _recipientField;

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[self.textView becomeFirstResponder];
}

// MARK: - Actions

- (IBAction) changeMessageKind:(UISegmentedControl *)segmentedControl
{
	BOOL isTweet = segmentedControl.selectedSegmentIndex == 2;
	self.recipientLabel.hidden = isTweet;
	self.recipientField.hidden = isTweet;
}

- (IBAction) sendMessage:(id)sender
{
	NSLog(@"sendMessage:%@", sender);
}

// MARK: - UITextField delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[self sendMessage:textField];
	return YES;
}

@end
