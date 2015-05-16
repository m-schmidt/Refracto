//
//  VerticalRefractionCell.m
//  Custom Cell for UICollectionView used as Tick Marker
//


#import "VerticalRefractionCell.h"


@implementation VerticalRefractionCell

- (void)awakeFromNib {

    _barLength = NSIntegerMax;
    _alignment = RefractionPickerAlignmentLeft;
}


- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext ();

    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat position = (self.alignment == RefractionPickerAlignmentLeft) ? 0 : floor(width - self.barLength);

    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextFillRect(context, CGRectMake(position, floor(height / 2), self.barLength, 1));
}


#pragma mark Properties


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
