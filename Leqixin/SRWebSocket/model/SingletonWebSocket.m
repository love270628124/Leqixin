//
//  SingletonWebSocket.m
//  MySimpleProject
//
//  Created by Raija on 16/6/1.
//  Copyright © 2016年 Raija. All rights reserved.
//

#import "SingletonWebSocket.h"

@interface SingletonWebSocket () <SRWebSocketDelegate> {
    //
    SRWebSocket *srWebSocket;
    NSString *connectUrlString,*receiveMessage;
    NSDictionary *receiveMsgDict;
    NSTimer *aTimer,*bTimer;
    
}

@property (nonatomic,strong)AppDelegate *tempDelegate;

@end

@implementation SingletonWebSocket

#pragma mark - sender message

+ (void)senderMessageWithString:(NSString *)aMsg; {
    //
    [[SingletonWebSocket shareWebSocket] senderMessage:aMsg];
}

- (void)senderMessage:(id)msg {
    //
    if (srWebSocket) {
        //
        [srWebSocket send:msg];
    }
}

#pragma mark - receive message
//dictionary
+ (NSDictionary *)receivedMessageDictionary {
    //
    return [[SingletonWebSocket shareWebSocket] receiveMesssageDictionaryToMe];
}

- (NSDictionary *)receiveMesssageDictionaryToMe {
    //
    return receiveMsgDict;
}

- (NSDictionary *)receiveMessagedictionary:(NSDictionary *)aMessageDictionary {
    //
    receiveMsgDict = [[NSDictionary alloc] initWithDictionary:aMessageDictionary];
    return receiveMsgDict;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //
    NSLog(@"webSocket connected !");
    //定时发送心跳包给服务器，保持webSocket连接
    aTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendPing:) userInfo:nil repeats:YES];
    
    bTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(senderMessageToServer:) userInfo:nil repeats:YES];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    //
    NSLog(@"webSocket failed with error: %@",error);
    srWebSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //
//    NSLog(@"received:\"%@\"",message);
    //接收到的Json数据转化成字典
    NSDictionary *receiveDict = [self dictionaryWithJsonString:message];
    //根据服务器返回的staty字段判断发送通知接收数据
    switch ([receiveDict[@"staty"] intValue]) {
        case 0:
            //received sender success message
//            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSenderSuccessMessage
//                                                                object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSenderSuccessMessage object:nil userInfo:receiveDict];
            NSLog(@"received:\"%@\"",message);
            break;
            
        case 1:
            //received chat message
            [self receiveMessagedictionary:receiveDict];
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedChatMessage
                                                                object:nil];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedChatMessage object:nil userInfo:receiveDict];
            NSLog(@"received:\"%@\"",message);
            break;
            
        case -1:
            //received sender failed message
            [self receiveMessagedictionary:receiveDict];
            //
//            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSenderFailedMessage
//                                                                object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSenderFailedMessage object:nil userInfo:receiveDict];
            
            NSLog(@"received:\"%@\"",message);
            break;
            
        case -2:
            //received system message
//            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSystemMessage
//                                                                object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedSystemMessage object:nil userInfo:receiveDict];
            NSLog(@"received:\"%@\"",message);
            break;
            
        case -3:
            //received heartbeat message
            NSLog(@"received:\"%@\"",message);
            break;
            
        default:
            break;
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    //
    NSLog(@"webSocket closed !");
    srWebSocket = nil;
    [aTimer invalidate];
    [bTimer invalidate];
    
    [self reconnectServer];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    //
//    NSLog(@"webSocket received pong%@",pongPayload);
}

#pragma mark - SRWebSocket

+ (void)connectServerWithUrlStringAndUserId:(NSString *)urlAndId {
    //
    [[SingletonWebSocket shareWebSocket] connectServerWithURLString:urlAndId];
}

- (void)connectServerWithURLString:(NSString *)urlString {
    //通过 ws 协议
    if ([urlString rangeOfString:@"ws://"].location != NSNotFound) {
        connectUrlString = urlString;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        srWebSocket = [[SRWebSocket alloc] initWithURLRequest:request];
        srWebSocket.delegate = self;
        
        [srWebSocket open];
        NSLog(@"opening connection...");
        
    } else {
        //
        NSLog(@"please look at urlString !");
    }
}
//重新连接
- (void)reconnectServer {
    //cut off
    srWebSocket.delegate = nil;
    [srWebSocket close];
    //connect on
    [self connectServerWithURLString:connectUrlString];
}

+ (void)handCutOffConnectServer {
    //
    [[SingletonWebSocket shareWebSocket] handerCutOffConnectServer];
}

- (void)handerCutOffConnectServer {
    //
    srWebSocket.delegate = nil;
    [srWebSocket close];
    srWebSocket = nil;
    [aTimer invalidate];
    [bTimer invalidate];
    aTimer = nil;
    bTimer = nil;
}
//
- (void)sendPing:(id)sender {
    //keep heartbeat
    if (srWebSocket) {
        //
        [srWebSocket sendPing:nil];
    }
}

- (void)senderMessageToServer:(NSDictionary *)msgDict {
    //
    NSDictionary *hearbeatDict = @{@"nameid":@"",
                              @"id":[NSString stringWithFormat:@"%li",self.tempDelegate.userModel.userid],
                              @"itemid":@"",
                              @"type":@"-3",
                              @"msg":@""};
    NSString *msgString = [self dictionaryToJson:hearbeatDict];
    [SingletonWebSocket senderMessageWithString:msgString];
}

- (int)webSocketState {
    //
    return srWebSocket.readyState;
}

#pragma mark - object init

+ (instancetype)shareWebSocket {
    //
    static SingletonWebSocket *singleObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //
        singleObj = [[SingletonWebSocket alloc] init];
        
    });
    return singleObj;
}

- (instancetype)init {
    //
    self = [super init];
    if (self) {
        self.tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [self connectServerWithURLString:@"ws://61.155.215.16:8077/websocket/websocket?username=4123"];
    }
    return self;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    //
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
