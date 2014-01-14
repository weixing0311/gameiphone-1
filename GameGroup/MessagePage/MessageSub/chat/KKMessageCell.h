//
//  KKMessageCell.h
//  XmppDemo
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
#import "OHAttributedLabel.h"
@interface KKMessageCell : UITableViewCell<OHAttributedLabelDelegate>


@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) OHAttributedLabel *messageContentView;
@property(nonatomic, retain) UIButton *bgImageView;
@property(nonatomic, retain) EGOImageView * headImgV;
@property(nonatomic, retain) UIButton * headBtn;
@property(nonatomic ,retain) UIButton * chattoHeadBtn;
@property(nonatomic ,retain) UIImageView * ifRead;
@property(nonatomic ,retain) UIImageView * playAudioImageV;

@end
