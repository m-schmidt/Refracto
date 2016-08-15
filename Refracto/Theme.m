//
//  Theme.m
//

#import "Theme.h"
#import "AppDelegate.h"
#import "HorizontalModePicker.h"
#import "RefractometerController.h"
#import "VerticalRefractionSupplementaryView.h"
#import "VerticalRefractionPicker.h"
#import "SettingsController.h"
#import "SliderCell.h"


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


@implementation Theme

+ (UIColor *)tintColor:(BOOL)darkTheme {

    return darkTheme ? [UIColor colorWithRed:0.71 green:0.84 blue:0.20 alpha:1.0]     // greenish yellow
                     : [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];  // standard blue
}


+ (void)setupColors:(BOOL)darkTheme {

    // Color schemes
    UIColor *tint,                 // application tint color
            *background,           // main background color
            *background_2,         // second background color, e.g. for display area
            *background_3,         // third background color, e.g. for separator lines
            *background_4,         // third background color, e.g. for separator lines
            *background_table,     // table view background
            *label,                // main label color
            *label_info;           // slightly weaker color for information labels

//    if (darkTheme) {

        tint             = [UIColor colorWithRed:0.71 green:0.84 blue:0.20 alpha:1.0];
        background       = [UIColor colorWithWhite:0.09 alpha:1.0];
        background_2     = [UIColor colorWithWhite:0.11 alpha:1.0];
        background_3     = [UIColor colorWithWhite:0.14 alpha:1.0];
        background_4     = [UIColor colorWithWhite:0.14 alpha:1.0];
        background_table = background;
        label            = [UIColor colorWithWhite:0.6 alpha:1.0];
        label_info       = [UIColor colorWithWhite:0.31 alpha:1.0];
//    }
//    else {
//
//        tint             = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
//        background       = [UIColor whiteColor];
//        background_2     = [UIColor colorWithWhite:0.97 alpha:1.0];
//        background_3     = [UIColor colorWithWhite:0.91 alpha:1.0];
//        background_4     = [UIColor colorWithWhite:0.94 alpha:1.0];
//        background_table = [UIColor groupTableViewBackgroundColor];
//        label            = [UIColor blackColor];
//        label_info       = [UIColor colorWithWhite:0.75 alpha:1.0];
//
//    }

    // Toplevel
    [UINavigationBar appearance].barTintColor = background_2;
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:label forKey:NSForegroundColorAttributeName];
    [UITabBar appearance].barTintColor = background_2;

    // Settings
    [UITableView appearance].thmBackgroundColor = background_table;
    [UITableView appearance].separatorColor = background_3;
    [UITableViewCell appearance].thmBackgroundColor = background_2;

    [UILabel appearanceWhenContainedIn:[UITableViewCell class], nil].textColor = label;
    [UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil].textColor = label_info;

    // Refractometer
    [UIView appearanceWhenContainedIn:[RefractometerDisplayController class], nil].backgroundColor = background_2;
    [UIView appearanceWhenContainedIn:[RefractometerInputController class], nil].backgroundColor = background;
    [UILabel appearanceWhenContainedIn:[RefractometerController class], nil].textColor = label;
    //    [InfoLabel appearanceWhenContainedIn:[RefractometerController class], nil].textColor = label_info;
    //    [Separator appearanceWhenContainedIn:[RefractometerDisplayController class], nil].backgroundColor = background_3;
    //    [Separator appearanceWhenContainedIn:[UIView class], [UIView class], [RefractometerDisplayController class], nil].backgroundColor = background_4;
    //    [VerticalRefractionNeedle appearanceWhenContainedIn:[VerticalRefractionPicker class], [RefractometerInputController class], nil].backgroundColor = [UIColor clearColor];
}

@end


@implementation InfoLabel

@end


@implementation Separator

@end
