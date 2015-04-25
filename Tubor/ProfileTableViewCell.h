//
//  ProfileTableViewCell.h
//  Tubor
//
//  Created by Marcelo Sedano on 4/1/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
-(void)setTextFieldEditable:(BOOL)editable;

@end
