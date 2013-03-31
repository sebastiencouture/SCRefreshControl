SCRefreshControl
================

Pull to refresh control for iOS 5 and above. Design and interface mimics the iOS 6 UIRefreshControl. SCRefreshControl can be used with any UIScrollView, it is not limited to usage with only a UITableViewController.

![Pull Down To Refresh](http://koomluku.com/wp-content/uploads/2013/03/SCRefreshControlPullDown.png) &nbsp; 
![Release to Refresh](http://koomluku.com/wp-content/uploads/2013/03/SCRefreshControlRelease.png) &nbsp; 
![Refresh in Progress](http://koomluku.com/wp-content/uploads/2013/03/SCRefreshControlUpdating.png)

## Example Usage

The refresh control can be used three ways:

* SCRefreshTableViewController - UITableViewController

``` objective-c
SCRefreshTableViewController *controller;

controller.refresh = [[SCRefreshControl alloc] init];
[controller.refresh addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
```


* SCRefreshViewController - UIViewController with UIScrollView component

``` objective-c
SCRefreshViewController *controller;

controller.refresh = [[SCRefreshControl alloc] init];
[controller.refresh addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
```


* Directly with a UIScrollView in own custom controller

``` objective-c
UIScrollView *scrollView;

SCRefreshControl *refresh = [[SCRefreshControl alloc] init];
[refresh addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];

[scrollView addSubview:refresh];
```

## LICENSE

SCRefreshControl, and all the accompanying source code, is released under the MIT license
