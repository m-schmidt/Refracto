//
//  UIFont+Monospaced.m
//  Extensions for San Franciso Monospaced Number Attributes
//


#import "UIFont+Monospaced.h"
#import <CoreText/CoreText.h>


@implementation UIFont (Monospaced)

+ (UIFont *)monospacedDigitFontVariant:(UIFont *)font {

    UIFontDescriptor *desc =
        [font.fontDescriptor fontDescriptorByAddingAttributes:
         @{ UIFontDescriptorFeatureSettingsAttribute:
                @[ @{ UIFontFeatureTypeIdentifierKey:@(kNumberSpacingType),
                      UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
                    }
                 ]
          }];

    return [UIFont fontWithDescriptor:desc size:font.pointSize];
}

@end
