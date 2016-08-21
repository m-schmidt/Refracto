//
//  VerticalRefractionCell.m
//  Custom Cell for UICollectionView used as Tick Marker
//


#import "AppDelegate.h"
#import "VerticalRefractionCell.h"
#import "Theme.h"


@implementation VerticalRefractionCell

- (void)awakeFromNib {

    if ([super respondsToSelector:@selector(awakeFromNib)])
        [super awakeFromNib];

    self.barLength = NSIntegerMax;
    self.alignment = RefractionPickerAlignmentLeft;
}


- (void)drawRect:(CGRect)rect {

    Theme *sharedTheme = [Theme sharedTheme];

    CGContextRef context = UIGraphicsGetCurrentContext ();

    CGContextSetFillColorWithColor(context, [sharedTheme inputBackgroundColor].CGColor);
    CGContextFillRect(context, rect);

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat position = (self.alignment == RefractionPickerAlignmentLeft) ? 0 : floor(width - self.barLength);

    CGContextSetFillColorWithColor(context, [sharedTheme labelColorLevel0].CGColor);
    CGContextFillRect(context, CGRectMake(position, floor(height / 2), self.barLength, 1));
}


- (void)setBarLength:(NSInteger)barLength {

    if (self.barLength != barLength) {

        _barLength = barLength;
        [self setNeedsDisplay];
    }
}


- (void)setAlignment:(RefractionPickerAlignment)alignment {

    if (self.alignment != alignment) {

        _alignment = alignment;
        [self setNeedsDisplay];
    }
}

@end
