//
//  NEOColorPickerViewController.m
//
//  Created by Karthik Abram on 10/23/12.
//  Copyright (c) 2012 Neovera Inc.
//

/*
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */


#import "NEOColorPickerViewController.h"
#import "NEOColorPickerHSLViewController.h"
#import "NEOColorPickerHueGridViewController.h"
#import "NEOColorPickerFavoritesViewController.h"
#import "UIColor+NEOColor.h"
#import <QuartzCore/QuartzCore.h>


@interface NEOColorPickerViewController () <NEOColorPickerViewControllerDelegate> {
    NSMutableArray *_colorArray;
}
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *CancelButton;

@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *DoneButton;
@property (nonatomic, weak) CALayer *selectedColorLayer;

@end

@implementation NEOColorPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _colorArray = [NSMutableArray array];
        
        int colorCount = NEOColorPicker4InchDisplay() ? 20 : 16;
        for (int i = 0; i < colorCount; i++) {
            UIColor *color = [UIColor colorWithHue:i / (float)colorCount saturation:1.0 brightness:1.0 alpha:1.0];
            [_colorArray addObject:color];
        }
        
        colorCount = NEOColorPicker4InchDisplay() ? 8 : 4;
        for (int i = 0; i < colorCount; i++) {
            UIColor *color = [UIColor colorWithWhite:i/(float)(colorCount - 1) alpha:1.0];
            [_colorArray addObject:color];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.selectedColor) {
        self.selectedColor = [UIColor blackColor];
    }
    
    self.simpleColorGrid.backgroundColor = [UIColor clearColor];
    
    [self.buttonHue setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonHue];
    [self.buttonHue setImage:[UIImage imageNamed:@"colorPicker.bundle/hue_selector"] forState:UIControlStateNormal];
    
    [self.buttonAddFavorite setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonAddFavorite];
    [self.buttonAddFavorite setImage:[UIImage imageNamed:@"colorPicker.bundle/picker-favorites-add"] forState:UIControlStateNormal];
    
    [self.buttonFavorites setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonFavorites];
    [self.buttonFavorites setImage:[UIImage imageNamed:@"colorPicker.bundle/picker-favorites"] forState:UIControlStateNormal];
    
    [self.buttonHueGrid setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonHueGrid];
    [self.buttonHueGrid setImage:[UIImage imageNamed:@"colorPicker.bundle/picker-grid"] forState:UIControlStateNormal];
    
    CGRect frame = CGRectMake(130, 65, 100, 40);
    UIImageView *checkeredView = [[UIImageView alloc] initWithFrame:frame];
    checkeredView.layer.cornerRadius = 6.0;
    checkeredView.layer.masksToBounds = YES;
    checkeredView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorPicker.bundle/color-picker-checkered"]];
    [self.view addSubview:checkeredView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(130, 65, 100, 40);
    layer.cornerRadius = 6.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.8;
    
    [self.view.layer addSublayer:layer];
    self.selectedColorLayer = layer;
    
    int colorCount = NEOColorPicker4InchDisplay() ? 28 : 20;
    for (int i = 0; i < colorCount; i++) {
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = 6.0;
        UIColor *color = [_colorArray objectAtIndex:i];
        layer.backgroundColor = color.CGColor;
        
        int column = i % 4;
        int row = i / 4;
        layer.frame = CGRectMake(8 + (column * 78), 8 + row * 48, 70, 40);
        [self setupShadow:layer];
        [self.simpleColorGrid.layer addSublayer:layer];
    }
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.simpleColorGrid addGestureRecognizer:recognizer];
    
    self.navigationItem.leftBarButtonItem = self.CancelButton;
    self.navigationItem.rightBarButtonItem = self.DoneButton;
    
}


- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setSimpleColorGrid:nil];
    [self setButtonHue:nil];
    [self setButtonAddFavorite:nil];
    [self setButtonFavorites:nil];
    [self setButtonHueGrid:nil];
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateSelectedColor];
}


- (void) updateSelectedColor {
    self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
}


- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.simpleColorGrid];
    int row = (int)((point.y - 8) / 48);
    int column = (int)((point.x - 8) / 78);
    int index = row * 4 + column;
    self.selectedColor = [_colorArray objectAtIndex:index];
    [self updateSelectedColor];
}


- (IBAction)buttonPressCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(colorPickerViewControllerDidCancel:)]) {
        [self.delegate colorPickerViewControllerDidCancel:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)buttonPressDone:(id)sender {
    [self.delegate colorPickerViewController:self didSelectColor:self.selectedColor];
}


- (IBAction)buttonPressHue:(id)sender {
    NEOColorPickerHSLViewController *controller = [[NEOColorPickerHSLViewController alloc] init];
    controller.delegate = self;
    controller.dialogTitle = self.dialogTitle;
    controller.disallowOpacitySelection = self.disallowOpacitySelection;
    controller.selectedColor = self.selectedColor;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    if (self.disallowOpacitySelection && [color neoAlpha] != 1.0) {
        self.selectedColor = [color neoColorWithAlpha:1.0];
    } else {
        self.selectedColor = color;
    }
    [self updateSelectedColor];
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)buttonPressHueGrid:(id)sender {
    NEOColorPickerHueGridViewController *controller = [[NEOColorPickerHueGridViewController alloc] init];
    controller.delegate = self;
    controller.dialogTitle = self.dialogTitle;
    controller.selectedColor = self.selectedColor;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)buttonPressAddFavorite:(id)sender {
    [[NEOColorPickerFavoritesManager instance] addFavorite:self.selectedColor];
    // TODO: Suggest using a framework like SVProgressHUD to provide feedback.
    // [SVProgressHUD showSuccessWithStatus:@"Added to favorites"];
}


- (IBAction)buttonPressFavorites:(id)sender {
    NEOColorPickerFavoritesViewController *controller = [[NEOColorPickerFavoritesViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = self.selectedColor;
    controller.dialogTitle = @"Favorites";
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
