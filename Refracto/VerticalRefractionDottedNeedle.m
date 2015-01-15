//
//  VerticalRefractionDottedNeedle.m
//  Custom View for Selection Needles
//


#import "VerticalRefractionDottedNeedle.h"


@implementation VerticalRefractionDottedNeedle

- (void)initialize {

    _alignment = RefractionPickerAlignmentLeft;

    self.userInteractionEnabled = NO;
}


- (instancetype)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {

        [self initialize];
    }

    return self;
}


- (instancetype)initWithCoder:(NSCoder *)decoder {

    if ((self = [super initWithCoder:decoder])) {

        [self initialize];
    }

    return self;
}


- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext ();

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);

    CGContextSetFillColorWithColor(context, [self.tintColor CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake((self.alignment == RefractionPickerAlignmentRight) ? 0 : width - height, 0, height, height));

    if (width > height) {

        CGContextFillRect(context, CGRectMake(0, floor(height / 2), width, 1));
    }
}

@end
