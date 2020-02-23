# PowerShell "Open Here" Module
PowerShell module that enables "Open here" shortcuts functionality for Windows PowerShell, Terminal and CMD.

# Introduction
OpenHere is a PowerShell module for installation of shell shortcuts into the context menu (_the right mouse button click or [the menu key](https://en.wikipedia.org/wiki/Menu_key)_) for Microsoft Windows.

The shortcuts will open desired shell in the current location, e.g. for Windows PowerShell `$PWD` will be set to the location from which the shortcut was invoked.

![Preview](https://github.com/KUTlime/PowerShell-Open-Here-Module/raw/master/assets/Overview.png)


# Main features
- Shortcut installation/removal for Windows PowerShell, Terminal, CMD
- Open here with non-elevated privileges shortcut.
- Open here with elevated privileges shortcut.
- Default setting for easy-to-use.
- Fully customizable shortcut names.
- Shortcut availability on directory, drive, directory background, user's desktop.
- Rollback of all shell modifications.
- Works offline.
- Well documented

# Basic use
To install the OpenHere module, just type following command into your PowerShell session with elevated privileges.

```powershell
Install-Module -Name OpenHere
```

Now, you can use the module as you wish. For shortcut installation:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsPowerShell
```
![Preview](https://raw.githubusercontent.com/KUTlime/PowerShell-Open-Here-Module/master/assets/Default.png)

For other shortcuts just type:
```powershell
Set-OpenHereShortcut -ShortcutType:Terminal
Set-OpenHereShortcut -ShortcutType:CMD
```

For a custom shortcut & command names, fill parameters accordingly:
```powershell
Set-OpenHereShortcut -ShortcutType:Terminal -RootName 'Old PowerShell' -OpenHere 'I''m lazy' -OpenHereAsAdmin 'I''m lazy admin`
```

or the equivalent with a escape backtick:
```powershell
Set-OpenHereShortcut -ShortcutType:WindowsPowerShell`
-RootName 'Old PowerShell' `
-OpenHere 'I''m lazy' `
-OpenHereAsAdmin 'I''m lazy admin
```

![Preview](https://raw.githubusercontent.com/KUTlime/PowerShell-Open-Here-Module/master/assets/Custom.png)

To remove the shortcut with any settings, just call:
```powershell
Remove-OpenHereShortcut -ShortcutType:Terminal
```

For more details about setting/removing process, type:
```powershell
Set-OpenHereShortcut -ShortcutType:Terminal -Verbose
Remove-OpenHereShortcut -ShortcutType:Terminal -Verbose
```
respectively. 

For more examples, type: 
```powershell
Get-Help Set-OpenHereWindowsPowerShellShortcut -Examples
```

# FAQ
## Are there any plans to extend the functionality of this module?
Yes, see the section [Planned features.](https://github.com/KUTlime/PowerShell-Open-Here-Module#Planned-features)

## Can I customize the shortcut icon?
Yes, override the `Icon.ico` file in `%LOCALAPPDATA%\OpenHere\ShellType` and you are good to go.

## Can I override the names?
Yes, just run `Set-OpenHereWindowsPowerShellShortcut` with a new configuration.

## Is the name limited to English?
No, the shortcut names supports Unicode and this is only limitation as I'm aware of.

# Planned features
* PowerShell Core
  * A customizable functionality. The Windows installation of PowerShell Core doesn't support any customization of the shell shortcuts so far.
  * Waiting for PowerShell Core 7.0.0 RTM as primary support target.

# Links
[OpenHere module at PowerShell Gallery](https://www.powershellgallery.com/packages/OpenHere)

# Attribution
[Get-Icon](https://github.com/Duffney/PowerShell/blob/master/FileSystems/Get-Icon.ps1)<br>
[CMD icon](https://www.iconfinder.com/icons/16824/cmd_icon)
[PowerShell icon](https://www.freeiconspng.com/downloadimg/17194)
