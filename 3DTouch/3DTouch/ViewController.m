//
//  ViewController.m
//  3DTouch
//
//  Created by zhangrong on 2017/4/25.
//  Copyright © 2017年 ryan.zhang. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"列表";
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
//    [self checkForceTouchAvailable];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                            action:@selector(longPress:)];
//    longPress.minimumPressDuration = 0.1;
//    [_tableView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForceTouchAvailable
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            
            [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    }
}

- (void)longPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [recognizer locationInView:recognizer.view];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                
                NSLog(@"add 3d touch");
                
                [self registerForPreviewingWithDelegate:self sourceView:cell];
            }
        }
    }
}

#pragma mark - UITableView DataSource & Delegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIViewControllerPreviewing Delegate -

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{    
    if ([self.presentingViewController isKindOfClass:[DetailViewController class]]) {
        
        return nil;
    }
    
    CGPoint point = [self.tableView convertPoint:location fromView:previewingContext.sourceView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath) {
        
        DetailViewController *controller = [[DetailViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        
        return nav;
    }
    
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    UINavigationController *nav = (UINavigationController *)viewControllerToCommit;
    
    [self.navigationController showViewController:nav.topViewController sender:self];
}

@end
