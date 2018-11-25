//
//  Theme.m
//

#import "Theme.h"
#import "RefractometerController.h"
#import "AppDelegate.h"


@interface Theme (private)

// Called once to setup UIAppearance proxies
- (void)installAppearance;

// Called by custom UIAppearance-properties to set target properties to values of current theme
- (void)setObjValueNamed:(NSString *)getterName forProperty:(SEL)setter ofTarget:(UIView *)target;
- (void)setIntValueNamed:(NSString *)getterName forProperty:(SEL)setter ofTarget:(UIView *)target;

@end


@implementation Theme


#pragma mark Theme Setup


+ (instancetype)sharedTheme {

    static Theme *sharedInstance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{

        sharedInstance = [[self alloc] init];
        sharedInstance.darkInterface = [AppDelegate appDelegate].darkInterface;

        [sharedInstance installAppearance];
    });

    return sharedInstance;
}


- (void)setObjValueNamed:(NSString *)getterName forProperty:(SEL)setter ofTarget:(UIView *)target  {

    if ([target respondsToSelector:setter]) {

        // Get object value
        SEL getter = NSSelectorFromString(getterName);
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:getter]];
        [invocation setTarget:self];
        [invocation setSelector:getter];
        [invocation invoke];

        id __unsafe_unretained tmpValue = nil;
        [invocation getReturnValue:&tmpValue];
        id value = tmpValue;

        // Set object value at target
        invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:setter]];
        [invocation setTarget:target];
        [invocation setSelector:setter];
        [invocation setArgument:&value atIndex:2];
        [invocation invoke];
    }
}


- (void)setIntValueNamed:(NSString *)getterName forProperty:(SEL)setter ofTarget:(UIView *)target  {

    if ([target respondsToSelector:setter]) {

        // Get integer value
        SEL getter = NSSelectorFromString(getterName);
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:getter]];
        [invocation setTarget:self];
        [invocation setSelector:getter];
        [invocation invoke];

        NSInteger value = 0;
        [invocation getReturnValue:&value];

        // Set integer value at target
        invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:setter]];
        [invocation setTarget:target];
        [invocation setSelector:setter];
        [invocation setArgument:&value atIndex:2];
        [invocation invoke];
    }
}


- (void)installAppearance {

    [UINavigationBar appearance].themeBarStyle = @"barStyle";
    [UINavigationBar appearance].themeBarTintColor = @"barTintColor";
    [UINavigationBar appearance].themeTitleTextAttributes = @"titleTextAttributes";

    [UITabBar appearance].themeBarTintColor = @"barTintColor";

    [UITableView appearance].themeBackgroundColor = @"settingsBackgroundColor";
    [UITableView appearance].themeSeparatorColor = @"separatorColorTableView";

    [UISlider appearance].themeThumbTintColor = @"settingsKnobColor";

    [UISwitch appearance].themeThumbTintColor = @"settingsKnobColor";
    [UISwitch appearance].themeOnTintColor = @"onTintColor";

    [UITableViewCell appearance].themeSelectedBackgroundView = @"settingsSelectedCellBackgroundView";
    [UITableViewCell appearance].themeBackgroundColor = @"settingsCellBackgroundColor";

    [UIView appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerDisplayController class]]].themeBackgroundColor = @"displayBackgroundColor";

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[UITableViewCell class]]].themeTextColor = @"labelColorLevel0";

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[LinkCell class]]].themeTextColor = @"tintColor";

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[UITableViewHeaderFooterView class]]].themeTextColor = @"labelColorLevel1";

    [UILabel appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].themeBackgroundColor = @"inputBackgroundColor";

    [LabelL0 appearance].themeTextColor = @"labelColorLevel0";
    [LabelL1 appearance].themeTextColor = @"labelColorLevel1";

    [Background appearance].themeBackgroundColor = @"displayBackgroundColor";
    [BackgroundBottom appearance].themeBackgroundColor = @"inputBackgroundColor";

    [SeparatorL0 appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].themeBackgroundColor = @"separatorColorLevel0";

    [SeparatorL1 appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].themeBackgroundColor = @"separatorColorLevel1";

    [SeparatorL2 appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerController class]]].themeBackgroundColor = @"separatorColorLevel2";

    [VerticalRefractionPicker appearance].themeBackgroundColor = @"inputBackgroundColor";

    [UICollectionView appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].themeBackgroundColor = @"inputBackgroundColor";

    [UICollectionViewCell appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].themeBackgroundColor = @"inputBackgroundColor";

    [VerticalRefractionNeedle appearanceWhenContainedInInstancesOfClasses:
        @[[RefractometerInputController class], [RefractometerController class]]].backgroundColor = [UIColor clearColor];

    [UIView appearanceWhenContainedInInstancesOfClasses:
        @[[UIButton class], [RefractometerController class]]].themeBackgroundColor = @"inputBackgroundColor";
}


#pragma mark Accessors for Theme Values


- (UIColor *)labelColorLevel0 {

    return [UIColor colorWithWhite:(_darkInterface ? 0.95f : 0.0f) alpha:1.0];
}


- (UIColor *)labelColorLevel1 {

    return [UIColor colorWithWhite:(_darkInterface ? 0.55f : 0.42f) alpha:1.0];
}


- (UIColor *)separatorColorLevel0 {

    return [UIColor colorWithWhite:(_darkInterface ? 0.32f : 0.86f) alpha:1.0];
}


