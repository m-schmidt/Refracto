//
//  SliderCell.m
//  Custom UITableViewCell containing a UISLider, Text- and Detaillabel
//


#import "SliderCell.h"


@implementation SliderCell

- (void)prepareForReuse {

    [super prepareForReuse];
    self.descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
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
