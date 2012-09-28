#import "StopRecord.h"
#import "StopReordCell.h"

@implementation StopReordCell

- (void)setStopRecord:(StopRecord *)stopRecord {
    _stopRecord = stopRecord;
    self.textLabel.text = _stopRecord.title;
    self.detailTextLabel.text = _stopRecord.subtitle;
}

@end
