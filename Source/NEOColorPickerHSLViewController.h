//
//  NEOColorPickerViewController.h
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


#import <UIKit/UIKit.h>
#import "NEOColorPickerBaseViewController.h"


@class NEOColorPickerGradientView;


@interface NEOColorPickerHSLViewController : NEOColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *hueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hueCrosshair;
@property (weak, nonatomic) IBOutlet NEOColorPickerGradientView *gradientViewSaturation;
@property (weak, nonatomic) IBOutlet NEOColorPickerGradientView *gradientViewLuminosity;
@property (weak, nonatomic) IBOutlet NEOColorPickerGradientView *gradientViewAlpha;
@property (weak, nonatomic) IBOutlet UIImageView *checkeredView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSatMin;
@property (weak, nonatomic) IBOutlet UIButton *buttonSatMax;
@property (weak, nonatomic) IBOutlet UIButton *buttonLumMax;
@property (weak, nonatomic) IBOutlet UIButton *buttonLumMin;
@property (weak, nonatomic) IBOutlet UIButton *buttonAlphaMax;
@property (weak, nonatomic) IBOutlet UIButton *buttonAlphaMin;
@property (weak, nonatomic) IBOutlet UILabel *labelTransparency;
@property (weak, nonatomic) IBOutlet UILabel *labelPreview;

- (IBAction)buttonPressMaxMin:(id)sender;


@end
