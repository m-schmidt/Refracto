//
//  HorizontalModePicker.h
//  Custom View wrapping a UICollectionView for the Mode Selector
//


// Text attributes shared with HorizontalModeCell
extern NSDictionary *horizontalModeTextAttributes;
extern NSDictionary *horizontalModeSelectedTextAttributes;


@class HorizontalModePicker;


@protocol HorizontalModePickerDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInPickerView:(HorizontalModePicker *)pickerView;
- (NSString *)pickerView:(HorizontalModePicker *)pickerView titleForItemAtIndex:(NSInteger)index;

@end


@protocol HorizontalModePickerDelegate <NSObject>

@required
- (void)pickerView:(HorizontalModePicker *)pickerView didSelectItemAtIndex:(NSInteger)index;

@end


@interface HorizontalModePicker : UIView

@property (weak, nonatomic) IBOutlet id <HorizontalModePickerDataSource> datasource;
@property (weak, nonatomic) IBOutlet id <HorizontalModePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
