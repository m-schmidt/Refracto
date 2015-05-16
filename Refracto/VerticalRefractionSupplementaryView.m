//
//  VerticalRefractionSuplementaryView.m
//  Custom Supplementary View for Tick Labels in Refraction Selectors
//


#import "VerticalRefractionSupplementaryView.h"


@implementation VerticalRefractionSupplementaryView

- (void)awakeFromNib {

    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textColor = [UIColor blackColor];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.opaque = NO;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:self.label];
}

@end
