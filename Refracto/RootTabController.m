//
//  RootTabController.m
//  Root View Controller for Custom Rotation
//


#import "RootTabController.h"


@implementation RootTabController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
