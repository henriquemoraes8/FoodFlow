//
//  ChatViewController.m
//  FoodFlow
//
//  Created by Elder Yoshida on 12/8/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "ChatViewController.h"
#import <FacebookSDK/FacebookSDK.h>



@interface ChatViewController()
{
    PFUser* destinationUser;
    PFUser* currentUser;
    PFObject *currentConversation;
    NSString* defaultMsgSwitch;

    PNChannel* targetChannel;
    PNChannel* currentChannel;
    
    UIImage * currentProfilePic;

    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    
    NSMutableArray *bubbleData;
}
@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentUser = [PFUser currentUser];
    bubbleData = [NSMutableArray new];
    currentChannel = [PNChannel channelWithName:currentUser.objectId];
    //[PubNub subscribeOnChannel:currentChannel];
    
    [self sendDefaultMessage];

    self.navigationItem.title = [NSString stringWithFormat:@"Chat with %@", destinationUser[@"name"]];
    currentProfilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentUser[@"image"]]]];
    
    [self loadConversationAndMessages];
   
//    UIImage *target_profile = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:destinationUser[@"image"]]]];
    
   // NSString *convoChannel = [NSString stringWithFormat:@"%@_%@", current_user.objectId, destinationUser.objectId];
    currentChannel = [PNChannel channelWithName:currentUser.objectId];
    NSLog(@"Target channel is: %@\n\n", destinationUser.objectId);
    
    bubbleTable.bubbleDataSource = self;
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *message) {
        NSLog(@"OBSERVER: Channel: %@, Message: %@, Message: %@", message.channel.name, message.channelGroup.channels[0], message.message);
        if ([[message.message valueForKey:@"sender"] isEqualToString:destinationUser.objectId]){
        NSBubbleData *replyBubble = [NSBubbleData dataWithText:[message.message valueForKey:@"message"] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        PFObject *sender = [query getObjectWithId:[message.message valueForKey:@"sender"]];
        UIImage *sender_profile = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sender[@"image"]]]];
        replyBubble.avatar = sender_profile;
        [bubbleData addObject:replyBubble];
        [bubbleTable reloadData];
        }
    }];
    

//
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"user is %@", destinationUser.objectId);
}

- (void)loadConversationAndMessages {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"person1" equalTo:currentUser.objectId];
    [query1 whereKey:@"person2" equalTo:destinationUser.objectId];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"person2" equalTo:currentUser.objectId];
    [query2 whereKey:@"person1" equalTo:destinationUser.objectId];
    PFQuery *orQuery = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            currentConversation = objects[0];
        }
        [self loadPFMessages];
    }];
}

- (void)loadPFMessages {
    PFQuery *sender = [PFQuery queryWithClassName:@"PFMessage"];
    [sender whereKey:@"senderID" equalTo:currentUser.objectId];
    [sender whereKey:@"receiveID" equalTo:destinationUser.objectId];
    PFQuery *receiver = [PFQuery queryWithClassName:@"PFMessage"];
    [receiver whereKey:@"receiveID" equalTo:currentUser.objectId];
    [receiver whereKey:@"senderID" equalTo:destinationUser.objectId];
    PFQuery *orQuery = [PFQuery orQueryWithSubqueries:@[sender,receiver]];
    [orQuery orderByAscending:@"createdAt"];
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *message in objects) {
            BOOL iSent = [message[@"senderID"] isEqualToString:currentUser.objectId];
            NSBubbleData *bubble = [NSBubbleData dataWithText:message[@"content"] date:message.createdAt type:iSent ? BubbleTypeMine : BubbleTypeSomeoneElse];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iSent ? currentUser[@"image"] : destinationUser[@"image"]]]];
            bubble.avatar = image;
            [bubbleData addObject:bubble];
        }
        [bubbleTable reloadData];
        [bubbleTable layoutIfNeeded];
        [bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[bubbleTable numberOfRowsInSection:0]-1 inSection:[bubbleTable numberOfSections]-1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}


-(void) sendDefaultMessage{
    if ([defaultMsgSwitch isEqualToString:@"on"]){
    NSString* amount = currentUser[@"buyAmount"];
    NSString* location = currentUser[@"meetLocation"];
    
    NSString* msg = [NSString stringWithFormat:@"Hi %@! I wish to buy %@ food points from you at %@. Would you be available to meet?", destinationUser[@"name"], amount, location ];
    targetChannel = [PNChannel channelWithName:destinationUser.objectId shouldObservePresence:YES];
bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

NSBubbleData *sayBubble = [NSBubbleData dataWithText:msg date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
sayBubble.avatar = currentProfilePic;
//
//[bubbleData addObject:sayBubble];
//[bubbleTable reloadData];

PFObject *PFmessage = [PFObject objectWithClassName: @"PFMessage"];
    PFmessage[@"content"] = msg;
PFmessage[@"senderID"] = currentUser.objectId;
PFmessage[@"receiveID"] = destinationUser.objectId;
PFmessage[@"isSeen"] = @"false";
[PFmessage saveEventually];

//currentConversation[@"lastMessage"] = msg;
//[currentConversation saveInBackground];

        [PubNub sendMessage:@{@"message":msg,@"sender":currentUser.objectId} toChannel:targetChannel];
}

}


#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    targetChannel = [PNChannel channelWithName:destinationUser.objectId shouldObservePresence:YES];
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    sayBubble.avatar = currentProfilePic;

    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
    PFObject *PFmessage = [PFObject objectWithClassName: @"PFMessage"];
    PFmessage[@"content"] = textField.text;
    PFmessage[@"senderID"] = currentUser.objectId;
    PFmessage[@"receiveID"] = destinationUser.objectId;
    PFmessage[@"isSeen"] = @"false";
    [PFmessage saveEventually];
    NSLog(@"SAVED BY CHAT VIEW CONTROLLER: %@", textField.text);
    
    currentConversation[@"lastMessage"] = textField.text;
    [currentConversation saveInBackground];
    
    [PubNub sendMessage:@{@"message":textField.text,@"sender":currentUser.objectId} toChannel:targetChannel];
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:destinationUser.objectId];
    [push setMessage:textField.text];
    [push sendPushInBackground];
    textField.text = @"";
    [textField resignFirstResponder];

}

////(In AppDelegate.m, define didReceiveMessage delegate method:)
//- (void)pubnubClient:(PubNub *)client displayMessageFrom:(PNMessage *)message {
//    NSLog(@"Received IN ChatviewCONTROLLER: %@", message.message);
//    NSBubbleData *sayBubble = [NSBubbleData dataWithText:message.message date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
//    sayBubble.avatar = currentProfilePic;
//    
//    [bubbleData addObject:sayBubble];
//    [bubbleTable reloadData];
//    
//}

-(void) setDestinationUser:(PFUser *) user{
    destinationUser = user;
}

-(void) setDefaultMessageSwitch:(NSString *)on{
    defaultMsgSwitch = on;
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}


@end
