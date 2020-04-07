# PowerShell "Open Here" Module
PowerShell module that enables "Open here" shortcuts functionality for Windows PowerShell, PowerShell Core, Windows Terminal and CMD.

# Introduction
OpenHere is a PowerShell module for installation of shell shortcuts into the context menu (_the right mouse button click or [the menu key](https://en.wikipedia.org/wiki/Menu_key)_) for Microsoft Windows.

The shortcuts will open desired shell in the current location, e.g. for Windows PowerShell `$PWD` will be set to the location from which the shortcut was invoked.

![Preview](https://github.com/KUTlime/PowerShell-Open-Here-Module/raw/master/assets/Overview.png)


# Main features
- Shortcut installation/removal for Windows PowerShell, Windows Terminal, CMD
- Open here with non-elevated privileges shortcut.
- Open here with elevated privileges shortcut.
- Default setting for easy-to-use.
- Fully customizable shortcut names.
- Shortcut availability on **directory, drive, directory background, user's desktop**.
- Rollback of all shell modifications.
- Works offline.
- Well documented

# Basic use
To install the OpenHere module, just type following command into your PowerShell session with elevated privileges.

```powershell
Install-Module -Name OpenHere
Import-Module -Name OpenHere
```

Now, you can use the module as you wish. For shortcut installation:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsPowerShell
```
![Preview](https://raw.githubusercontent.com/KUTlime/PowerShell-Open-Here-Module/master/assets/Default.png)

For other shortcuts just type:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsTerminal
Set-OpenHereShortcut -ShortcutType:CMD
Set-OpenHereShortcut -ShortcutType:PowerShellCore
```

For a custom shortcut & command names, fill parameters accordingly:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsPowerShell -RootName 'Old PowerShell' -OpenHere 'I''m lazy' -OpenHereAsAdmin 'I''m lazy admin`
```

or the equivalent with the escape backtick:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsPowerShell`
-RootName 'Old PowerShell' `
-OpenHere 'I''m lazy' `
-OpenHereAsAdmin 'I''m lazy admin
```

![Preview](https://raw.githubusercontent.com/KUTlime/PowerShell-Open-Here-Module/master/assets/Custom.png)

To remove the shortcut with any settings, just call:
```powershell
Remove-OpenHereShortcut -ShortcutType:WindowsTerminal
```

For more details about setting/removing process, type:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsTerminal -Verbose
Remove-OpenHereShortcut -ShortcutType:WindowsTerminal -Verbose
```
respectively. 

For more examples, type: 
```powershell
Get-Help Set-OpenHereShortcut -Examples
```

# Notes
Windows Terminal doesn't responds to RunAs request from the context menu. This problem is a limitation of the UWP platform. A workaround has been implemented to support Windows Terminal shortcut with elevated privileges. A similar workaround had to be implemented for non-elevated Open here Windows Terminal shortcut to support scenarios when requests are invoked from RMB clicks on a directory or a drive letter.

# FAQ
### Are there any plans to extend the functionality of this module?
Yes, see the section [Planned features.](https://github.com/KUTlime/PowerShell-Open-Here-Module#Planned-features)

### Can I customize the shortcut icon?
Yes, override the `Icon.ico` file in `%LOCALAPPDATA%\OpenHere\[ShellType]` and you are good to go.

### Can I override the names?
Yes, just run `Set-OpenHereShortcut` with a new configuration.

### Is the name limited to English?
No, the shortcut names supports Unicode and this is only limitation as I'm aware of.

# Links
[OpenHere module at PowerShell Gallery](https://www.powershellgallery.com/packages/OpenHere)

# Attributions
[Get-Icon](https://github.com/Duffney/PowerShell/blob/master/FileSystems/Get-Icon.ps1)<br>
[CMD icon](https://www.iconfinder.com/icons/16824/cmd_icon)<br>
[PowerShell icon](https://www.freeiconspng.com/downloadimg/17194)<br>
[PowerShell Core icon](https://github.com/PowerShell/PowerShell/tree/master/assets)
