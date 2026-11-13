; Script generated for PCut9 - Pro 9 Studio
; Clean Windows Desktop installer for CCTV Monitors

#define MyAppName "PCut9 - Pro 9 Studio"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Pro 9 Surveillance"
#define MyAppExeName "pcut9.exe"

[Setup]
AppId={{D37F61D4-48E0-4E16-92F7-A77E6D7E7321}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\PCut9
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=D:\flutter_projects\pcut9\Installer_Output
OutputBaseFilename=PCut9_Setup
SetupIconFile=..\windows\runner\resources\app_icon.ico
Compression=lzma2/fast
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\x64\runner\Release\ffmpeg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\PCut9"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\PCut9"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

