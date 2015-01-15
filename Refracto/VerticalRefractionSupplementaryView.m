//
//  VerticalRefractionSuplementaryView.m
//  Custom Supplementary View for Tick Labels in Refraction Selectors
//


#import "VerticalRefractionSupplementaryView.h"


@implementation VerticalRefractionSupplementaryView

- (instancetype)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {

        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textColor = [UIColor blackColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.opaque = NO;

        [self addSubview:self.label];
    }

    return self;
}

@end
