//
//  HorizontalModeCell.m
//  Custom Cell for UICollectionView used as Mode Selector
//


#import "HorizontalModeCell.h"
#import "HorizontalModePicker.h"


@interface HorizontalModeCell ()

@property (strong, nonatomic) UILabel *label;

@end


@implementation HorizontalModeCell

- (void)awakeFromNib {

    if ([super respondsToSelector:@selector(awakeFromNib)])
        [super awakeFromNib];

    self.layer.doubleSided = NO;

    self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 1;
    self.label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.attributedText = [[NSAttributedString alloc] initWithString:@""];

    [self addSubview:self.label];
}


- (void)setSelected:(BOOL)selected {

    if (self.selected != selected) {

        super.selected = selected;

        NSDictionary *attributes = selected ? horizontalModeSelectedTextAttributes : horizontalModeTextAttributes;
        [self setText:self.label.attributedText.string attributes:attributes];
    }
}


- (void)setText:(NSString *)text attributes:(NSDictionary *)attributes {

    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.3;
    [self.label.layer addAnimation:transition forKey:nil];

    self.label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
