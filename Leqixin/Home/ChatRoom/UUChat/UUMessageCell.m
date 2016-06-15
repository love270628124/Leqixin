//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UUImageAvatarBrowser.h"
#import "KZLinkLabel.h"

@interface UUMessageCell ()<UUAVAudioPlayerDelegate,UIActionSheetDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UUAVAudioPlayer *audio;
    
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
    
}

@property (nonatomic,strong)AppDelegate *tempDelegate;

@property (nonatomic, strong)KZLinkLabel *kzLabel;

@property (nonatomic,strong) NSDictionary *selectedLinkDic;

@end

@implementation UUMessageCell
-(AppDelegate *)tempDelegate
{
    if (_tempDelegate == nil) {
        _tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _tempDelegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
//        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 10;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 10;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.adjustsFontSizeToFitWidth = YES;
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        self.kzLabel = [[KZLinkLabel alloc] init];
        self.kzLabel.automaticLinkDetectionEnabled = YES;
        self.kzLabel.textAlignment  = NSTextAlignmentCenter;
        self.kzLabel.font = ChatContentFont;
        self.kzLabel.textColor = [UIColor blackColor];
        self.kzLabel.backgroundColor = [UIColor clearColor];
        self.kzLabel.numberOfLines = 0;
        self.kzLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.kzLabel sizeToFit];
        self.kzLabel.linkColor = [UIColor blueColor];
        self.kzLabel.linkHighlightColor = [UIColor orangeColor];
        [self.btnContent addSubview:self.kzLabel];
        
        __weak typeof(self) weakSelf = self;
        self.kzLabel.linkTapHandler = ^(KZLinkType linkType, NSString *string, NSRange range){
            if (linkType == KZLinkTypeURL) {
                [weakSelf openURL:[NSURL URLWithString:string]];
            } else if (linkType == KZLinkTypePhoneNumber) {
                [weakSelf openTel:string];
            } else {
                NSLog(@"Other Link");
            }
        };
        self.kzLabel.linkLongPressHandler = ^(KZLinkType linkType, NSString *string, NSRange range){
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            
            NSMutableDictionary *linkDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
            [linkDictionary setObject:@(linkType) forKey:@"linkType"];
            [linkDictionary setObject:string forKey:@"link"];
            [linkDictionary setObject:[NSValue valueWithRange:range] forKey:@"range"];
            weakSelf.selectedLinkDic = linkDictionary;
            NSString *openTypeString;
            if (linkType == KZLinkTypeURL) {
                openTypeString = @"在Safari中打开";
            } else if (linkType == KZLinkTypePhoneNumber) {
                openTypeString = @"直接拨打";
            }
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:weakSelf
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"拷贝",openTypeString, nil];
            [sheet showInView:weakSelf];
        };
        //label点击
//        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
//        [self.kzLabel addGestureRecognizer:labelTapGestureRecognizer];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside:)];
        [self.kzLabel addGestureRecognizer:longPress];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        contentVoiceIsPlaying = NO;

    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}


