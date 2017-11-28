//
//  NormalPageViewController.m
//  TestViewControllersFrame
//
//  Created by 王士良 on 2017/11/22.
//  Copyright © 2017年 wsliang. All rights reserved.
//

#import "NormalPageViewController.h"

#import "DataViewController.h"

@interface NormalPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic) NSArray *pageData;
@property (nonatomic) UIView *bgView;

@property (nonatomic) NSMutableDictionary *createDataDict;

@end

@implementation NormalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    _pageData = [[dateFormatter monthSymbols] copy];
    self.dataSource = self;
    self.delegate = self;
//    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.bgView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.bgView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.createDataDict = [NSMutableDictionary new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.bgView.frame = self.view.bounds;
}


#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.

        DataViewController *currentViewController = self.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

        self.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self pageViewController:self viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self pageViewController:self viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

#pragma mark - utils
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
        // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

        // Create a new view controller and pass suitable data.
//    DataViewController *showViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    DataViewController *showViewController = [DataViewController new];
//    NSLog(@"xib创建的对象:%@",showViewController);
    [self.createDataDict setObject:@1 forKey:@(showViewController.hash)];
    NSLog(@"xib创建对象个数:%d",self.createDataDict.count);

    showViewController.dataObject = self.pageData[index];
    return showViewController;
}


- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    id dataObject = ((DataViewController *)viewController).dataObject;
    return [self.pageData indexOfObject:dataObject];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
