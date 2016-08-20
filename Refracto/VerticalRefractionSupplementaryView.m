//
//  VerticalRefractionSuplementaryView.m
//  Custom Supplementary View for Tick Labels in Refraction Selectors
//


#import "AppDelegate.h"
#import "VerticalRefractionSupplementaryView.h"
#import "Theme.h"


@implementation VerticalRefractionSupplementaryView

- (void)awakeFromNib {

    if ([super respondsToSelector:@selector(awakeFromNib)])
        [super awakeFromNib];

    Theme *sharedTheme = [Theme sharedTheme];

    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textColor = [sharedTheme labelColorLevel0];
    self.label.backgroundColor = [sharedTheme inputBackgroundColor];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.opaque = NO;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:self.label];
}

@end
