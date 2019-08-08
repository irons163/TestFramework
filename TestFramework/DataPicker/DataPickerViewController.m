//
//  DataPickerViewController.m
//  TestFramework
//
//  Created by Phil on 2019/8/5.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "DataPickerViewController.h"
#import "CustomPickerFactory.h"

@interface DataPickerViewController () {
    IRDataPicker *datePicker;
}

@property (weak, nonatomic) IBOutlet UITextField *infoTextfield;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;
- (IBAction)pickerButtonClick:(id)sender;

@end

@implementation DataPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pickerButtonClick:(id)sender {
    NSArray *customStrings = @[@"A", @"B", @"C", @"D", @"E"];
    IRDataPickerManager *datePickManager = [CustomPickerFactory createIRDataPickManager];
    datePickManager.dataPicker.datePickerMode = IRDataPickerModeCustom;
    datePickManager.dataPicker.customList = customStrings;
    NSUInteger index = [customStrings indexOfObject:self.infoTextfield.text];
    if(index == NSNotFound)
        index = 0;
    [datePickManager.dataPicker setRow:index animated:NO];
    datePickManager.dataPicker.selectedCustom = ^(NSString *customString) {
        self.infoTextfield.text = customString;
    };
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (IBAction)datePickerButtonClick:(id)sender {
    if(datePicker) {
        [datePicker removeFromSuperview];
        datePicker = nil;
    } else {
        datePicker = [[IRDataPicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
        datePicker.datePickerMode = IRDataPickerModeDate;
        [self.view addSubview:datePicker];
    }
}

@end
