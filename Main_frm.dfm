object frmMain: TfrmMain
  Left = 224
  Top = 135
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Basic XML tester'
  ClientHeight = 297
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 553
    Height = 41
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 16
      Width = 33
      Height = 16
      Alignment = taRightJustify
      Caption = 'Open'
    end
    object edtFileName: TEdit
      Left = 56
      Top = 8
      Width = 217
      Height = 24
      TabOrder = 0
      Text = 'Test.xml'
    end
    object btnCreate: TButton
      Left = 280
      Top = 8
      Width = 129
      Height = 25
      Caption = 'Create'
      TabOrder = 1
      OnClick = btnCreateClick
    end
    object btnSaveToDisk: TButton
      Left = 416
      Top = 8
      Width = 129
      Height = 25
      Caption = 'Save'
      Enabled = False
      TabOrder = 2
      OnClick = btnSaveToDiskClick
    end
  end
  object pnlActionOnNode: TPanel
    Left = 8
    Top = 56
    Width = 553
    Height = 233
    TabOrder = 1
    Visible = False
    object Label3: TLabel
      Left = 26
      Top = 12
      Width = 82
      Height = 16
      Alignment = taRightJustify
      Caption = 'Node number'
    end
    object Label4: TLabel
      Left = 60
      Top = 43
      Width = 48
      Height = 16
      Alignment = taRightJustify
      Caption = 'Attribute'
    end
    object Label5: TLabel
      Left = 32
      Top = 74
      Width = 78
      Height = 16
      Alignment = taRightJustify
      Caption = 'Value (string)'
    end
    object Label2: TLabel
      Left = 434
      Top = 48
      Width = 34
      Height = 16
      Alignment = taRightJustify
      Caption = 'Node'
    end
    object Memo1: TMemo
      Left = 8
      Top = 104
      Width = 537
      Height = 121
      TabOrder = 0
    end
    object edtNodeName: TEdit
      Left = 120
      Top = 8
      Width = 153
      Height = 24
      TabOrder = 1
      Text = 'N1'
    end
    object edtAttribName: TEdit
      Left = 120
      Top = 40
      Width = 153
      Height = 24
      TabOrder = 2
      Text = 'Attrib1'
    end
    object edtValue: TEdit
      Left = 120
      Top = 72
      Width = 153
      Height = 24
      TabOrder = 3
      Text = 'New value'
    end
    object btnRead: TButton
      Left = 280
      Top = 72
      Width = 65
      Height = 25
      Caption = 'Read'
      TabOrder = 4
      OnClick = btnReadClick
    end
    object btnWrite: TButton
      Left = 352
      Top = 72
      Width = 65
      Height = 25
      Caption = 'Write'
      TabOrder = 5
      OnClick = btnWriteClick
    end
    object edtTargetNodeName: TEdit
      Left = 480
      Top = 40
      Width = 65
      Height = 24
      TabOrder = 6
      Text = 'NX'
    end
    object btnCopy: TButton
      Left = 432
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Copy node'
      TabOrder = 7
      OnClick = btnCopyClick
    end
  end
end
