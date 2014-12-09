//
//  LoginViewController.m
//  FoodFlow
//
//  Created by Henrique Moraes on 13/11/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BackgroundLayer.h"

#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateInterface];
    //[self deleteDatabase];
    
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [self updateInterface];
    [super viewWillAppear:animated];
    //Add gradient background
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
}

- (void)updateInterface {
    PFUser *user = [PFUser currentUser];
    user && user[@"facebookID"] ? [self populateLoggedInInterface] : [self populateLoggedOffInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
    self.imageFood.hidden = !shouldHide;
    self.lblContinue.hidden = shouldHide;
    self.buttonLogin.hidden = !shouldHide;
}


-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{

    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    self.profilePicture.profileID = user.objectID;
    //self.lblUsername.text = user.name;
    NSString *status = @"You are logged in as ";
    self.lblLoginStatus.text = [status stringByAppendingString: user.name];
    self.lblEmail.text = [user objectForKey:@"email"];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged out";
    self.lblUsername.text = @"";
    self.profilePicture.profileID = nil;
    [self toggleHiddenState:YES];
}


// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self updateCurrentPFUser:user];
            
        }
    }];
}

- (void)updateCurrentPFUser:(PFUser*)user {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            user[@"name"] = userData[@"name"];
            user[@"gender"] = userData[@"gender"];
            
            user[@"facebookID"] = facebookID;
            user[@"image"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [user saveInBackground];
            [self populateLoggedInInterface];
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate setupPubNub];
        }
    }];
}

- (void)populateLoggedInInterface {
    PFUser *user = [PFUser currentUser];
    self.profilePicture.profileID = user[@"facebookID"];
    self.profilePicture.alpha = 1;
    NSString *status = @"You are logged in as ";
    self.lblLoginStatus.text = [status stringByAppendingString: user[@"name"]];
    
    [self toggleHiddenState:NO];
}

- (void)populateLoggedOffInterface {
    self.lblLoginStatus.text = @"You are logged out!";
    [self toggleHiddenState:YES];
}

- (void)deleteDatabase {
    PFQuery *user = [PFUser query];
    [user whereKeyExists:@"objectId"];
    [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self deleteAll:objects];
    }];
    
    PFQuery *conversation = [PFQuery queryWithClassName:@"Conversation"];
    [conversation whereKeyExists:@"objectId"];
    [conversation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self deleteAll:objects];
    }];
    
    PFQuery *message = [PFQuery queryWithClassName:@"PFMessage"];
    [message whereKeyExists:@"objectId"];
    [message findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self deleteAll:objects];
    }];
    
    PFQuery *transaction = [PFQuery queryWithClassName:@"Transaction"];
    [transaction whereKeyExists:@"objectId"];
    [transaction findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self deleteAll:objects];
    }];
    
}

- (void)deleteAll:(NSArray*)array {
    for (PFObject *object in array) {
        [object deleteInBackground];
    }
}

@end
