// Cricket.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Cricket.h"
#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCricketApp

BEGIN_MESSAGE_MAP(CCricketApp, CWinApp)
	//{{AFX_MSG_MAP(CCricketApp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCricketApp construction

CCricketApp::CCricketApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CCricketApp object

CCricketApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CCricketApp initialization

BOOL CCricketApp::InitInstance()
{
	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	if (!CWowWinApp::InitInstance())
		return FALSE;	

	SetInstanceUniqueID(_T("{8E0D8DD3-B9D6-48C4-B7F5-A09F17F5FFF1}"));
	if (!IsInstanceUnique())
		return FALSE;

	SetRegistryKey(_T("Abin"));
	
	CMainFrame* pFrame = new CMainFrame;
	m_pMainWnd = pFrame;

	// create and load the frame with its resources

	pFrame->LoadFrame(IDR_MAINFRAME,
		WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE, NULL,
		NULL);	

	return TRUE;
}
