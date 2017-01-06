//
//  CustomTableViewCell.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 8. 7..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"setSelected");
    
    if(self.editing)
    {
        // set background color
        NSLog(@"editing");
        
        
        
    }
    
    else {
    }
}
- (void)layoutSubviews
{
   
        [super layoutSubviews];
    NSLog(@"layoutSubviews");
    
    
        self.selectedBackgroundView.frame = CGRectMake(75, 0, self.frame.size.width-75, self.frame.size.height);
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.0f];
    
    for (UIView *subview in self.subviews) {
        
        if([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
            NSLog(@"UITableViewCellDeleteConfirmationControl");
           
            
        }else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
            NSLog(@"UITableViewCellEditControl");
            
            
            
        
        }
        else{
            NSLog(@"else");
            
            UIView *myBackView = [[UIView alloc] initWithFrame:self.frame];
            myBackView.backgroundColor = [UIColor clearColor];
            self.selectedBackgroundView = myBackView;
//            [myBackView release];
            
            
        }
        
    }
    [UIView commitAnimations];
}



- (void)willTransitionToState:(UITableViewCellStateMask)state{

    [super willTransitionToState:state];
    
    NSLog(@"self.frame %@ \n contentview %@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.contentView.frame));
    if (state == UITableViewCellStateShowingEditControlMask) {
        // edit mode : peform operations on the cell outlets here
        NSLog(@"edit mode");
        
        
        
    } else if (state ==UITableViewCellStateDefaultMask) {
        // normal mode : back to normal
        NSLog(@"normal mode");
        
        
        
    }
    

    

}





@end
