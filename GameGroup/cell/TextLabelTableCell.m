//
//  TextLabelTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "TextLabelTableCell.h"

@implementation TextLabelTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.vAuthImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        self.vAuthImg.image = KUIImage(@"v_auth");
        [self addSubview:self.vAuthImg];
        self.vAuthImg.hidden = YES;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        self.nameLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self addSubview:self.nameLabel];
        
        self.disLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 190, 20)];
        self.disLabel.backgroundColor = [UIColor clearColor];
        self.disLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.disLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.disLabel.numberOfLines = 0;
        [self addSubview:self.disLabel];
        
        self.disField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 190, 20)];
        self.disField.textAlignment = NSTextAlignmentLeft;
        self.disField.backgroundColor = [UIColor clearColor];
        self.disField.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.disField.font = [UIFont boldSystemFontOfSize:14.0];
        self.disField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.disField];
        self.disField.hidden = YES;
        
        m_birthDayPick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        [m_birthDayPick setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        m_birthDayPick.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 280, 320, 236);
        m_birthDayPick.datePickerMode = UIDatePickerModeDate;
        m_birthDayPick.date = [[NSDate alloc] initWithTimeIntervalSince1970:631123200];
        m_birthDayPick.maximumDate = [NSDate date];
        self.disField.inputView = m_birthDayPick;//点击弹出的是pickview

        UIToolbar* toolbar_server = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbar_server.tintColor = [UIColor blackColor];
        UIBarButtonItem*rb_server = [[UIBarButtonItem alloc]initWithTitle:@"生日选择" style:UIBarButtonItemStyleDone target:self action:@selector(selectBirthdayOK)];
        UIBarButtonItem*cancel_server = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(selectBirthdayCancel)];
        rb_server.tintColor = [UIColor blackColor];
        toolbar_server.items = @[rb_server, cancel_server];
        self.disField.inputAccessoryView = toolbar_server;//跟着pickview上移
    }
    return self;
}

- (void)selectBirthdayCancel
{
    [self.disField resignFirstResponder];
}

- (void)selectBirthdayOK
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(birthDaySelected:)]) {
        [self.disField resignFirstResponder];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
        NSString* newDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: m_birthDayPick.date]];
        self.disField.text = newDate;
        
        [self.cellDelegate birthDaySelected:newDate];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
