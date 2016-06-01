//
//  RootTabController.m
//  Root View Controller for Custom Rotation on iPhone
//


#import "RootTabController.h"


@implementation RootTabController

// Always show status bar
- (BOOL)prefersStatusBarHidden {

    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
