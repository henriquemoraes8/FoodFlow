//
//  ChatListViewController.m
//  FoodFlow
//
//  Created by Elder Yoshida on 12/8/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListViewCell.h"
@interface ChatListViewController() {
    NSMutableDictionary *chatViewControllerDic;
}
@end

@implementation ChatListViewController


- (UIViewController *) getChatViewController:(PFUser *)user{
    if(chatViewControllerDic == nil){
        chatViewControllerDic = [NSMutableDictionary dictionary];
    }
    
    ChatViewController* chat = nil;
    if((chat = [chatViewControllerDic objectForKey: user.objectId]) == nil ){
        chat = [[ChatViewController alloc] init];
        chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        [chat setDestinationUser:user];
        [chatViewControllerDic setObject:chat forKey:user.objectId];
    }
    return chat;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatViewControllerDic count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ChatListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    

    
    return cell;
}

@end
