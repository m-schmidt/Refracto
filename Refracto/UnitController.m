//
//  UnitController.h
//  Controller for gravity unit selection
//


#import "UnitController.h"
#import "AppDelegate.h"


@implementation UnitController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{ [self updateCheckmarks]; });
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self updateCheckmarks];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)updateCheckmarks {

    RFGravityUnit preferredGravityUnit = [AppDelegate appDelegate].preferredGravityUnit;
    UITableViewCell *cell;

    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.accessoryType = (preferredGravityUnit == RFGravityUnitPlato) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.accessoryType = (preferredGravityUnit == RFGravityUnitSG) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
