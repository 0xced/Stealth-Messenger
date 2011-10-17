//
//  AppDelegate.m
//  Stealth Messenger
//
//  Created by Cédric Luthi on 17.10.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "AppDelegate.h"

#import "MessageViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
