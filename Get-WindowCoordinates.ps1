<#
.SYNOPSIS
Gets coordinates for a windowed process

.DESCRIPTION
Gets the coordinates for a windowed process using the process ID and returns a PSCustomobject containing the
coordinates of the process window. 

.INPUTS
ID of process

.OUTPUTS
PSCustomobject

.NOTES
https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.host.size?view=pscore-6.2.0
https://devblogs.microsoft.com/scripting/weekend-scripter-manage-window-placement-by-using-pinvoke/ 
https://superuser.com/questions/1324007/setting-window-size-and-position-in-powershell-5-and-6
http://pinvoke.net/default.aspx/user32/GetWindowRect.html 

v0.1 10/18/2019
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [String]$MainWindowHandle,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ParameterSetName=’TargetProcess’)]
    [String]$ProcessName,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ParameterSetName=’AllWindows’)]
    [switch]$AllWindows
)

#Add window rect type to session. 
Add-Type @"

    using System;
    using System.Runtime.InteropServices;
    public class Window {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    }
    public struct RECT
    {
    public int Left;        // x position of upper-left corner
    public int Top;         // y position of upper-left corner
    public int Right;       // x position of lower-right corner
    public int Bottom;      // y position of lower-right corner
    }

"@

#func definitino

function get-windowrect {
    param (
        [string]$Handle
    )

    $WindowRectangle = New-Object RECT 
    $HasWindow = [Window]::GetWindowRect($Handle,[ref]$WindowRectangle)
    if ($HasWindow){
        $windowWidth = $WindowRectangle.Right - $WindowRectangle.Left
        $WindowHeight = $WindowRectangle.Bottom - $WindowRectangle.Top
        $WindowSize = New-Object System.Management.Automation.Host.Size -ArgumentList $WindowWidth, $WindowHeight
        $TopLeft = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $WindowRectangle.Left, $WindowRectangle.Top
        $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $WindowRectangle.Right, $WindowRectangle.Bottom
        $Object = [pscustomobject]@{
            ProcessName = $ProcessName
            Size = $WindowSize
            TopLeft = $TopLeft
            BottomRight = $BottomRight
        }
        $Object.PSTypeNames.insert(0,'System.Automation.WindowInfo')
        $Object
    }    

}

#begin
if (!($ProcessName) -and ($MainWindowHandle)){
    $ProcessName = (get-process | Where-Object {$_.MainwindowHandle -eq $MainWindowHandle}).ProcessName
}
if ($AllWindows)  {
    #get all processes with window titles
    $ActiveWindows = Get-Process |where-object {$_.mainWindowTitle} | Select-Object id,name,mainwindowtitle,mainwindowhandle 
}

$ActiveWindows |ForEach-Object {
    get-windowrect -Handle $_.mainwindowhandle
}
