Color Picker
====================

Background
----------

A color picker is the most conspicuously absent component in the collection of built-in controls provided by Apple in the iOS library. There are many open-source components that have sprung up to fill the gap. This component was created for the [ToonThat][https://itunes.apple.com/us/app/toonthat/id584478951?ls=1&mt=8] application as we didn't find the level of flexibility and feature-set in the others.

Screenshots
-------
![Simple selector](https://github.com/neovera/colorpicker/blob/master/etc/image1.png?raw=true)
![Hue Grid selector](https://github.com/neovera/colorpicker/blob/master/etc/image2.png?raw=true)
![HSL selector](https://github.com/neovera/colorpicker/blob/master/etc/image3.png?raw=true)


Features
-------
* Shows a simple color pallete (simplifies the simple case).
* iPhone 5 ready - color pallete expands to fill larger screen.
* Hue grid - more variations of primary color. Color line in the bottom can be tapped to select color or grid can be swiped left and right.
* HSL selector - for fine grain color selection, presents Hue circle and separate saturation and luminosity controls.
* Alpha selector
* Allows users to save their favorite colors. Favorites are stored in a file in the Documents directory.
* Simple delegate model.
* You can specify current color selection and title for header.


Usage
-----
Copy the files within the Source folder into your project. The colorPicker.bundle file contains the graphical resources.

In your view controller where you want to invoke the color picker, first implement the methods of the delegate:

    @implementation MyViewController <NEOColorPickerViewControllerDelegate>
    
Assuming you want to launch the view controller in response to a button being clicked, setup and launch an instance of NEOColorPickerViewController:

    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = <some initial color reference>;
    controller.title = @"My dialog title";
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navVC animated:YES completion:nil];
    
Finally handle the color picker delegate callback when the color is selected or cancelled:

    - (void) colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
        // Do something with the color.    
        self.view.backgroundColor = color;
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    
    - (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }

License
-------
[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
