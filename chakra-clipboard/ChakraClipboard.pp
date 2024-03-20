unit ChakraClipboard;

{$mode delphi}

interface

  uses ChakraTypes;

  function GetJsValue: TJsValue;

implementation

  uses
    Chakra, ChakraErr, ChakraUtils, Win32Clipboard, ChakraClipboardUtils;

  function ClipboardGetText(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := StringAsJsString(GetClipboardText);
  end;

  function ClipboardSetText(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    CheckParams('setText', Args, ArgCount, [jsString], 1);
    Result := BooleanAsJsBoolean(SetClipboardText(JsStringAsString(Args^)));
  end;

  function ClipboardGetFiles(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := WideStringArrayAsJsValue(GetFilesFromClipboard);
  end;

  function ClipboardAddFiles(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Files: TJsValue;
  begin
    Result := Undefined;
    CheckParams('addFilesToClipboard', Args, ArgCount, [jsArray], 1);

    Files := Args^; Inc(Args);

    AddFilesToClipboard(JsValueAsWideStringArray(Files));
  end;

  function GetJsValue;
  begin
    Result := CreateObject;

    SetFunction(Result, 'getText', ClipboardGetText);
    SetFunction(Result, 'setText', ClipboardSetText);

    SetFunction(Result, 'getFilesFromClipboard', ClipboardGetFiles);
    SetFunction(Result, 'addFilesToClipboard', ClipboardAddFiles);

  end;

end.