- (void)btnContentClick{
    //play audio
    if (self.messageFrame.message.type == UUMessageTypeVoice) {
        if(!contentVoiceIsPlaying){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            contentVoiceIsPlaying = YES;
            audio = [UUAVAudioPlayer sharedInstance];
            audio.delegate = self;
            //        [audio playSongWithUrl:voiceURL];
            [audio playSongWithData:songData];
        }else{
            [self UUAVAudioPlayerDidFinishPlay];
        }
    }
    //show the picture
    else if (self.messageFrame.message.type == UUMessageTypePicture)
    {
        if (self.btnContent.backImageView) {
            [UUImageAvatarBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.type == UUMessageTypeText)
    {
        [self.btnContent setTitle:self.kzLabel.text forState:UIControlStateNormal];
        [self.btnContent setTitleColor:[UIColor colorWithWhite:0 alpha:0] forState:0];
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}


//内容及Frame设置
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    UUMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    
    // 3、设置下标
    self.labelNum.text = message.strName;
    if (messageFrame.nameF.origin.x > 160) {
        
//        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.strIcon]];
//        [self.btnHeadImage setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
        [self.btnHeadImage setBackgroundImage:self.tempDelegate.meIconImage forState:UIControlStateNormal];
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.frame = CGRectMake(CGRectGetMaxX(messageFrame.iconF)-messageFrame.iconF.size.width, messageFrame.nameF.origin.y+5, messageFrame.iconF.size.width, messageFrame.nameF.size.height);
        
        self.labelNum.textAlignment = NSTextAlignmentCenter;
    }else{
        
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:@"icon_moren-tx"] forState:0];
        
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 5, 80, messageFrame.nameF.size.height);
         self.labelNum.frame = CGRectMake(messageFrame.iconF.origin.x, messageFrame.nameF.origin.y + 5, messageFrame.iconF.size.width, messageFrame.nameF.size.height);
        
        self.labelNum.textAlignment = NSTextAlignmentCenter;
    }

    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;

    self.btnContent.frame = messageFrame.contentF;
    
    if (message.from == UUMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
        self.kzLabel.textColor = [UIColor whiteColor];//ChatContentTop;- ChatContentRight - 5
//        self.kzLabel.frame = CGRectMake(ChatContentLeft, 0, CGRectGetWidth(self.btnContent.frame) , CGRectGetHeight(self.btnContent.frame));
        
        
        self.kzLabel.frame = CGRectMake(5, 0, CGRectGetWidth(self.btnContent.frame) - ChatContentTop, CGRectGetHeight(self.btnContent.frame));
        

        
    }else{
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
        self.kzLabel.textColor = [UIColor blackColor];
//        self.kzLabel.frame = CGRectMake(ChatContentTop + 5, 0, CGRectGetWidth(self.btnContent.frame) - ChatContentBottom - 10, CGRectGetHeight(self.btnContent.frame));
        self.kzLabel.frame = CGRectMake(ChatContentTop, 0, CGRectGetWidth(self.btnContent.frame) - ChatContentTop - 5, CGRectGetHeight(self.btnContent.frame));
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatto_bg_default"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];

    NSAttributedString *attributedString = [[NSAttributedString alloc] init];
    if (message.type == UUMessageTypeText) {
        NSString *emojiString = message.strContent;
        NSDictionary *attributes = @{NSFontAttributeName: ChatContentFont};
        attributedString = [NSAttributedString emotionAttributedStringFrom:emojiString attributes:attributes];
    }
    
    switch (message.type) {
        case UUMessageTypeText:
//            [self.btnContent setTitle:message.strContent forState:UIControlStateNormal];
            
             self.kzLabel.attributedText = attributedString;
            
            break;
        case UUMessageTypePicture:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.backImageView.image = message.picture;
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case UUMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",message.strVoiceTime];
            songData = message.voice;
//            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
        }
            break;
            
        default:
            break;
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (BOOL)openURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)openTel:(NSString *)tel
{
    NSString *telString = [NSString stringWithFormat:@"tel://%@",tel];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!self.selectedLinkDic) {
        return;
    }
    switch (buttonIndex)
    {
        case 0:
        {
            [UIPasteboard generalPasteboard].string = self.selectedLinkDic[@"link"];
            break;
        }
        case 1:
        {
            KZLinkType linkType = [self.selectedLinkDic[@"linkType"] integerValue];
            if (linkType == KZLinkTypeURL) {
                NSURL *url = [NSURL URLWithString:self.selectedLinkDic[@"link"]];
                [self openURL:url];
            } else if (linkType == KZLinkTypePhoneNumber) {
                [self openTel:self.selectedLinkDic[@"link"]];
            }
            break;
        }
    }
}

-(void) labelTouchUpInside:(UILongPressGestureRecognizer *)recognizer{
    
    //    UILabel *label=(UILabel*)recognizer.view;
    //    NSLog(@"%@被点击了",label.text);
    //借助button点击事件实现copy功能
    [self btnContentClick];
}

@end



