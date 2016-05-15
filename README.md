# KISSWebViewer
<img src="https://raw.githubusercontent.com/DrabWeb/KISSWebViewer/master/Icon.png" width="256">

A KISS web viewer for OSX

### Features:
- Just a web view, no more no less
- Picture in Picture mode based off of the iPad feature with the same name. Makes the window float over others, and you can scroll it to move it to different corners
- Command line support

### Usage
#### Picture in Picture mode
To enable, open the app and do ``` ⌘⌥P ```(``` Window/Toggle Picture in Picture mode ```). Now it will float over other windows, and move to the active space.

To move it to different corners, hold command and scroll up, down left and right to move the window to different corners.

#### Launch Arguments
Note: These have to be in this order. You dont have to have them all, but if you want to use the PiP mode corner argument for example, you need to also have the PiP mode enabled argument.

``` Argument 1 ```: If it is ``` true ```, the titlebar will be hidden automatically

``` Argument 2 ```: If it is ``` true ```, Picture in Picture mode will be automatically enabled

``` Argument 3 ```: Which corner Picture in Picture mode should be in(If ``` Argument 2 ``` is ``` true ```).
> * ``` 0 ```: Bottom Left corner
> * ``` 1 ```: Bottom Right corner
> * ``` 2 ```: Top Left corner
> * ``` 3 ```: Top Right corner