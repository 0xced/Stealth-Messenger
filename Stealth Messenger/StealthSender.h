//
//  StealthSender.h
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StealthSender : NSObject

- (id) initWithComposeViewController:(UIViewController *)composeViewController;

- (void) sendWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
