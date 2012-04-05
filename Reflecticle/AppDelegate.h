#import <Cocoa/Cocoa.h>
#import <RestKit/RestKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, RKRequestDelegate>

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSStatusBar *statusBar;
@property (strong) IBOutlet NSStatusItem *statusItem;
@property (strong) IBOutlet NSMenu *menu;
@property (strong) IBOutlet NSPopUpButton *project;
@property (strong) IBOutlet NSTextField *post;
@property (strong) IBOutlet NSTextField *apiKey;

- (void)awakeFromNib;
- (void)askForProjects;
- (IBAction)submit:(id)sender;
- (void)windowWillClose:(NSNotification *)notification;

@end
