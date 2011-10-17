//
//  MessageViewController.h
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

@interface MessageViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITextView *textView;
@property (nonatomic, assign) IBOutlet UILabel *recipientLabel;
@property (nonatomic, assign) IBOutlet UITextField *recipientField;

- (IBAction) changeMessageKind:(id)sender;
- (IBAction) sendMessage:(id)sender;

@end
