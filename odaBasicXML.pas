unit odaBasicXML;
{******************************************************************************}
{ Author      : Loda                                                           }
{ Create Date : 20060728                                                       }
{                                                                              }
{ Description : varios class and utils for basic manipulations of              }
{               XML file and nodes                                             }
{                                                                              }
{ Define Use  : [none]                                                         }
{ Side Effect : call CoInitialize                                              }
{                                                                              }
{ see region Internal_Doc                                                      }
{                                                                              }
{******************************************************************************}

{******************************************************************************}
{ Navigation Flags :                                                           }
{ (search for this text in interface and implentation)                         }
{                                                                              }
{ Internal_Doc                                                                 }
{ UTILS_XML_METHODE                                                            }
{ _TBasicXMLFile_                                                              }
{ _TCustomXMLFile_                                                             }
{                                                                              }
{******************************************************************************}

interface
uses
  xmldoc, Classes, XMLIntf, Variants;

type
  TBasicXMLFile = class
  private
  { _TBasicXMLFile_ Manage a XML file.

    FileName is not tested ! The file must exist.
    ReadOnly Attribut not tested: SaveToDisk can raise!
  }
    function getAutoSave : Boolean;
    procedure setAutoSave(value : boolean);
  protected
    fFileName : String;
    XMLDocument:TXMLDocument;
    dm:tDataModule;
    function getRootNode : IXMLNode;

  public
    class procedure CreateEmptyFile(FileName : String);
    constructor Create(FileName : String); virtual;
    destructor Destroy();override;

    procedure SaveToDisk;


    // Auto Save OnDestroy
    property AutoSave : Boolean read getAutoSave write setAutoSave;

    property RootNode : IXMLNode read getRootnode;
  end;

  TCustomXMLFile = class(TBasicXMLFile)
  private
  { _TCustomXMLFile_ Manage a XML file.

    Root.SubNode can be acces and create by RootSubNode property.

    FileName is not tested ! The file must exist.
    ReadOnly Attribut not tested: SaveToDisk can raise!
  }

    function getRootSubNode(NodeName : String) : IXMLNode;
    // remplace the Node "NodeName" by a copy of Value
    procedure setRootSubNode(NodeName : String; Value : IXMLNode);

  public

    // Child of RootNode,
    // when writing: create a copy then return the wroted node.
    property RootSubNode [NodeName : String] : IXMLNode read getRootSubNode write setRootSubNode;
  end;

  //////////////////////////////////////////////////////////////////////////////
  // UTILS_XML_METHODE
  //////////////////////////////////////////////////////////////////////////////

