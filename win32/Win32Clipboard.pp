unit Win32Clipboard;

{$mode delphi}

interface

  function GetClipboardText: UnicodeString;
  function SetClipboardText(aText: UnicodeString): Boolean;

implementation

  uses Windows;

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

            Result := UnicodeString(P);

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

end.