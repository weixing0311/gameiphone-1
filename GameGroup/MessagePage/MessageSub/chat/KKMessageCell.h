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

@property(nonatomic, retain) NSTimer* cellTimer;//发送5秒
@property(nonatomic, retain) UIActivityIndicatorView *activityView;
@property(nonatomic, retain) UIButton* failImage;
@property(nonatomic, retain) UILabel*  statusLabel;//已读 送达
//@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, retain) NSString* messageuuid;

- (void)refreshStatusPoint:(CGPoint)point status:(NSString*)status;

@end
