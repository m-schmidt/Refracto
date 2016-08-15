//
//  Theme.h
//

@interface Theme : NSObject

+ (void)setupColors:(BOOL)darkTheme;

@end


@interface InfoLabel : UILabel

@end


@interface Separator : UIView

@end


@interface UITableView (Appearance)<UIAppearance>

@property (strong, nonatomic) UIColor *thmBackgroundColor UI_APPEARANCE_SELECTOR;

@end


@interface UITableViewCell (Appearance)<UIAppearance>

@property (strong, nonatomic) UIColor *thmBackgroundColor UI_APPEARANCE_SELECTOR;

@end
