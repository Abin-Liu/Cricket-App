; �ű��� Inno Setup �ű��� ���ɣ�
; �йش��� Inno Setup �ű��ļ�����ϸ��������İ����ĵ���

#define MyAppName "ħ�޴���"
#define MyAppEngName "Cricket"
#define MyAppExeName "Cricket.exe"
#define MyAppRegPathKey "Path"
#define MyAppVersion GetFileVersion("Cricket.exe")
#define MyAppPublisher "Abin"
#define MyAppURL "http://www.jindu-wx.com/"

[Setup]
; ע: AppId��ֵΪ������ʶ��Ӧ�ó���
; ��ҪΪ������װ����ʹ����ͬ��AppIdֵ��
; (�����µ�GUID����� ����|��IDE������GUID��)
AppId={{8A3B1678-02DB-49BA-B333-B79E0247FA4A}
AppMutex={{8E0D8DD3-B9D6-48C4-B7F5-A09F17F5FFF1}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppCopyright=Copyright (C) 2013, {#MyAppPublisher}
LicenseFile=EULA.rtf
PrivilegesRequired=admin

DefaultDirName={reg:HKLM\Software\{#MyAppPublisher}\{#MyAppEngName},{#MyAppRegPathKey}|{pf}\{#MyAppEngName}}
DefaultGroupName={#MyAppName}
OutputBaseFilename={#MyAppEngName}_Setup {#MyAppVersion}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppEngName}.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "Shutdown.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "InputThread.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "UI\*"; DestDir: "{app}\UI\"; Flags: ignoreversion recursesubdirs
; ע��: ��Ҫ���κι���ϵͳ�ļ���ʹ�á�Flags: ignoreversion��

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopiconName: "{commonprograms}\{#MyAppName}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commonprograms}\{#MyAppName}\ʹ�ð���"; Filename: "{app}\{#MyAppEngName}.chm"
Name: "{commonprograms}\{#MyAppName}\ж��"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "-installaddon"
Filename: "{app}\{#MyAppExeName}"; Description: "����{#MyAppName}"; Flags: nowait postinstall
Filename: "hh.exe"; Parameters: "{app}\{#MyAppEngName}.chm"; Description: "�鿴ʹ�ð���"; Flags: nowait postinstall

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "-uninstalladdon"

[Registry]
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppEngName}"; ValueType: string; ValueName: {#MyAppRegPathKey}; ValueData: "{app}"


