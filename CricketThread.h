// CricketThread.h: interface for the CCricketThread class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CRICKETTHREAD_H__05149ECE_B0C8_4340_97B6_7B011F1FDD38__INCLUDED_)
#define AFX_CRICKETTHREAD_H__05149ECE_B0C8_4340_97B6_7B011F1FDD38__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Includes\InputThread.h"

class CCricketThread : public CInputThread
{
public:	
	enum { MSG_ALERT = CInputThread::MSG_APP + 1 };
	void SetInteractKey(DWORD dwKey);
	void SetMainKey(DWORD dwKey);
	DWORD GetInteractKey() const;
	DWORD GetMainKey() const;

	CCricketThread();
	virtual ~CCricketThread();
	BOOL AreKeysValid() const;

protected:

	DWORD ThreadProc();
	DWORD m_dwMainKey;
	DWORD m_dwInteractKey;
};

#endif // !defined(AFX_CRICKETTHREAD_H__05149ECE_B0C8_4340_97B6_7B011F1FDD38__INCLUDED_)
