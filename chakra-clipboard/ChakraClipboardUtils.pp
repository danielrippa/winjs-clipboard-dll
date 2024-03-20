unit ChakraClipboardUtils;

{$mode delphi}

interface

  uses
    ChakraTypes, Win32Types;

  function WideStringArrayAsJsValue(aValue: WideStringArray): TJsValue;
  function JsValueAsWideStringArray(aValue: TJsValue): WideStringArray;

implementation

  uses
    Chakra;

  function WideStringArrayAsJsValue;
  var
    ArrayLength: Integer;
    I: Integer;
  begin
    ArrayLength := Length(aValue);
    Result := CreateArray(ArrayLength);

    for I := 0 to ArrayLength - 1 do begin
      SetArrayItem(Result, I, StringAsJsString(aValue[I]));
    end;
  end;

  function JsValueAsWideStringArray;
  var
    ArrayLength: Integer;
    I: Integer;
    Item: TJsValue;
  begin
    ArrayLength := GetArrayLength(aValue);

    if ArrayLength <> -1 then begin

      SetLength(Result, ArrayLength);

      for I := 0 to ArrayLength - 1 do begin
        Item := GetArrayItem(aValue, I);
        Result[I] := JsStringAsString(Item);
      end;

    end;

  end;

end.