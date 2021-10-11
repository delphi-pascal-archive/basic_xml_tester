program odaBasicXML_Tester;

{%File 'Test.xml'}

uses
  Forms,
  Main_frm in 'Main_frm.pas' {frmMain},
  odaBasicXML in 'odaBasicXML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
