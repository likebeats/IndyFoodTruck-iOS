//
//  WebviewViewController.h
//  IndyFoodTrucks
//
//  Created by sj singh on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webview;

@property (nonatomic, strong) NSString *url;

@end
