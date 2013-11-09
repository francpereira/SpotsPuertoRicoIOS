//
//  SugerenciaViewController.m
//  SpotsPuertoRico
//
//  Created by Francisco Pereira on 3/23/13.
//  Copyright (c) 2013 Francisco Pereira. All rights reserved.
//

#import "SugerenciaViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SugerenciaViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtSugerenciaName;
@property (weak, nonatomic) IBOutlet UITextView *txtSugerenciaDesc;

@end

@implementation SugerenciaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    
    
    self.txtSugerenciaDesc.layer.borderWidth = 1.0f;
    self.txtSugerenciaDesc.layer.borderColor = [[UIColor grayColor] CGColor];
    self.txtSugerenciaName.delegate = self;
    self.txtSugerenciaDesc.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)btnEnviarClick:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Nueva sugerencia de Spot"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"francpereira@icloud.com", nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody = [NSString stringWithFormat:@"%@ <br /><br /><br /> %@", self.txtSugerenciaName.text, self.txtSugerenciaDesc.text];
        [mailer setMessageBody:emailBody isHTML:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Tu celu no envia email! Boom!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
