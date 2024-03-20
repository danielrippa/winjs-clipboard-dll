unit Shell32;

interface

  uses
    Win32ClipboardTypes;

  const
    dll = 'shell32.dll';

  function SHFileOperationW(var lpFileOp: TSHFileOpStructW): Integer; stdcall; external dll;

implementation

end.