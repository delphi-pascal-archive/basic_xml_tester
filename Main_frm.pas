unit Main_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, odaBasicXML;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    edtFileName: TEdit;
    Label1: TLabel;
    btnCreate: TButton;
    pnlActionOnNode: TPanel;
    Memo1: TMemo;
    edtNodeName: TEdit;
    Label3: TLabel;
    edtAttribName: TEdit;
    Label4: TLabel;
    edtValue: TEdit;
    Label5: TLabel;
    btnRead: TButton;
    btnWrite: TButton;
    btnSaveToDisk: TButton;
    edtTargetNodeName: TEdit;
    Label2: TLabel;
    btnCopy: TButton;
    procedure btnCreateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveToDiskClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    { Déclarations privées }
    xml : TCustomXMLFile; // <--

  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
XMLIntf;

procedure TfrmMain.btnCreateClick(Sender: TObject);
begin
  xml.free;

    if not FileExists (edtFileName.Text) then
      TBasicXMLFile.CreateEmptyFile(edtFileName.Text);

  xml := TCustomXMLFile.Create(edtFileName.Text);
  xml.AutoSave := true;
  
  pnlActionOnNode.Visible := true;
  btnSaveToDisk.Enabled := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(xml) then xml.free;
end;

procedure TfrmMain.btnSaveToDiskClick(Sender: TObject);
begin
  xml.SaveToDisk;
end;

procedure TfrmMain.btnReadClick(Sender: TObject);
var
  node : IXMLNode;
  v : olevariant;
begin
  node := xml.RootSubNode[edtNodeName.Text];

  if TryGetAttrib(node,edtAttribName.Text,v) then begin
    memo1.Lines.add(v);
  end else begin
    memo1.Lines.add('Noeud ou Attribut non existant dans ce fichier');
  end;

end;

procedure TfrmMain.btnWriteClick(Sender: TObject);
var
  node : IXMLNode;
begin
  try
    node := xml.RootSubNode[edtNodeName.Text];

    if not assigned (node) then
      node := xml.RootNode.AddChild(edtNodeName.Text);

    node.Attributes[edtAttribName.Text] := edtValue.Text;

    memo1.Lines.Add('Valeur Ecrite : ' +
                    getPath(node) + '[' +
                    edtAttribName.Text + '] = ' +
                    edtValue.Text);
  except
    memo1.Lines.add('Erreur: Utilisez des noms de noeud/attribue valide');
  end;//try

end;

procedure TfrmMain.btnCopyClick(Sender: TObject);
var
  Node : IXMLNode;
  p1,p2 : string;
begin
  node := xml.RootSubNode[edtNodeName.Text];

  if not assigned (node) then begin
    Memo1.Lines.Add('Noeud source non existant dans ce fichier');
    exit;
  end;
  p1 := getPath(node);

  xml.RootSubNode[edtTargetNodeName.Text] := node;

  //recupere le noeud cible
  Node := xml.RootSubNode[edtTargetNodeName.Text];
  p2 := getPath(node);

  Memo1.Lines.Add('Noeud "' + p1 +
                  '" copié dans le noeud : "' +
                  p2 + '"');

end;

end.
