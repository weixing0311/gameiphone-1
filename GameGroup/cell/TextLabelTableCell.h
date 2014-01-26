//
//  TextLabelTableCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BirthDayDelegate <NSObject>

- (void)birthDaySelected:(NSString*)birthday;

@end

@interface TextLabelTableCell : UITableViewCell
{
    UIDatePicker* m_birthDayPick;
}
@property (assign,nonatomic)id<BirthDayDelegate> cellDelegate;
@property (strong,nonatomic)UIImageView* vAuthImg;
@property (strong,nonatomic)UILabel*  nameLabel;
@property (strong,nonatomic)UILabel*  disLabel;
@property (strong,nonatomic)UITextField*  disField;

@end
