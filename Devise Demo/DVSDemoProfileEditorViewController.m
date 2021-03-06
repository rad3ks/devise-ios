//
//  ProfileEditorViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSDemoProfileEditorViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+DeviseDemo.h"
#import "DVSUserManager.h"
#import "DVSUserPersistenceManager.h"

static NSString * const DVSTitleForAlertCancelButton = @"Close";
static NSString * const DVSTitleForEmail = @"E-mail address";

@interface DVSDemoProfileEditorViewController () <UIAlertViewDelegate>

@end

@implementation DVSDemoProfileEditorViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *emailTitle = NSLocalizedString(DVSTitleForEmail, nil);
    [self addFormWithTitleToDataSource:emailTitle
                    accessibilityLabel:DVSAccessibilityLabel(@"E-mail field")
                          keyboardType:UIKeyboardTypeEmailAddress];
    [self setValue:[DVSUserPersistenceManager sharedPersistenceManager].localUser.email forTitle:emailTitle];
}

#pragma mark - UIControl events

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender {
    [DVSUserManager defaultManager].userPreviousEmail = [DVSUserPersistenceManager sharedPersistenceManager].localUser.email;
    
    [DVSUserPersistenceManager sharedPersistenceManager].localUser.email = [self valueForTitle:NSLocalizedString(DVSTitleForEmail, nil)];

    [[DVSUserManager defaultManager] updateWithSuccess:^{
        [DVSUserManager defaultManager].userPreviousEmail = [DVSUserPersistenceManager sharedPersistenceManager].localUser.email;
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile updated", nil)
                                    message:NSLocalizedString(@"Your profile was updated.", nil)
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(DVSTitleForAlertCancelButton, nil)
                          otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        [DVSUserPersistenceManager sharedPersistenceManager].localUser.email = [DVSUserManager defaultManager].userPreviousEmail;
        UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                        statusDescriptionsDictionary:@{ @422: NSLocalizedString(@"E-mail is already taken.", nil) }];
        [errorAlert show];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(DVSTitleForAlertCancelButton, nil)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
