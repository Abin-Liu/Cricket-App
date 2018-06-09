// CricketThread.cpp: implementation of the CCricketThread class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Cricket.h"
#include "CricketThread.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CCricketThread::CCricketThread()
{
	m_dwMainKey = AfxGetApp()->GetProfileInt("", "Main Key", 0);
	m_dwInteractKey = AfxGetApp()->GetProfileInt("", "Interact Key", 0);
}

CCricketThread::~CCricketThread()
{
	AfxGetApp()->WriteProfileInt("", "Main Key", m_dwMainKey);
	AfxGetApp()->WriteProfileInt("", "Interact Key", m_dwInteractKey);
	Stop();
}

BOOL CCricketThread::AreKeysValid() const
{
	return m_dwMainKey && m_dwInteractKey;
}

DWORD CCricketThread::ThreadProc()
{
	while (!IsStopping())
	{
		ReleaseAllKeys(); // Clean keyboard states

		COLORREF color = -1;
		if (UpdateAlertStatus(POS_TOP, &color) == ALERT_STOP)
			return 0;

		if (!IsAlerting())
		{
			if (color == PIXEL_BLUE)
			{
				KeyStroke(m_dwMainKey);
			}
			else if (color == PIXEL_YELLOW)
			{
				KeyStroke(m_dwInteractKey);
			}
		}
		
		ConditionalSleep(200);
	}

	return 0;
}

DWORD CCricketThread::GetMainKey() const
{
	return m_dwMainKey;
}

DWORD CCricketThread::GetInteractKey() const
{
	return m_dwInteractKey;
}

void CCricketThread::SetMainKey(DWORD dwKey)
{
	m_dwMainKey = dwKey;
}

void CCricketThread::SetInteractKey(DWORD dwKey)
{
	m_dwInteractKey = dwKey;
}
