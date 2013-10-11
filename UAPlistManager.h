
#import <Foundation/Foundation.h>

@interface UAPlistManager : NSObject

+ (UAPlistManager *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;

@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *defaultPower;
@property (nonatomic, copy) NSArray *plistBeaconContentsArray;
@property (nonatomic, copy) NSArray *plistRegionContentsArray;
@property (nonatomic, copy) NSArray *plistVisitedContentsArray;
@property (nonatomic, copy, readonly) NSArray *beaconRegions;
@property (nonatomic, strong) NSArray *visitedBeaconRegions;
@property (nonatomic, copy, readonly) NSArray *regions;
@property (nonatomic, copy, readonly) NSArray *readableBeaconRegions;

@end
