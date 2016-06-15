//
//  SingletonWebSocket.h
//  MySimpleProject
//
//  Created by Raija on 16/6/1.
//  Copyright © 2016年 Raija. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SRWebSocket.h"

#define ReceivedChatMessage             @"ReceivedChatMessage"          //接收到聊天内容的信息
#define ReceivedSystemMessage           @"ReceivedSystemMessage"        //接收到系统返回的信息
#define ReceivedSenderFailedMessage     @"ReceivedSenderFailedMessage"  //接收到发送失败的信息
#define ReceivedSenderSuccessMessage    @"ReceivedSenderSuccessMessage" //接收到发送成功的信息
#define ReceivedUnReadMessage           @"ReceivedUnReadMessage"        //接收到未读消息的信息

@interface SingletonWebSocket : NSObject

+ (instancetype)shareWebSocket;

/*发送聊天信息给服务器*/
+ (void)senderMessageWithString:(NSString *)aMsg;

/*接收到服务器返回的信息*/
+ (NSDictionary *)receivedMessageDictionary;

/*手动断开与服务器的连接*/
+ (void)handCutOffConnectServer;

/*连接服务器 ws 协议*/
+ (void)connectServerWithUrlStringAndUserId:(NSString *)urlAndId;

- (int)webSocketState;

@end
