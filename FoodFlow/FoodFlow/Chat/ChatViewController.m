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
    
    PFUser *current_user = [PFUser currentUser];

    self.navigationItem.title = [NSString stringWithFormat:@"Chat with %@", destinationUser[@"name"]];
    currentProfilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current_user[@"image"]]]];
   
//    UIImage *target_profile = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:destinationUser[@"image"]]]];
    
   // NSString *convoChannel = [NSString stringWithFormat:@"%@_%@", current_user.objectId, destinationUser.objectId];
    currentChannel = [PNChannel channelWithName:current_user.objectId];
    targetChannel = [PNChannel channelWithName:destinationUser.objectId];
    
    [PubNub subscribeOnChannel:currentChannel];
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *message) {
        NSLog(@"OBSERVER: Channel: %@, Message: %@", message.channel.name, message.message);
        NSBubbleData *replyBubble = [NSBubbleData dataWithText:message.message date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
        replyBubble.avatar = currentProfilePic;
        
        [bubbleData addObject:replyBubble];
        [bubbleTable reloadData];

    }];
    

    bubbleData = [[NSMutableArray alloc] initWithObjects:nil];
    bubbleTable.bubbleDataSource = self;
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}



#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    sayBubble.avatar = currentProfilePic;

    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    [PubNub sendMessage:textField.text toChannel:targetChannel];
    textField.text = @"";
    [textField resignFirstResponder];
}

//(In AppDelegate.m, define didReceiveMessage delegate method:)
- (void)pubnubClient:(PubNub *)client displayMessageFrom:(PNMessage *)message {
    NSLog(@"Received IN CHatviewCONTROLLER: %@", message.message);
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:message.message date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
    sayBubble.avatar = currentProfilePic;
    
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
}

-(void) setDestinationUser:(PFUser *) user{
    destinationUser = user;
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
