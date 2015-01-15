//
//  SliderCell.h
//  Custom UITableViewCell containing a UISLider, Text- and Detaillabel
//


@interface SliderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end
