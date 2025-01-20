Set-Location $HOME\Downloads
New-Item -Path "No.txt"
Set-Content -Path .\No.txt -Value "No Perhaps?" 
notepad.exe "No.txt"

Add-Type -TypeDefinition @'

using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
  // f(), g(), ... are unused COM method slots. Define these if you care
  int f(); int g(); int h(); int i();
  int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
  int j();
  int GetMasterVolumeLevelScalar(out float pfLevel);
  int k(); int l(); int m(); int n();
  int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
  int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
  int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
  int f(); // Unused
  int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio {
  static IAudioEndpointVolume Vol() {
    var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
    IMMDevice dev = null;
    Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
    IAudioEndpointVolume epv = null;
    var epvid = typeof(IAudioEndpointVolume).GUID;
    Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
    return epv;
  }
  public static float Volume {
    get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
    set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
  }
  public static bool Mute {
    get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
    set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
  }
}

'@
#[audio]::Volume = 1
#[audio]::Mute = $false

Invoke-WebRequest -uri "https://archive.org/download/TouhouBadApple/Touhou%20-%20Bad%20Apple.mp4" -OutFile ".\bad.mp4"

#WPF Library for Playing Movie and some components
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.ComponentModel
#XAML File of WPF as windows for playing movie
[xml]$XAML = @"
 
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PowerShell Video Player" Height="355" Width="553" ResizeMode="NoResize">
    <Grid Margin="0,0,2,3">
        <MediaElement Height="250" Width="525" Name="VideoPlayer" LoadedBehavior="Manual" UnloadedBehavior="Stop" Margin="8,10,10,61" />
        <Button Content="Pause" Name="PauseButton" HorizontalAlignment="Left" Margin="236,283,0,0" VerticalAlignment="Top" Width="75"/>
        <Button Content="Play" Name="PlayButton" HorizontalAlignment="Left" Margin="236,283,0,0" VerticalAlignment="Top" Width="75"/>
    </Grid>
</Window>
"@
 
#Movie Path
[uri]$VideoSource = ".\bad.mp4"
 
#Devide All Objects on XAML
$XAMLReader=(New-Object System.Xml.XmlNodeReader $XAML)
$Window=[Windows.Markup.XamlReader]::Load( $XAMLReader )
$VideoPlayer = $Window.FindName("VideoPlayer")
$PauseButton = $Window.FindName("PauseButton")
$PlayButton = $Window.FindName("PlayButton")
 
#Video Default Setting
$VideoPlayer.Volume = 100;
$VideoPlayer.Source = $VideoSource;
$VideoPlayer.Play()
$PauseButton.Visibility = [System.Windows.Visibility]::Hidden
$PlayButton.Visibility = [System.Windows.Visibility]::Hidden
 
#Button click event 
$PlayButton.Add_Click({
    $VideoPlayer.Play()
    $PauseButton.Visibility = [System.Windows.Visibility]::Visible
    $PlayButton.Visibility = [System.Windows.Visibility]::Hidden
})
$PauseButton.Add_Click({
    $VideoPlayer.Pause()
    $PauseButton.Visibility = [System.Windows.Visibility]::Hidden
    $PlayButton.Visibility = [System.Windows.Visibility]::Visible
})
 
#Show Up the Window 
$Window.ShowDialog() | out-null
