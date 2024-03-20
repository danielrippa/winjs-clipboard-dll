unit Win32ClipboardTypes;

interface

  uses
    Types, Windows;

  const

    FO_MOVE = $0001;
    FO_COPY = $0002;

    FOF_ALLOWUNDO = $40;
    FOF_NOCONFIRMATION = $10;
    FOF_NOCONFIRMMKDIR = $200;

  type

    TDropFiles = packed record
      pFiles: DWORD;
      pt: TPoint;
      fNC: LongBool;
      fWide: LongBool;
    end;

    PDropFiles = ^TDropFiles;

    TSHFileOpStructW = record
      Wnd: DWORD;
      wFunc: UINT;
      pFrom: PWideChar;
      pTo: PWideChar;
      fFlags: FILEOP_FLAGS;
      fAnyOperationsAborted: BOOL;
      lpzsProgressTitle: PWideChar;
    end;

implementation

end.