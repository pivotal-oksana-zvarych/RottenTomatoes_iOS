#import "BDDAppDelegate.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BDDAppDelegateSpec)

describe(@"BDDAppDelegate", ^{
    __block BDDAppDelegate *delegate; // 1.
    
    beforeEach(^{
        delegate = [[BDDAppDelegate alloc] init] ; // 2.
    });
    
    context(@"when the app is finished loading", ^{ // 3.
        beforeEach(^{
            [delegate application:nil didFinishLaunchingWithOptions:nil]; // 4.
        });
        
        it(@"exists", ^{
            delegate should_not be_nil;
        });
    });
});

SPEC_END
