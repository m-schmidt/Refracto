//
//  SliderCell.m
//  Custom UITableViewCell containing a UISLider, Text- and Detaillabel
//


#import "SliderCell.h"
#import "UIFont+Monospaced.h"


@implementation SliderCell

- (void)prepareForReuse {

    [super prepareForReuse];

    UIFont *font = [UIFont monospacedDigitFontVariant:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.descriptionLabel.font = font;
    self.detailLabel.font = font;
}


#pragma mark Accessibility


- (NSString *)accessibilityLabel {

    return self.descriptionLabel.text;
}


- (NSString *)accessibilityValue {

    return [self.detailLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"÷"];
}


- (UIAccessibilityTraits)accessibilityTraits; {

    return super.accessibilityTraits | UIAccessibilityTraitAdjustable;
}


- (void)accessibilityIncrement {

    [self.slider accessibilityIncrement];
}


- (void)accessibilityDecrement {

    [self.slider accessibilityDecrement];
}

@end
