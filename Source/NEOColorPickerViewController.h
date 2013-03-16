//
//  NEOColorPickerViewController.h
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


#import "NEOColorPickerBaseViewController.h"

@interface NEOColorPickerViewController : NEOColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIView *simpleColorGrid;
@property (weak, nonatomic) IBOutlet UIButton *buttonHue;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddFavorite;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorites;
@property (weak, nonatomic) IBOutlet UIButton *buttonHueGrid;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;
@property (nonatomic, strong) NSString* favoritesTitle;

- (IBAction)buttonPressHue:(id)sender;
- (IBAction)buttonPressHueGrid:(id)sender;
- (IBAction)buttonPressAddFavorite:(id)sender;
- (IBAction)buttonPressFavorites:(id)sender;


@end
