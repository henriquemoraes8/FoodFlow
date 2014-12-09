//
//  AppDelegate.m
//  FoodFlow
//
//  Created by Henrique Moraes on 11/11/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    [FBProfilePictureView class];
    [Parse setApplicationId:@"Mfd50KnlM4lq6j7fyhTGjI5a1xv3hLaBA8kxAdlJ"
                  clientKey:@"qNnpR8AjpBFh2xVvUNTLu5Pbzwhctn4NWjjLmx1e"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    [PubNub setDelegate:self]; // Add This Line

    // #1 Define client configuration
    PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                                             publishKey:@"pub-c-ce22dcca-bf1f-4886-9d51-689155232984"
                                                           subscribeKey:@"sub-c-f5e6aa62-7f0b-11e4-812f-02ee2ddab7fe"
                                                              secretKey:nil];
    // #2 make the configuration active
    [PubNub setConfiguration:myConfig];
    // #3 Connect to the PubNub
    [PubNub connect];
    
    // #4 Add observer to look for connection events
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
        }
        else if (!connected || connectionError)
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
        }
    }];
    return YES;
}

//(In AppDelegate.m, define didReceiveMessage delegate method:)
- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog(@"Received IN APP DELEGATE: %@", message.message);
    if (message.message){
        PFObject *PFmessage = [PFObject objectWithClassName: @"PFMessage"];
        PFmessage[@"content"] = [message.message valueForKey:@"message"];
        PFmessage[@"senderID"] = [message.message valueForKey:@"sender"];
        PFmessage[@"receiveID"] = [message.message valueForKey:@"sender"];
        PFmessage[@"isSeen"] = @"false";
        NSLog(@"SAVED BY APP DELEGATE: %@", message.message);

    }
}

- (void)pubnubClient:(PubNub *)client didSubscribeOnChannels:(NSArray *)channels {
    NSLog(@"DELEGATE: Subscribed to channel:%@", channels);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

@end
