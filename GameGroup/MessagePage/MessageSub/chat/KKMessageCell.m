//
//  KKMessageCell.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-16.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKMessageCell.h"

@implementation KKMessageCell

@synthesize senderAndTimeLabel;
@synthesize messageContentView;
@synthesize bgImageView;
@synthesize headImgV;
@synthesize headBtn,chattoHeadBtn;
@synthesize ifRead,playAudioImageV;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //日期标签
        self.backgroundColor = [UIColor clearColor];
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        //居中显示
        senderAndTimeLabel.backgroundColor = [UIColor clearColor];
        senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
        senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
        //文字颜色
        senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:senderAndTimeLabel];
        //背景图
        
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:headBtn];
        
        chattoHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chattoHeadBtn setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:chattoHeadBtn];
        
        headImgV = [[EGOImageView alloc] initWithFrame:CGRectZero];
        self.headImgV.layer.cornerRadius = 5;
        self.headImgV.layer.masksToBounds=YES;
        [self.contentView addSubview:headImgV];
        
        bgImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgImageView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        //  [bgImageView setAdjustsImageWhenHighlighted:NO];
        [self.contentView addSubview:bgImageView];
        
        //聊天信息
        messageContentView = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        messageContentView.backgroundColor = [UIColor clearColor];
        messageContentView.delegate = self;
//        messageContentView.backgroundColor = [UIColor clearColor];
//        //不可编辑
//        //        messageContentView.editable = NO;
//        //        messageContentView.scrollEnabled = NO;
//        [messageContentView setNumberOfLines:0];
//        [messageContentView setLineBreakMode:UILineBreakModeCharacterWrap];
//        [messageContentView setFont:[UIFont boldSystemFontOfSize:13]];
        // [messageContentView sizeToFit];
        [self.contentView addSubview:messageContentView];
        NSLog(@"fffff%f",self.frame.size.height);
        
//        self.ifRead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
//        [ifRead setImage:[UIImage imageNamed:@"redpot.png"]];
//        [self.contentView addSubview:self.ifRead];
        
        self.playAudioImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.playAudioImageV.animationDuration=1.0;
        self.playAudioImageV.animationRepeatCount=0;
        [self.contentView addSubview:self.playAudioImageV];

        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.hidesWhenStopped = YES;
        [self.contentView addSubview:self.activityView];
        
        self.failImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.failImage.image = KUIImage(@"fail_bg");
        [self.contentView addSubview:self.failImage];
    }
    
    return self;
}

- (void)refreshStatusPoint:(CGPoint)point status:(NSString*)status
{
    if ([status isEqualToString:@"0"]) {//失败
        self.failImage.frame = CGRectMake(point.x-12, point.y-12, 24, 24);
        self.failImage.hidden = NO;
        
        if ([self.cellTimer isValid]) {
            [self.cellTimer invalidate];
            self.cellTimer = nil;
        }
        [self.activityView stopAnimating];
    }
    else if([status isEqualToString:@"2"])//发送中
    {
        self.failImage.hidden = YES;

        if (![self.cellTimer isValid]) {
            self.cellTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopActivity) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.cellTimer forMode:NSRunLoopCommonModes];
            
            self.activityView.center = point;
            [self.activityView startAnimating];
        }
    }
    else
    {
        self.failImage.hidden = YES;
        if ([self.cellTimer isValid]) {
            [self.cellTimer invalidate];
            self.cellTimer = nil;
        }
        [self.activityView stopAnimating];
    }
}

- (void)stopActivity
{
    if ([self.cellTimer isValid]) {
        [self.cellTimer invalidate];
        self.cellTimer = nil;
    }
    [self.activityView stopAnimating];

//    if (self.kkDelegate && [self.kkDelegate respondsToSelector:@selector(stopActivityWithRow:)]) {
//        [self.kkDelegate stopActivityWithRow:self.cellRow];
//    }
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.messageuuid,@"src_id",@"0", @"received",[NSString stringWithFormat:@"%d", self.cellRow],@"row",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageAck object:nil userInfo:dic];
}

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
//	[self.visitedLinks addObject:objectForLinkInfo(linkInfo)];
	[attributedLabel setNeedsRecomputeLinksInText];
	
    if ([[UIApplication sharedApplication] canOpenURL:linkInfo.extendedURL])
    {
        // use default behavior
        return YES;
    }
    else
    {
        switch (linkInfo.resultType) {
            case NSTextCheckingTypeAddress:
                NSLog(@"%@",[linkInfo.addressComponents description]);
                break;
            case NSTextCheckingTypeDate:
                NSLog(@"%@",[linkInfo.date description]);
                break;
            case NSTextCheckingTypePhoneNumber:
                NSLog(@"%@",linkInfo.phoneNumber);
                break;
            default: {
//                NSString* message = [NSString stringWithFormat:@"You typed on an unknown link type (NSTextCheckingType %lld)",linkInfo.resultType];
//                [UIAlertView showWithTitle:@"Unknown link type" message:message];
                break;
            }
        }
        return NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"sss");
}



@end
