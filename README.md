# PSWindowManipulation
Powershell scripts for the manipulation of windows in Windows. Started due to a need to save and restore all window positions after locking/unlocking a laptop connected to multiple monitors. Continued as its fun.

## Functionality Goals

### Version 1

- [ ] Get Windows 
    - [x] Return all windows 
    - [ ] Filter by Main Window handle
    - [ ] Filter by Window Title
    - [ ] Filter by Process Name
- [ ] Move Windows around
    - [ ] Move Window to Desired coordinates
    - [ ] Maximize Window
    - [ ] Minimize Window
    - [ ] Snap Right
    - [ ] Snap Left
    - [ ] Snap Top
    - [ ] Snap Bottom
- [ ] Export windows to config file?
- [ ] Import windows from Config File?

## Version 2

- [ ] Multi-Display Support
    - [x] Get all Active Displays & coordinates
    - [ ] Rebuild object structure so everything isnt a string.
    - [ ] Filter by Display Number
    - [ ] FIlter by Display Position
    - [ ] Move window to target Display
    - [ ] Add display data to window object
- [ ] Windows Virtual Desktop Support
    - [ ] List current Desktops
    - [ ] Create new Desktop
    - [ ] Delete Desktop
    - [ ] Move window to Desktop
    - [ ] Get windows on each Desktop.
- [ ]pipeline support for getting windows
- [ ] Pipeline support for setting Window coordinates  
- [ ] Combine everything into a Module