{ getPath

  Get the path of the node.
  "climb" the tree until the root node.
  (the root (1st) node won't be include in the returned path)

}
  function getPath (node : IXMLNode; PATH_SEP : Char = '.') : string;

////////////////////////////////////////////////////////////////////////////////
{ getNode

  return the node situed at the specified path.
  path is relative to RootNode.

  RootNode must not be included in path
  (the path start at RootNode.ChildNodes)

  if not found or error, return nil.}
  function getNode (RootNode : IXMLNode;
                    Path     : string ;
                    PATH_SEP : Char = '.')
                             : IXMLNode;

////////////////////////////////////////////////////////////////////////////////
{ TryGetAttrib

  Try to read an attribut,

  if we cannot : return false and Value = unassigned.

}
function TryGetAttrib(
             Node       : IXMLNode;
             AttribName : String;
         out Value      : OleVariant)
                        : Boolean;
////////////////////////////////////////////////////////////////////////////////
{ GetAttrib

  read an attribut,

  if we cannot : return DefaultValue

}
function GetAttrib(
           Node         : IXMLNode;
           AttribName   : String;
           DefaultValue : OleVariant)
                        : OleVariant;
////////////////////////////////////////////////////////////////////////////////

{ odaCloneNode

  copy all children of srcNode in dstNode.
  copy all the attributes of srcNode in dstNode
  (created because CloneNode return a Node with the same NodeName)

  Param:

  Deep     : pass to CloneNode methode.
  EraseDst : True  : dstNode will be empty by method
             False : the existing node/attrib are keep.
}
procedure odaCloneNode(srcNode, dstNode : IXMLNode;
                       Deep : Boolean ; EraseDst : Boolean = true);
////////////////////////////////////////////////////////////////////////////////


implementation
{Internal_Doc}{

The Class TBasicXMLFile don't create the file. The file MUST exist.
If necessary, create it by hand, with CreateEmptyFile

}
uses
ActiveX,
xmldom;
////////////////////////////////////////////////////////////////////////////////
// Internal_Tools
////////////////////////////////////////////////////////////////////////////////

procedure SplitPath (Input: string; SEP : Char ; out Strings: TStringList);
{
  convert a path with SEP in a StringList.

  remove extra SEP.

  Please, free Strings after use.
}
var
  i : integer;
begin
  Strings := TStringList.Create;
  Strings.Delimiter := SEP;
  Strings.DelimitedText := Input;

  //remove extra SEP
  for i := Strings.Count-1 downto 0 do begin
    if Strings[i] = '' then strings.Delete(i);
  end;

end;

{ _TBasicXMLFile_ }
constructor TBasicXMLFile.Create(FileName : String);
begin
  inherited create;
  dm:=tdatamodule.create(nil);
  XMLDocument:=TXMLDocument.Create(dm);

  fFileName := FileName;

  with XMLDocument do begin
    DomVendor:=GetDOMVendor('MSXML');
    //Note: if option [doNodeAutoIndent] is set with MSXML,
    //      Node.Clone change the type during copy !?!
    LoadFromFile(fFileName);
    Active := True;
  end;

end;

destructor TBasicXMLFile.Destroy;
begin
  XMLDocument.Free; //I don't really know why, but the destroy isn't automatic
  dm.Free;
  inherited destroy;
end;

class procedure TBasicXMLFile.CreateEmptyFile(FileName: String);
var
  F : TextFile;
begin
  try
    AssignFile(F, FileName);
    Rewrite(F); //create and write
    WriteLn(F,'<?xml version="1.0" encoding="UTF-8"?>');
    WriteLn(F,'<root>');
    WriteLn(F,'</root>');
  finally
    CloseFile(F);
  end;
end;

procedure TBasicXMLFile.SaveToDisk;
{raise if the file is read only}
begin
  XMLDocument.SaveToFile(fFileName);
end;

function TBasicXMLFile.getRootNode: IXMLNode;
begin
  Result := XMLDocument.DocumentElement;
end;

function TBasicXMLFile.getAutoSave: Boolean;
begin
  result := doAutoSave in XMLDocument.Options;
end;

procedure TBasicXMLFile.setAutoSave(value: boolean);
begin
  if value then
    XMLDOcument.Options := XMLDOcument.Options + [doAutoSave]
  else
    XMLDOcument.Options := XMLDOcument.Options - [doAutoSave];
end;


{ _TCustomXMLFile_ }

function TCustomXMLFile.getRootSubNode(NodeName: String): IXMLNode;
begin
  Result := RootNode.ChildNodes.FindNode(NodeName);
end;

procedure TCustomXMLFile.setRootSubNode(NodeName: String; Value: IXMLNode);
var
  node : IXMLNode;
begin
  // get existing node
  node := getRootSubNode(NodeName);

  // if not existing, create it.
  if not assigned(node) then begin
    node := RootNode.AddChild(NodeName);
  end;

  // copy (remplace) content
  odaCloneNode(value, node, true, true);

end;

//////////////////////////////////////////////////////////////////////////////
// UTILS_XML_METHODE
//////////////////////////////////////////////////////////////////////////////
function getPath (node : IXMLNode; PATH_SEP : Char = '.') :string;
{
  Get the path  of the node.
  "climb" the tree until the root node.
  (the root (1st) node won't be include in the returned path)

}
begin
  result := '';
  if not Assigned(node) then exit;
  result := node.nodename;

  if Node.ParentNode <> nil then
    while node.ParentNode.ParentNode <> nil do
    begin
      // climb and note
      result := node.ParentNode.NodeName + PATH_SEP + result;
      node := node.ParentNode;
    end;//while

end;

function getNode (RootNode : IXMLNode; Path : string ; PATH_SEP : Char = '.') : IXMLNode;
{
  return the node situed at the specified path.
  if not found or error, return nil.

  RootNode must not be included in path
  (the path start at RootNode)
}
var
  i : integer;
  node : IXMLNode;
  NodeNameList : TStringList;
begin
  result := nil;
  if not Assigned(RootNode) then exit;

  SplitPath (Path, PATH_SEP, NodeNameList);
  try
    if NodeNameList.Count = 0 then exit;

    node := RootNode;
    for i := 0 to NodeNameList.count-1 do begin
      if not Assigned(node) then exit; //wrong path
      node := node.ChildNodes.FindNode(NodeNameList[i]);
    end;

    Result := node;
  finally
    NodeNameList.free;
  end;
end;

function TryGetAttrib(
             Node       : IXMLNode;
             AttribName : String;
         out Value      : OleVariant)
                        : Boolean;
begin
  Result := false;
  Value := unassigned;

  if not Assigned(Node) then exit;
  if not node.HasAttribute(AttribName) then exit;

  Value := Node.Attributes[AttribName];
  Result := true;
end;

function GetAttrib(
           Node         : IXMLNode;
           AttribName   : String;
           DefaultValue : OleVariant)
                        : OleVariant;
begin
  if not TryGetAttrib(Node, AttribName, Result) then
    Result := DefaultValue;
end;

procedure odaCloneNode(srcNode, dstNode : IXMLNode; Deep : Boolean ; EraseDst : Boolean = true);
var
  i : integer;
begin
  if not Assigned(srcNode) then exit;
  if not Assigned(dstNode) then exit;

  if EraseDst then begin
    dstNode.childNodes.Clear;
    dstNode.AttributeNodes.Clear;
  end;

  for i := 0 to srcNode.ChildNodes.count-1 do begin
    dstNode.childNodes.Add(srcNode.childNodes.get(i).CloneNode(deep));
  end;

  for i := 0 to srcNode.AttributeNodes.count-1 do begin
    dstNode.AttributeNodes.Add(srcNode.AttributeNodes.get(i).CloneNode(deep));
  end;

end;

initialization
  CoInitialize(nil);
finalization
  CoUnInitialize;
end.
