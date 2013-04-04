//
//  NEOViewController.m
//  ColorPickerExample
//
//  Created by Karthik Abram on 12/28/12.
//  Copyright (c) 2012 Neovera.
//

#import "TestViewController.h"
#import "NEOColorPickerViewController.h"

@interface TestViewController () <NEOColorPickerViewControllerDelegate>

@property (nonatomic, strong) UIColor *currentColor;

@end

@implementation TestViewController

- (id) init {
    if (self = [super init]) {
        self.currentColor = [UIColor blackColor];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)buttonPressPickColor:(id)sender {
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = self.currentColor;
    controller.title = @"Example";
	UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navVC animated:YES completion:nil];
}


- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    self.view.backgroundColor = color;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
