//
//  NEOColorPickerViewController.m
//
//  Created by Karthik Abram on 10/10/12.
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


#import "NEOColorPickerHSLViewController.h"
#import "UIColor+NEOColor.h"
#import "NEOColorPickerGradientView.h"
#import <QuartzCore/QuartzCore.h>

#define CP_RESOURCE_CHECKERED_IMAGE                     @"colorPicker.bundle/color-picker-checkered"
#define CP_RESOURCE_HUE_CIRCLE                          @"colorPicker.bundle/color-picker-hue"
#define CP_RESOURCE_HUE_CROSSHAIR                       @"colorPicker.bundle/color-picker-crosshair"
#define CP_RESOURCE_VALUE_MAX                           @"colorPicker.bundle/color-picker-max"
#define CP_RESOURCE_VALUE_MIN                           @"colorPicker.bundle/color-picker-min"


@interface NEOColorPickerHSLViewController () <NEOColorPickerGradientViewDelegate>
{
    CALayer *_colorLayer;
    CGFloat _hue, _saturation, _luminosity, _alpha;
}
@end

@implementation NEOColorPickerHSLViewController


- (void)viewDidLoad {
    if (self.selectedColor == nil) {
        self.selectedColor = [UIColor redColor];
    }
    
    [super viewDidLoad];
    
    self.checkeredView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CP_RESOURCE_CHECKERED_IMAGE]];
    self.hueImageView.image = [UIImage imageNamed:CP_RESOURCE_HUE_CIRCLE];
    
    self.hueImageView.layer.zPosition = 10;
    self.labelPreview.layer.zPosition = 11;
    
    _colorLayer = [CALayer layer];
    CGRect frame = self.hueImageView.frame;
    frame.origin.x += (self.hueImageView.frame.size.width - 100) / 2;
    frame.origin.y += (self.hueImageView.frame.size.height - 100) / 2;
    frame.size = CGSizeMake(100, 100);
    _colorLayer.frame = frame;
    _colorLayer.backgroundColor = self.selectedColor.CGColor;
    [self.view.layer addSublayer:_colorLayer];
    [_colorLayer setNeedsDisplay];
    
    self.hueCrosshair.image = [UIImage imageNamed:CP_RESOURCE_HUE_CROSSHAIR];
    self.hueCrosshair.layer.zPosition = 15;
    
    self.gradientViewSaturation.backgroundColor = [UIColor clearColor];
    self.gradientViewSaturation.layer.masksToBounds = YES;
    self.gradientViewSaturation.layer.cornerRadius = 5.0;
    self.gradientViewSaturation.layer.borderColor = [UIColor grayColor].CGColor;
    self.gradientViewSaturation.layer.borderWidth = 2.0;
    self.gradientViewSaturation.delegate = self;

    self.gradientViewLuminosity.backgroundColor = [UIColor clearColor];
    self.gradientViewLuminosity.layer.masksToBounds = YES;
    self.gradientViewLuminosity.layer.cornerRadius = 5.0;
    self.gradientViewLuminosity.layer.borderColor = [UIColor grayColor].CGColor;
    self.gradientViewLuminosity.layer.borderWidth = 2.0;
    self.gradientViewLuminosity.delegate = self;

    self.gradientViewAlpha.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CP_RESOURCE_CHECKERED_IMAGE]];
    self.gradientViewAlpha.layer.masksToBounds = YES;
    self.gradientViewAlpha.layer.cornerRadius = 5.0;
    self.gradientViewAlpha.layer.borderColor = [UIColor grayColor].CGColor;
    self.gradientViewAlpha.layer.borderWidth = 2.0;
    self.gradientViewAlpha.delegate = self;  

    [[self.selectedColor neoToHSL] getHue:&_hue saturation:&_saturation brightness:&_luminosity alpha:&_alpha];
    if (self.disallowOpacitySelection) {
        _alpha = 1.0;
        self.gradientViewAlpha.hidden = YES;
        self.buttonAlphaMax.hidden = YES;
        self.buttonAlphaMin.hidden = YES;
        self.labelTransparency.hidden = YES;
    }
    
    [self valuesChanged];
    
    // Position hue cross-hair.
    [self positionHue];
    
    self.hueImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(huePanOrTap:)];
    [self.hueImageView addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huePanOrTap:)];
    [self.hueImageView addGestureRecognizer:tapRecognizer];
    
    self.buttonSatMax.backgroundColor = [UIColor clearColor];
    [self.buttonSatMax setImage:[UIImage imageNamed:CP_RESOURCE_VALUE_MAX] forState:UIControlStateNormal];
    self.buttonSatMin.backgroundColor = [UIColor clearColor];
    [self.buttonSatMin setImage:[UIImage imageNamed:CP_RESOURCE_VALUE_MIN] forState:UIControlStateNormal];

    self.buttonLumMax.backgroundColor = [UIColor clearColor];
    [self.buttonLumMax setImage:[UIImage imageNamed:CP_RESOURCE_VALUE_MAX] forState:UIControlStateNormal];
    self.buttonLumMin.backgroundColor = [UIColor clearColor];
    [self.buttonLumMin setImage:[UIImage imageNamed:CP_RESOURCE_VALUE_MIN] forState:UIControlStateNormal];

    self.buttonAlphaMax.backgroundColor = [UIColor clearColor];
    [self.buttonAlphaMax setImage:[UIImage imageNamed:CP_RESOURCE_VALUE_MAX] forState:UIControlStateNormal];
    self.buttonAlphaMin.backgroundColor = [UIColor clearColor];
    [self.buttonAlphaMin setImage:[UIImage imageNamed:CP_RESOURCE_VALUE_MIN] forState:UIControlStateNormal];
}


