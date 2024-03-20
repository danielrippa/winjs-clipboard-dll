unit Win32Clipboard;

{$mode delphi}

interface

  uses
    Win32Types;

  function GetClipboardText: WideString;
  function SetClipboardText(aText: UnicodeString): Boolean;

  function GetFilesFromClipboard: WideStringArray;
  function AddFilesToClipboard(aFiles: WideStringArray): Boolean;

implementation

  uses
    Windows, Win32ClipboardTypes, Shell32, SysUtils, ChakraErr;

  function AddDataToClipboard(Format: UINT; const Data; Size: PtrUint): Boolean;
  var
    Handle: THandle;
    P: Pointer;
  begin
    Result := False;
    Handle := GlobalAlloc(GMEM_MOVEABLE, Size);
    if Handle <> 0 then begin
      P := GlobalLock(Handle);
      if P <> Nil then begin
        Move(Data, P^, Size);
        GlobalUnlock(Handle);
        Result := SetClipboardData(Format, Handle) <> 0;
      end;
    end;
  end;

  function GetClipboardText;
  var
    Handle: THandle;
    P: PWideChar;
  begin

    Result := '';

    if OpenClipboard(0) then begin
      try
        Handle := GetClipboardData(CF_UNICODETEXT);
        if Handle <> 0 then begin
          try
            P := PWideChar(GlobalLock(Handle));

            Result := WideString(P);

          finally
            if Handle <> 0 then begin
              GlobalUnlock(Handle);
            end;
          end;
        end;
      finally
        CloseClipboard;
      end;
    end;

  end;

  function SetClipboardText;
  begin

    if OpenClipboard(0) then begin
      try
        if EmptyClipboard then begin
          Result := AddDataToClipboard(CF_UNICODETEXT, Pointer(aText)^, SizeOf(UnicodeChar) * (Length(aText) + 1));
        end;
      finally
      end;
    end;

  end;

  function GetFilesFromClipboard;
  var
    DropHandle: HDROP;
    Count: Integer;
    I: Integer;
    FileNameLength: Integer;
    FileName: array[0..MAX_PATH] of WideChar;
  begin

    if OpenClipboard(0) then begin

      try

        DropHandle := HDROP(GetClipboardData(CF_HDROP));
        if DropHandle <> 0 then begin

          Count := DragQueryFileW(DropHandle, $FFFFFFFF, Nil, 0);
          SetLength(Result, Count);

          for I := 0 to Count - 1 do begin

            DragQueryFileW(DropHandle, I, FileName, Length(FileName));
            Result[I] := FileName;

          end;

        end;

      finally

        CloseClipboard;

      end;

    end;

  end;

  function AddFilesToClipboard;
  var
    DropFiles: PDropFiles;
    Memory: HGLOBAL;
    Size: Integer;
    I: Integer;
    P: PWideChar;
  begin

    Result := True;

    Size := SizeOf(TDropFiles);

    for I := 0 to Length(aFiles) - 1 do begin

      Size := Size + (Length(aFiles[I]) + 1) * SizeOf(WideChar);
      Inc(Size);

    end;

    Memory := GlobalAlloc(GHND or GMEM_SHARE, Size);
    DropFiles := GlobalLock(Memory);

    try

      DropFiles^.pFiles := SizeOf(TDropFiles);
      DropFiles^.fWide := True;

      P := PWideChar(DropFiles) + SizeOf(TDropFiles) div SizeOf(WideChar);

      for I := 0 to Length(aFiles) - 1 do begin

        lstrcpynW(
          P,
          PWideChar(aFiles[I]),
          Length(aFiles[I]) + 1
        );

        Inc(P, Length(aFiles[I]) + 1);

      end;

      if OpenClipboard(0) then begin

        try

          EmptyClipboard;
          SetClipboardData(CF_HDROP, Memory);

        finally

          CloseClipboard;

        end;

      end else begin

        Result := False;

      end;

    finally

      GlobalUnlock(Memory);

    end;

  end;

end.