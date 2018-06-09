// Cricket.h : main header file for the CRICKET application
//

#if !defined(AFX_CRICKET_H__A9B5E4EE_FCB4_413C_A170_B61B2843EC27__INCLUDED_)
#define AFX_CRICKET_H__A9B5E4EE_FCB4_413C_A170_B61B2843EC27__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols
#include "Includes\WowWinApp.h"

/////////////////////////////////////////////////////////////////////////////
// CCricketApp:
// See Cricket.cpp for the implementation of this class
//

class CCricketApp : public CWowWinApp
{
public:
	CCricketApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCricketApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

public:
	//{{AFX_MSG(CCricketApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CRICKET_H__A9B5E4EE_FCB4_413C_A170_B61B2843EC27__INCLUDED_)
