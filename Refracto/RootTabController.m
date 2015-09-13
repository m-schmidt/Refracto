//
//  RootTabController.m
//  Root View Controller for Custom Rotation on iPhone
//


#import "RootTabController.h"


@implementation RootTabController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