- (void) positionHue {
    CGFloat angle = M_PI * 2 * _hue - M_PI;
    CGFloat cx = 76 * cos(angle) + 160 - 16.5;
    CGFloat cy = 76 * sin(angle) + 90 + self.hueImageView.frame.origin.y - 16.5;
    CGRect frame = self.hueCrosshair.frame;
    frame.origin.x = cx;
    frame.origin.y = cy;
    self.hueCrosshair.frame = frame;
}


- (void) valuesChanged {
    [self positionHue];
    
    self.gradientViewSaturation.color1 = [UIColor colorWithHue:_hue saturation:0 brightness:1.0 alpha:1.0];
    self.gradientViewSaturation.color2 = [UIColor colorWithHue:_hue saturation:1.0 brightness:1.0 alpha:1.0];
    self.gradientViewSaturation.value = _saturation;
    [self.gradientViewSaturation reloadGradient];
    [self.gradientViewSaturation setNeedsDisplay];
    
    self.gradientViewLuminosity.color1 = [UIColor colorWithHue:_hue saturation:_saturation brightness:0.0 alpha:1.0];
    self.gradientViewLuminosity.color2 = [UIColor colorWithHue:_hue saturation:_saturation brightness:1.0 alpha:1.0];
    self.gradientViewLuminosity.value = _luminosity;
    [self.gradientViewLuminosity reloadGradient];
    [self.gradientViewLuminosity setNeedsDisplay];
    
    self.gradientViewAlpha.color1 = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:0.0];
    self.gradientViewAlpha.color2 = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:1.0];
    self.gradientViewAlpha.value = _alpha;
    [self.gradientViewAlpha reloadGradient];
    [self.gradientViewAlpha setNeedsDisplay];
    
    self.selectedColor = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:_alpha];
    _colorLayer.backgroundColor = self.selectedColor.CGColor;
    [_colorLayer setNeedsDisplay];
    
    self.labelPreview.textColor = [[self.selectedColor neoComplementary] neoColorWithAlpha:1.0];

    if ([self.delegate respondsToSelector:@selector(colorPickerViewController:didChangeColor:)]) {
        [self.delegate colorPickerViewController:self didChangeColor:self.selectedColor];
    }
}


- (void)viewDidUnload {
    _colorLayer = nil;
    [self setHueCrosshair:nil];
    [self setGradientViewSaturation:nil];
    [self setGradientViewLuminosity:nil];
    [self setGradientViewAlpha:nil];
    [self setCheckeredView:nil];
    [self setButtonSatMin:nil];
    [self setButtonSatMax:nil];
    [self setButtonLumMax:nil];
    [self setButtonAlphaMax:nil];
    [self setButtonAlphaMin:nil];
    [self setButtonAlphaMin:nil];
    [self setButtonLumMin:nil];
    [self setLabelTransparency:nil];
    [self setLabelPreview:nil];
    [super viewDidUnload];
}


- (void) huePanOrTap:(UIGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [recognizer locationInView:self.hueImageView];
            CGFloat dx = point.x - 90;
            CGFloat dy = point.y - 90;
            CGFloat angle = atan2f(dy, dx);
            if (dy != 0) {
                angle += M_PI;
                _hue = angle / (2 * M_PI);
            } else if (dx > 0){
                _hue = 0.5;
            }
            [self valuesChanged];
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default: {
            // Canceled or error state.
            break;
        }
    }
}


- (void)colorPickerGradientView:(NEOColorPickerGradientView *)view valueChanged:(CGFloat)value {
    if (view == self.gradientViewSaturation) {
        _saturation = value;
    } else if (view == self.gradientViewLuminosity) {
        _luminosity = value;
    } else {
        _alpha = value;
    }
    [self valuesChanged];
}


- (IBAction)buttonPressMaxMin:(id)sender {
    if (sender == self.buttonSatMax) {
        _saturation = 1.0;
    } else if (sender == self.buttonSatMin) {
        _saturation = 0.0;
    } else if (sender == self.buttonLumMax) {
        _luminosity = 1.0;
    } else if (sender == self.buttonLumMin) {
        _luminosity = 0.0;
    } else if (sender == self.buttonAlphaMax) {
        _alpha = 1.0;
    } else if (sender == self.buttonAlphaMin) {
        _alpha = 0.0;
    }
    [self valuesChanged];
}


@end