#import "BDDViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BDDViewControllerSpec)

describe(@"BDDViewController", ^{
    __block BDDViewController *viewController;

    beforeEach(^{
        viewController = [[BDDViewController alloc] init] ; // 2.
    });
    
    context(@"when the app is finished loading", ^{ // 3.
        beforeEach(^{
            [viewController tableView:nil cellForRowAtIndexPath:nil];
        });
        
        it(@"exists", ^{
            //viewController.img should be_instance_of([UIImage class]); //5.
            //viewController.img shoulf have_received(MethodStubbingMarker:
            
            //delegate.someText should equal(@"blargh");
            
            viewController should_not be_nil;
        });
        
        it(@"has viewDidLoad method", ^{
            [viewController respondsToSelector:@selector(viewDidLoad)] should be_truthy;
        });
        
        it(@"has viewDidLoad method", ^{
            [viewController respondsToSelector:@selector(connectionDidFinishLoading)] should be_truthy;
        });
        
        
        
    });

});

SPEC_END
