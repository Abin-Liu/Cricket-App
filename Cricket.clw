; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CConfigDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "Cricket.h"
LastPage=0

ClassCount=4
Class1=CCricketApp
Class3=CMainFrame
Class4=CAboutDlg

ResourceCount=3
Resource1=IDR_MAINFRAME
Class2=CConfigDlg
Resource2=IDD_ABOUTBOX
Resource3=IDD_CONFIGDLG

[CLS:CCricketApp]
Type=0
HeaderFile=Cricket.h
ImplementationFile=Cricket.cpp
Filter=N
BaseClass=CWinApp
VirtualFilter=AC
LastObject=CCricketApp

[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T
BaseClass=CWoWMainFrame
VirtualFilter=fWC
LastObject=CMainFrame




[CLS:CAboutDlg]
Type=0
HeaderFile=Cricket.cpp
ImplementationFile=Cricket.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_POPUP_CONFIG
Command2=ID_POPUP_AUTOCLOSE
Command3=ID_APP_HELP
Command4=ID_POPUP_ABOUT
Command5=ID_APP_EXIT
CommandCount=5

[DLG:IDD_CONFIGDLG]
Type=1
Class=CConfigDlg
ControlCount=6
Control1=IDC_STATIC,static,1342308352
Control2=IDC_MAIN,edit,1350631552
Control3=IDC_STATIC,static,1342308352
Control4=IDC_INTERACT,edit,1350631552
Control5=IDOK,button,1342242817
Control6=IDCANCEL,button,1342242816

[CLS:CConfigDlg]
Type=0
HeaderFile=ConfigDlg.h
ImplementationFile=ConfigDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=CConfigDlg
VirtualFilter=dWC