- (UIColor *)separatorColorLevel1 {

    return [UIColor colorWithWhite:(_darkInterface ? 0.29f : 0.91f) alpha:1.0];
}


- (UIColor *)separatorColorLevel2 {

    return [UIColor colorWithWhite:(_darkInterface ? 0.38f : 0.76f) alpha:1.0];
}


- (NSDictionary *)titleTextAttributes {

    return @{NSForegroundColorAttributeName: [self labelColorLevel0]};
}


- (UIColor *)separatorColorTableView {

    if (_darkInterface) {

        return [UIColor colorWithWhite:0.38f alpha:1.0f];
    }
    else {

        return [UIColor colorWithRed:0.784f green:0.78f blue:0.8f alpha:1.0f];
    }
}


- (UIColor *)inputBackgroundColor {

    return [UIColor colorWithWhite:(_darkInterface ? 0.2f : 1.0f) alpha:1.0];
}


- (UIColor *)displayBackgroundColor {

    return [UIColor colorWithWhite:(_darkInterface ? 0.251f : 0.96f) alpha:1.0];
}


- (UIColor *)settingsBackgroundColor {

    if (_darkInterface) {

        return [self inputBackgroundColor];
    }
    else {

        return [UIColor groupTableViewBackgroundColor];
    }
}


- (UIColor *)settingsPopoverBackgroundColor {

    if (_darkInterface) {

        return [self displayBackgroundColor];
    }
    else {

        return [UIColor groupTableViewBackgroundColor];
    }
}


- (UIColor *)settingsCellBackgroundColor {

    if (_darkInterface) {

        return [self displayBackgroundColor];
    }
    else {

        return [UIColor whiteColor];
    }
}


- (UIView *)settingsSelectedCellBackgroundView {

    if (_darkInterface) {

        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.38f alpha:1.0f];
        return view;
    }
    else {

        return nil;
    }
}


- (UIColor *)settingsKnobColor {

    if (_darkInterface) {

        return [self labelColorLevel0];
    }
    else {

        return nil;
    }
}


- (UIColor *)systemTintColor {

    UIColor *systemTintColor = [[UIView alloc] init].tintColor;

    // Catch nil, since the color is needed as text attribute value
    if (systemTintColor == nil) {
        systemTintColor = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
    }

    return systemTintColor;
}


- (UIColor *)tintColor {

    if (_darkInterface) {

        return [UIColor colorWithRed:0.71 green:0.84 blue:0.20 alpha:1.0];
    }
    else {

        return self.systemTintColor;
    }
}


- (UIColor *)barTintColor {

    if (_darkInterface) {

        return [UIColor colorWithWhite:0.2f alpha:1.0f];
    }
    else {

        return [UIColor colorWithWhite:0.9725f alpha:1.0f];
    }
}


- (UIColor *)onTintColor {

    if (_darkInterface) {

        return [UIColor colorWithRed:0.498f green:0.58f blue:0.231f alpha:1.0f];
    }
    else {

        return nil;
    }

}


- (UIStatusBarStyle)statusBarStyle {

    return (_darkInterface ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
}


- (UIBarStyle)barStyle {

    return (_darkInterface ? UIBarStyleBlack : UIBarStyleDefault);
}


- (UIImage *)settingsButtonImage {

    return [UIImage imageNamed:_darkInterface ? @"SettingsOutlinedDark" : @"SettingsOutlined"];
}

@end


#pragma mark Dummy Classes and UIAppearance Extensions


@implementation UIView (Appearance)

- (NSString *)themeBackgroundColor {

    return @"";
}


- (void)setThemeBackgroundColor:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setBackgroundColor:) ofTarget:self];
}


- (NSString *)themeBarStyle {

    return @"";
}


- (void)setThemeBarStyle:(NSString *)getterName {

    [[Theme sharedTheme] setIntValueNamed:getterName forProperty:@selector(setBarStyle:) ofTarget:self];
}


- (NSString *)themeBarTintColor {

    return @"";
}


- (void)setThemeBarTintColor:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setBarTintColor:) ofTarget:self];
}


- (NSString *)themeOnTintColor {

    return @"";
}


- (void)setThemeOnTintColor:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setOnTintColor:) ofTarget:self];
}


- (NSString *)themeSelectedBackgroundView {

    return @"";
}


- (void)setThemeSelectedBackgroundView:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setSelectedBackgroundView:) ofTarget:self];
}


- (NSString *)themeSeparatorColor {

    return @"";
}


- (void)setThemeSeparatorColor:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setSeparatorColor:) ofTarget:self];
}


- (NSString *)themeTextColor {

    return @"";
}


- (void)setThemeTextColor:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setTextColor:) ofTarget:self];
}


- (NSString *)themeThumbTintColor {

    return @"";
}


- (void)setThemeThumbTintColor:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setThumbTintColor:) ofTarget:self];
}


- (NSString *)themeTitleTextAttributes {

    return @"";
}


- (void)setThemeTitleTextAttributes:(NSString *)getterName {

    [[Theme sharedTheme] setObjValueNamed:getterName forProperty:@selector(setTitleTextAttributes:) ofTarget:self];
}

@end


@implementation Background

@end


@implementation BackgroundBottom

@end


@implementation LabelL0

@end


@implementation LabelL1

@end


@implementation SeparatorL0

@end


@implementation SeparatorL1

@end


@implementation SeparatorL2

@end


@implementation LinkCell

@end
