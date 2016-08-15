//
//  Theme.m
//

#import "Theme.h"
#import "AppDelegate.h"
#import "RefractometerController.h"


@implementation Theme

+ (void)setupColors:(BOOL)darkTheme {

    // Setting Navigation and TabBar
    [UINavigationBar appearance].barStyle = [self barStyle:darkTheme];
    [UINavigationBar appearance].barTintColor = [self barTintColor:darkTheme];
    [UINavigationBar appearance].titleTextAttributes =
        @{NSForegroundColorAttributeName: [self labelForegroundColor:darkTheme atLevel:0]};

    [UITabBar appearance].barTintColor = [self barTintColor:darkTheme];

    
    // Settings Tab
    [UITableView appearance].thmBackgroundColor = [self settingsBackgroundColor:darkTheme];
    [UITableView appearance].separatorColor = [self separatorColor:darkTheme atLevel:3];
    [UISlider appearance].thumbTintColor = [self settingsKnobColor:darkTheme];
    [UISwitch appearance].thumbTintColor = [self settingsKnobColor:darkTheme];
    [UISwitch appearance].onTintColor = [self onTintColor:darkTheme];

    [UITableViewCell appearance].selectedBackgroundView = [self settingsSelectedCellBackgroundView:darkTheme];
    [UITableViewCell appearance].thmBackgroundColor = [self settingsCellBackgroundColor:darkTheme];

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[UITableViewCell class]]].textColor = [self labelForegroundColor:darkTheme atLevel:0];

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[UITableViewHeaderFooterView class]]].textColor = [self labelForegroundColor:darkTheme atLevel:1];


    // Refractometer Tab
    [PrimaryLabel appearance].textColor = [self labelForegroundColor:darkTheme atLevel:0];
    [SecondaryLabel appearance].textColor = [self labelForegroundColor:darkTheme atLevel:1];

    [UIView appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].backgroundColor = [self displayBackgroundColor:darkTheme];

    [PrimarySeparator appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].backgroundColor = [self separatorColor:darkTheme atLevel:0];

    [SecondarySeparator appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].backgroundColor = [self separatorColor:darkTheme atLevel:1];

    [TertiarySeparator appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].backgroundColor = [self separatorColor:darkTheme atLevel:2];

    [UICollectionView appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].backgroundColor = [self inputBackgroundColor:darkTheme];

    [UICollectionReusableView appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].thmBackgroundColor = [self inputBackgroundColor:darkTheme];

    [VerticalRefractionNeedle appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].backgroundColor = [UIColor clearColor];

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].backgroundColor = [self inputBackgroundColor:darkTheme];
}


+ (UIColor *)labelForegroundColor:(BOOL)darkTheme atLevel:(int)level {

    switch (level) {
        case 0: return [UIColor colorWithWhite:(darkTheme ? 0.9f : 0.0f) alpha:1.0];
        case 1: return [UIColor colorWithWhite:(darkTheme ? 0.6f : 0.42f) alpha:1.0];
    }

    ALog(@"Unexpected level for label foreground color: %d", level);
    return [UIColor blackColor];
};


+ (UIColor *)separatorColor:(BOOL)darkTheme atLevel:(int)level {

    switch (level) {
        case 0: return [UIColor colorWithWhite:(darkTheme ? 0.27f : 0.86f) alpha:1.0];
        case 1: return [UIColor colorWithWhite:(darkTheme ? 0.22f : 0.91f) alpha:1.0];
        case 2: return [UIColor colorWithWhite:(darkTheme ? 0.3f  : 0.76f) alpha:1.0];

        case 3:
            if (darkTheme) {

                return [UIColor colorWithWhite:0.3f alpha:1.0f];
            }
            else {

                return [UIColor colorWithRed:0.784f green:0.78f blue:0.8f alpha:1.0f];
            }
    }

    ALog(@"Unexpected level for separator color: %d", level);
    return [UIColor blackColor];
};


+ (UIColor *)inputBackgroundColor:(BOOL)darkTheme {

    return [UIColor colorWithWhite:(darkTheme ? 0.15f : 1.0f) alpha:1.0];
}


+ (UIColor *)displayBackgroundColor:(BOOL)darkTheme {

    return [UIColor colorWithWhite:(darkTheme ? 0.2f : 0.96f) alpha:1.0];
}


+ (UIColor *)settingsBackgroundColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [self inputBackgroundColor:YES];
    }
    else {

        return [UIColor groupTableViewBackgroundColor];
    }
}


+ (UIColor *)settingsPopoverBackgroundColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [self displayBackgroundColor:YES];
    }
    else {

        return [UIColor groupTableViewBackgroundColor];
    }
}


+ (UIColor *)settingsCellBackgroundColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [self displayBackgroundColor:YES];
    }
    else {

        return [UIColor whiteColor];
    }
}


+ (UIView *)settingsSelectedCellBackgroundView:(BOOL)darkTheme {

    if (darkTheme) {

        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
        return view;
    }
    else {

        return nil;
    }
}


+ (UIColor *)settingsKnobColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [self labelForegroundColor:darkTheme atLevel:0];
    }
    else {

        return nil;
    }
}


+ (UIColor *)tintColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [UIColor colorWithRed:0.71 green:0.84 blue:0.20 alpha:1.0];
    }
    else {

        return [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
    }
}


+ (UIColor *)barTintColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [UIColor colorWithWhite:0.2f alpha:1.0f];
    }
    else {

        return [UIColor colorWithWhite:0.9725f alpha:1.0f];
    }
}


+ (UIColor *)onTintColor:(BOOL)darkTheme {

    if (darkTheme) {

        return [UIColor colorWithRed:0.498f green:0.58f blue:0.231f alpha:1.0f];
    }
    else {

        return nil;
    }

}


+ (UIStatusBarStyle)statusBarStyle:(BOOL)darkTheme {

    return (darkTheme ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
}


+ (UIBarStyle)barStyle:(BOOL)darkTheme {

    return (darkTheme ? UIBarStyleBlack : UIBarStyleDefault);
}

@end


#pragma mark Dummy Classes and UIAppearance Extensions


@implementation UITableView (Appearance)

- (UIColor *)thmBackgroundColor {

    return self.backgroundColor;
}


- (void)setThmBackgroundColor:(UIColor *)color {

    self.backgroundColor = color;
}

@end


@implementation UITableViewCell (Appearance)

- (UIColor *)thmBackgroundColor {

    return self.backgroundColor;
}


- (void)setThmBackgroundColor:(UIColor *)color {

    self.backgroundColor = color;
}

@end


@implementation UICollectionReusableView (Appearance)

- (UIColor *)thmBackgroundColor {

    return self.backgroundColor;
}


- (void)setThmBackgroundColor:(UIColor *)color {

    self.backgroundColor = color;
}

@end


@implementation PrimaryLabel

@end


@implementation SecondaryLabel

@end


@implementation PrimarySeparator

@end


@implementation SecondarySeparator

@end


@implementation TertiarySeparator

@end
