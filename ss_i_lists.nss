/*
Filename:           ss_i_lists
System:             Core (Include Script)
Author:             Sherincall (Sherincall@gmail.com)
Date Created:       March 20, 2009
Summary:

This is the include file for functions dealing with lists. The scripts contained
herein are based on those included in Greyhawk0's (original Z-Dialog by pspeed)
ZZ-Dialog, customized for compatibility with Shadows & Silver's needs.

Original filename under Z-Dialog: zdlg_lists
Copyright (c) 2004 Paul Speed - BSD licensed.
NWN Tools - http://nwntools.sf.net/
Additions and changes from original copyright (c) 2005-2006 Greyhawk0


Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

const string SS_LIST_PREFIX = "SS_List:";



////////////////////////////
// ********************** \\
//    Shared Variables    \\
// ********************** \\
////////////////////////////
string sCurrentList = "";
object oCurrentHolder = OBJECT_INVALID;
int nCurrentCount = 0;
int nCurrentIndex = -1;


////////////////////////////
// ********************** \\
//  Functions Prototypes  \\
// ********************** \\
////////////////////////////




// >----< ss_GetElementCount >----<
// <ss_i_lists>
// Returns the number of items in the specified list.
int ss_GetElementCount(string sList, object oHolder);

// >----< ss_RemoveElement >----<
// <ss_i_lists>
// Removes the list element at the specified index.  Returns the new item count.
int ss_RemoveElement(int nIndex, string sList, object oHolder);

// >----< ss_RemoveElements >----<
// <ss_i_lists>
// Removes the list elements from nStart to nEnd-1 inclusive at the
// specified index.  Returns the new item count.
int ss_RemoveElements(int nStart, int nEnd, string sList, object oHolder);

// >----< ss_InsertElement >----<
// <ss_i_lists>
// Inserts a blank entry into the specified index.  Returns the new item count.
int ss_InsertElement(int nIndex, string sList, object oHolder);

// >----< ss_DeleteList >----<
// <ss_i_lists>
// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
int ss_DeleteList(string sList, object oHolder);



///// STRING Prototypes

// >----< ss_AddStringElement >----<
// <ss_i_lists>
// Adds a string item to the list and return the new item count.
int ss_AddStringElement(string sItem, string sList, object oHolder);

// >----< ss_GetStringElement >----<
// <ss_i_lists>
// Returns the string item at the specified index.
string ss_GetStringElement(int nIndex, string sList, object oHolder);

// >----< ss_PopStringElement >----<
// <ss_i_lists>
// Removes the string item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
string ss_PopStringElement(string sList, object oHolder);

// >----< ss_ReplaceStringElement >----<
// <ss_i_lists>
// Replaces the string at the specified index.  Returns the old string.
string ss_ReplaceStringElement(int nIndex, string sValue, string sList, object oHolder);

// >----< ss_GetFirstStringElement >----<
// <ss_i_lists>
// Begins a list iteration for string values
string ss_GetFirstStringElement(string sList, object oHolder);

// >----< ss_GetNextStringElement >----<
// <ss_i_lists>
// Returns the next item in a list iteration
string ss_GetNextStringElement();



//// OBJECT Prototypes

// >----< ss_AddObjectElement >----<
// <ss_i_lists>
// Adds an object item to the list and return the new item count.
int ss_AddObjectElement(object oItem, string sList, object oHolder);

// >----< ss_GerObjectElement >----<
// <ss_i_lists>
// Returns the object item at the specified index.
object ss_GetObjectElement(int nIndex, string sList, object oHolder);

// >----< ss_PopObjectElement >----<
// <ss_i_lists>
// Removes the object item from the end of the list and returns it.
// Note: this will orphan any other types the might be stored at the same list location.
object ss_PopObjectElement(string sList, object oHolder);

// >----< ss_ReplaceObjectElement >----<
// <ss_i_lists>
// Replaces the object at the specified index.  Returns the old string.
object ss_ReplaceObjectElement(int nIndex, object oValue, string sList, object oHolder);

// >----< ss_GetFirstObjectElement >----<
// <ss_i_lists>
// Begins a list iteration for object values
object ss_GetFirstObjectElement(string sList, object oHolder);

// >----< ss_GetNextObjectElement >----<
// <ss_i_lists>
// Returns the next item in an object list iteration
object ss_GetNextObjectElement();




//// INT Prototypes

// >----< ss_AddIntElement >----<
// <ss_i_lists>
// Adds an int item to the list and return the new item count.
int ss_AddIntElement(int nItem, string sList, object oHolder);

// >----< ss_GetIntElement >----<
// <ss_i_lists>
// Returns the int item at the specified index.
int ss_GetIntElement(int nIndex, string sList, object oHolder);

// >----< ss_PopIntElement >----<
// <ss_i_lists>
// Removes the int item from the end of the list and returns it.
// Note: this will orphan any other types the might be stored at the same list location.
int ss_PopIntElement(string sList, object oHolder);

// >----< ss_ReplaceIntElement >----<
// <ss_i_lists>
// Replaces the int at the specified index.  Returns the old int.
int ss_ReplaceIntElement(int nIndex, int nValue, string sList, object oHolder);

// >----< ss_GetFirstIntElement >----<
// <ss_i_lists>
// Begins a list iteration for int nValues
int ss_GetFirstIntElement(string sList, object oHolder);

// >----< ss_GetNextIntElement >----<
// <ss_i_lists>
// Returns the next item in a list iteration
int ss_GetNextIntElement();





// Internal function to get the string for a given index
string ss_IndexToString(int nIndex, string sList)
{
    return(SS_LIST_PREFIX + sList + "." + IntToString(nIndex));
}


int ss_GetElementCount(string sList, object oHolder)
{
    return(GetLocalInt(oHolder, SS_LIST_PREFIX + sList));
}


int ss_RemoveElement(int nIndex, string sList, object oHolder)
{
    int nCount = ss_GetElementCount(sList, oHolder);

    if(nCount == 0) return(nCount);


    // Shift all of the other elements forward
    int i;
    string sNext;
    for(i = nIndex; i < nCount - 1; i++)
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string sCurrent = ss_IndexToString(i, sList);
        sNext = ss_IndexToString(i + 1, sList);

        SetLocalFloat(oHolder, sCurrent, GetLocalFloat(oHolder, sNext));
        SetLocalInt(oHolder, sCurrent, GetLocalInt(oHolder, sNext));
        SetLocalLocation(oHolder, sCurrent, GetLocalLocation(oHolder, sNext));
        SetLocalObject(oHolder, sCurrent, GetLocalObject(oHolder, sNext));
        SetLocalString(oHolder, sCurrent, GetLocalString(oHolder, sNext));
        }

    // Delete the top item
    DeleteLocalFloat(oHolder, sNext);
    DeleteLocalInt(oHolder, sNext);
    DeleteLocalLocation(oHolder, sNext);
    DeleteLocalObject(oHolder, sNext);
    DeleteLocalString(oHolder, sNext);

    nCount--;
    SetLocalInt(oHolder, SS_LIST_PREFIX + sList, nCount);

    return(nCount);
}



int ss_RemoveElements(int nStart, int nEnd, string sList, object oHolder)
{
    int nCount = ss_GetElementCount( sList, oHolder );

    if( nCount == 0 )   return( nCount );

    // Shift all of the other elements forward
    int i;
    string sNext;
    int nRemoveCount = nEnd - nStart;
    for(i = nStart; i < nCount - nRemoveCount; i++ )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string sCurrent = ss_IndexToString( i, sList );
        sNext = ss_IndexToString( i + nRemoveCount, sList );

        SetLocalFloat( oHolder, sCurrent, GetLocalFloat( oHolder, sNext ) );
        SetLocalInt( oHolder, sCurrent, GetLocalInt( oHolder, sNext ) );
        SetLocalLocation( oHolder, sCurrent, GetLocalLocation( oHolder, sNext ) );
        SetLocalObject( oHolder, sCurrent, GetLocalObject( oHolder, sNext ) );
        SetLocalString( oHolder, sCurrent, GetLocalString( oHolder, sNext ) );
        }

    // Delete the top items
    for( i = nCount - nRemoveCount; i < nCount; i++ )
        {
        sNext = ss_IndexToString( i, sList );
        DeleteLocalFloat( oHolder, sNext );
        DeleteLocalInt( oHolder, sNext );
        DeleteLocalLocation( oHolder, sNext );
        DeleteLocalObject( oHolder, sNext );
        DeleteLocalString( oHolder, sNext );
        }

    nCount -= nRemoveCount;
    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount );

    return( nCount );
}



int ss_InsertElement( int nIndex, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );

    // Shift all of the other elements backwards
    int i;
    string sNext;
    for( i = nCount - 1; i >= nIndex; i-- )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string sCurrent = ss_IndexToString( i, sList );
        sNext = ss_IndexToString( i + 1, sList );

        SetLocalFloat( oHolder, sNext, GetLocalFloat( oHolder, sCurrent ) );
        SetLocalInt( oHolder, sNext, GetLocalInt( oHolder, sCurrent ) );
        SetLocalLocation( oHolder, sNext, GetLocalLocation( oHolder, sCurrent ) );
        SetLocalObject( oHolder, sNext, GetLocalObject( oHolder, sCurrent ) );
        SetLocalString( oHolder, sNext, GetLocalString( oHolder, sCurrent ) );
        }

    // Delete the old values from the index since
    // it should be empty now
    string sCurrent = ss_IndexToString( nIndex, sList );
    DeleteLocalFloat( oHolder, sCurrent );
    DeleteLocalInt( oHolder, sCurrent );
    DeleteLocalLocation( oHolder, sCurrent );
    DeleteLocalObject( oHolder, sCurrent );
    DeleteLocalString( oHolder, sCurrent );

    nCount++;
    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount );

    return( nCount );
}



int ss_DeleteList( string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nCount == 0 )
        return( nCount );

    // Delete all elements
    int i;
    for( i = 0; i < nCount; i++ )
        {
        string sCurrent = ss_IndexToString( i, sList );
        DeleteLocalFloat( oHolder, sCurrent );
        DeleteLocalInt( oHolder, sCurrent );
        DeleteLocalLocation( oHolder, sCurrent );
        DeleteLocalObject( oHolder, sCurrent );
        DeleteLocalString( oHolder, sCurrent );
        }

    // Delete the main list info
    DeleteLocalInt( oHolder, SS_LIST_PREFIX + sList );

    return( nCount );
}




int ss_AddStringElement( string sItem, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    SetLocalString( oHolder, ss_IndexToString( nCount, sList ), sItem );
    nCount++;
    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount );

    return( nCount );
}

// Returns the string item at the specified index.
string ss_GetStringElement( int nIndex, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nIndex >= nCount )
        {
        PrintString( "Error: (GetStringItem) index out of bounds["
                     + IntToString(nIndex) + "] in list:" + sList );
        return( "" );
        }
    return( GetLocalString( oHolder, ss_IndexToString( nIndex, sList ) ) );
}



string ss_PopStringElement( string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    string nIndex = ss_IndexToString( nCount - 1, sList );
    string sValue = GetLocalString( oHolder, nIndex );

    // Delete the values
    DeleteLocalString( oHolder, nIndex );

    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount - 1 );

    return( sValue );
}



string ss_ReplaceStringElement( int nIndex, string sValue, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nIndex >= nCount )
        {
        PrintString( "Error: (ReplaceStringItem) index out of bounds[" + IntToString(nIndex)
                     + "] in list:" + sList );
        return( "" );
        }

    string sOriginal = GetLocalString( oHolder, ss_IndexToString( nIndex, sList ) );
    SetLocalString( oHolder, ss_IndexToString( nIndex, sList ), sValue );

    return( sOriginal );
}


string ss_GetFirstStringElement( string sList, object oHolder )
{
    nCurrentCount = ss_GetElementCount( sList, oHolder );
    nCurrentIndex = 0;
    return( GetLocalString( oHolder, ss_IndexToString( nCurrentIndex++, sList ) ) );
}


string ss_GetNextStringElement()
{
    if( nCurrentIndex >= nCurrentCount )
        return( "" );
    return( GetLocalString( oCurrentHolder, ss_IndexToString( nCurrentIndex++, sCurrentList ) ) );
}




int ss_AddObjectElement( object oItem, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    SetLocalObject( oHolder, ss_IndexToString( nCount, sList ), oItem );
    nCount++;
    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount );

    return( nCount );
}



object ss_GetObjectElement( int nIndex, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nIndex >= nCount )
        {
        PrintString( "Error: (GetObjectItem) index out of bounds[" + IntToString(nIndex)
                     + "] in list:" + sList );
        return( OBJECT_INVALID );
        }
    return( GetLocalObject( oHolder, ss_IndexToString( nIndex, sList ) ) );
}




object ss_PopObjectElement( string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    string nIndex = ss_IndexToString( nCount - 1, sList );
    object oValue = GetLocalObject( oHolder, nIndex );

    // Delete the values
    DeleteLocalObject( oHolder, nIndex );

    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount - 1 );

    return( oValue );
}



object ss_ReplaceObjectElement( int nIndex, object oValue, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nIndex >= nCount )
        {
        PrintString( "Error: (ReplaceObjectItem) index out of bounds[" + IntToString(nIndex)
                     + "] in list:" + sList );
        return( OBJECT_INVALID );
        }

    object oOriginal = GetLocalObject( oHolder, ss_IndexToString( nIndex, sList ) );
    SetLocalObject( oHolder, ss_IndexToString( nIndex, sList ), oValue );

    return( oOriginal );
}



object ss_GetFirstObjectElement( string sList, object oHolder )
{
    sCurrentList = sList;
    oCurrentHolder = oHolder;
    nCurrentCount = ss_GetElementCount( sList, oHolder );
    nCurrentIndex = 0;
    return( GetLocalObject( oHolder, ss_IndexToString( nCurrentIndex++, sList ) ) );
}



object ss_GetNextObjectElement()
{
    if( nCurrentIndex >= nCurrentCount )
        return( OBJECT_INVALID );
    return( GetLocalObject( oCurrentHolder, ss_IndexToString( nCurrentIndex++, sCurrentList ) ) );
}


int ss_AddIntElement( int nItem, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    SetLocalInt( oHolder, ss_IndexToString( nCount, sList ), nItem );
    nCount++;
    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount );

    return( nCount );
}



int ss_GetIntElement( int nIndex, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nIndex >= nCount )
        {
        PrintString( "Error: (GetIntItem) index out of bounds[" + IntToString(nIndex)
                     + "] in list:" + sList );
        return( -1 );
        }
    return( GetLocalInt( oHolder, ss_IndexToString( nIndex, sList ) ) );
}




int ss_PopIntElement( string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    string nIndex = ss_IndexToString( nCount - 1, sList );
    int nValue = GetLocalInt( oHolder, nIndex );

    // Delete the values
    DeleteLocalInt( oHolder, nIndex );

    SetLocalInt( oHolder, SS_LIST_PREFIX + sList, nCount - 1 );

    return( nValue );
}



int ss_ReplaceIntElement( int nIndex, int nValue, string sList, object oHolder )
{
    int nCount = ss_GetElementCount( sList, oHolder );
    if( nIndex >= nCount )
        {
        PrintString( "Error: (ReplaceIntItem) index out of bounds[" + IntToString(nIndex)
                     + "] in list:" + sList );
        return( -1 );
        }

    int nOriginal = GetLocalInt( oHolder, ss_IndexToString( nIndex, sList ) );
    SetLocalInt( oHolder, ss_IndexToString( nIndex, sList ), nValue );

    return( nOriginal );
}



int GetFirstIntElement( string sList, object oHolder )
{
    nCurrentCount = ss_GetElementCount( sList, oHolder );
    nCurrentIndex = 0;
    return( GetLocalInt( oHolder, ss_IndexToString( nCurrentIndex++, sList ) ) );
}



int GetNextIntElement()
{
    if( nCurrentIndex >= nCurrentCount )
        return( -1 );
    return( GetLocalInt( oCurrentHolder, ss_IndexToString( nCurrentIndex++, sCurrentList ) ) );
}


// void main(){}
