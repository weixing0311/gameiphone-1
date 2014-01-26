
#import <UIKit/UIKit.h>

@interface MLNavigationController : UINavigationController
{
    //UIPanGestureRecognizer *recognizer;
}
// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) UIPanGestureRecognizer *recognizer;
@property (nonatomic,assign) BOOL canDragBack;
-(void)setGestureEnableNO;
-(void)setGestureEnableYES;
@end

@interface UIViewController (MLNavigationControllerSupport)
@property(nonatomic, retain ,readonly) MLNavigationController *mlNavigationController;
@end