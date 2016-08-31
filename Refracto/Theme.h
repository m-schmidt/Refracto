//
//  Theme.h
//

@interface Theme : NSObject

+ (instancetype)sharedTheme;

// Property to select the currently active theme
@property (nonatomic) BOOL darkInterface;

// Foreground color for labels
- (UIColor *)labelColorLevel0;
- (UIColor *)labelColorLevel1;

// Colors for separator lines
- (UIColor *)separatorColorLevel0;
- (UIColor *)separatorColorLevel1;
- (UIColor *)separatorColorLevel2;
- (UIColor *)separatorColorTableView;

// Text attributes for navigation bar
- (NSDictionary *)titleTextAttributes;

// Background color for input area
- (UIColor *)inputBackgroundColor;

// Background color for display area
- (UIColor *)displayBackgroundColor;

// Background color for settings table view
- (UIColor *)settingsBackgroundColor;

// Background color for popover on iPad
- (UIColor *)settingsPopoverBackgroundColor;

// Background color for cells in settings table view
- (UIColor *)settingsCellBackgroundColor;

// View used as selection indicator in settings table view
- (UIView *)settingsSelectedCellBackgroundView;

// Color for slider knob in settings table view
- (UIColor *)settingsKnobColor;

// Global tint color
- (UIColor *)tintColor;

// Global tint color for navigation and tab bars
- (UIColor *)barTintColor;

// Global tint color for on state of switches
- (UIColor *)onTintColor;

// Status bar style for view controllers
- (UIStatusBarStyle)statusBarStyle;

// Bar style for navigation bars
- (UIBarStyle)barStyle;

// Image of settings button on ipad is theme dependend
- (UIImage *)settingsButtonImage;

@end


#pragma mark Dummy Classes and UIAppearance Extensions


@interface UIView (Appearance)<UIAppearance>

@property (strong, nonatomic) NSString *themeBackgroundColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeBarStyle UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeBarTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeOnTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeSelectedBackgroundView UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeSeparatorColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeThumbTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *themeTitleTextAttributes UI_APPEARANCE_SELECTOR;

@end


@interface Background : UIView

@end


@interface LabelL0 : UILabel

@end


@interface LabelL1 : UILabel

@end


@interface SeparatorL0 : UIView

@end


@interface SeparatorL1 : UIView

@end


@interface SeparatorL2 : UIView

@end


@interface LinkCell : UITableViewCell

@end
