extern NSString *const CCAlertViewDismissAllAlertsNotification;
extern NSString *const CCAlertViewAnimatedKey;

@interface CCAlertView : NSObject

@property(copy) dispatch_block_t dismissAction;

- (id) initWithTitle: (NSString*) title message: (NSString*) message;
- (void) addButtonWithTitle: (NSString*) title block: (dispatch_block_t) block;

- (void) show;
- (void) dismissAnimated: (BOOL) animated;

+(CCAlertView *)alertWithBody:(NSString *)body title:(NSString *)title cancelTitle:(NSString *)cancelTitle;
+(CCAlertView*)alertWithBody:(NSString*)body cancelTitle:(NSString*)cancelTitle cancelBlock:(id)cancelBlock show:(BOOL)show;

@end
