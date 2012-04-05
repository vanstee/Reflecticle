#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize statusBar = _statusBar;
@synthesize statusItem = _statusItem;
@synthesize menu = _menu;
@synthesize project = _project;
@synthesize post = _post;
@synthesize apiKey = _apiKey;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [RKClient clientWithBaseURL:@"http://www.reflecticle.com"];
    [self askForProjects];
}

- (void)awakeFromNib {
    self.statusBar = [NSStatusBar systemStatusBar];
    self.statusItem = [self.statusBar statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.menu];
    [self.statusItem setTitle:@"Reflecticle"];
    [self.statusItem setHighlightMode:YES];

    NSString *apiKeyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"apiKey"];

    if (apiKeyString) {
        [self.apiKey setStringValue:apiKeyString];
    }
}

- (void)askForProjects {
    NSString *apiKeyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"apiKey"];

    if(apiKeyString) {
        NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:@"api_key", apiKeyString, nil];
        [[RKClient sharedClient] get:@"/api/projects.json" queryParams:params delegate:self];
    }
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if([request isGET] && [response isOK] && [response isJSON]) {
        NSArray *projects = [response parsedBody:nil];
        [self.project removeAllItems];
        
        for(NSDictionary *projectDictionary in projects) {
            [self.project addItemWithTitle:[projectDictionary objectForKey:@"name"]];
        }
    }
    else if([request isGET] && [response isOK]) {
        NSLog(@"posted!");
    }
}


- (IBAction)submit:(id)sender {
     NSString *apiKeyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"apiKey"];
     NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:@"api_key", apiKeyString,
                                                                       @"project_id", [self.project stringValue],
                                                                       @"description", [self.post stringValue],
                                                                       nil];
    [[RKClient sharedClient] get:@"/api/activities/create.json" queryParams:params delegate:self];
    [self.post setStringValue:@""];
    [[(NSButton*)sender window] performClose:nil];
}

- (void)windowWillClose:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setObject:[self.apiKey stringValue] forKey:@"apiKey"];
    [self askForProjects];
}

@end
