#import "CCAlertView.h"

NSString *const CCAlertViewDismissAllAlertsNotification = @"CCAlertViewDismissAllAlertsNotification";
NSString *const CCAlertViewAnimatedKey = @"CCAlertViewAnimated";

@interface CCAlertView () <UIAlertViewDelegate>
@property(strong) UIAlertView *alert;
@property(strong) NSMutableArray *blocks;
@property(strong) id keepInMemory;
@end

@implementation CCAlertView
@synthesize alert, blocks, dismissAction, keepInMemory;

+(CCAlertView *)alertWithBody:(NSString *)body title:(NSString *)title cancelTitle:(NSString *)cancelTitle {
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title message:body];
    [alert show];
    return alert;
}

+(CCAlertView *)alertWithBody:(NSString *)body cancelTitle:(NSString *)cancelTitle cancelBlock:(id)cancelBlock show:(BOOL)show{
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:@"" message:body];
    if (cancelBlock) [alert addButtonWithTitle:cancelTitle block:cancelBlock];
    [alert show];
    return alert;
}

- (id) initWithTitle: (NSString*) title message: (NSString*) message
{
    self = [super init];
    alert = [[UIAlertView alloc] initWithTitle:title message:message
        delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    blocks = [[NSMutableArray alloc] init];
    return self;
}

- (void) show
{
    if (blocks.count == 0) {
        [alert addButtonWithTitle:@"OK"];
    }
    [alert show];
    [self setKeepInMemory:self];
    [[NSNotificationCenter defaultCenter]
        addObserverForName:CCAlertViewDismissAllAlertsNotification
        object:nil queue:nil usingBlock:^(NSNotification *event) {
        id animated = [[event userInfo] objectForKey:CCAlertViewAnimatedKey];
        [self dismissAnimated:[animated boolValue]];
    }];
}

- (void) dismissAnimated: (BOOL) animated
{
    [alert dismissWithClickedButtonIndex:-1 animated:animated];
}

- (void) addButtonWithTitle: (NSString*) title block: (dispatch_block_t) block
{
    if (!block) block = ^{};
    [alert addButtonWithTitle:title];
    [blocks addObject:[block copy]];
}

- (void) alertView: (UIAlertView*) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex
{
    if (buttonIndex >= 0 && buttonIndex < [blocks count]) {
        dispatch_block_t block = [blocks objectAtIndex:buttonIndex];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
    if (dismissAction != NULL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dismissAction();
        });
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setKeepInMemory:nil];
}

@end
