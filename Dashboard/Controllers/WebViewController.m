//
//  WebViewController.m
//  Dashboard
//
//  Created by Benjamin SENECHAL on 03/05/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performWebViewWithURL:self.searchFromSearchView.url];
}

- (void)performWebViewWithURL:(NSString *)string
{
    NSString *urlAddress = string;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    [self.activityIndicator startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
}

- (IBAction)dismiss:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
