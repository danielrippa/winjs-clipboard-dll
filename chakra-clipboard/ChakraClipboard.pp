unit ChakraClipboard;

{$mode delphi}

interface

  uses ChakraTypes;

  function GetJsValue: TJsValue;

implementation

  uses Chakra, ChakraUtils, Win32Clipboard;

  function ClipboardGetText(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := StringAsJsString(GetClipboardText);
  end;

  function ClipboardSetText(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    CheckParams('setText', Args, ArgCount, [jsString], 1);
    Result := BooleanAsJsBoolean(SetClipboardText(JsStringAsString(Args^)));
  end;

  function GetJsValue;
  begin
    Result := CreateObject;

    SetFunction(Result, 'getText', ClipboardGetText);
    SetFunction(Result, 'setText', ClipboardSetText);

  end;

end.