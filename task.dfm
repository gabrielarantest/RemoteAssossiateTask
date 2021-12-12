object taskForm: TtaskForm
  Left = 0
  Top = 0
  Anchors = []
  Caption = 'taskForm'
  ClientHeight = 720
  ClientWidth = 1280
  Color = clBlack
  TransparentColorValue = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    1280
    720)
  PixelsPerInch = 120
  TextHeight = 16
  object firstWord: TLabel
    Left = -1
    Top = 298
    Width = 1282
    Height = 40
    Alignment = taCenter
    Anchors = []
    AutoSize = False
    Caption = 'Word 1'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object secondWord: TLabel
    Left = 5
    Top = 339
    Width = 1270
    Height = 40
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Alignment = taCenter
    Anchors = []
    AutoSize = False
    Caption = 'Word 2'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object thirdWord: TLabel
    Left = 5
    Top = 379
    Width = 1276
    Height = 40
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Alignment = taCenter
    Anchors = []
    AutoSize = False
    Caption = 'Word 3'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object fixationCross: TLabel
    AlignWithMargins = True
    Left = 640
    Top = 344
    Width = 18
    Height = 35
    Alignment = taCenter
    Anchors = []
    AutoSize = False
    Caption = '+'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object responseBox: TEdit
    Left = 312
    Top = 335
    Width = 673
    Height = 41
    Alignment = taCenter
    Anchors = []
    BorderStyle = bsNone
    CharCase = ecLowerCase
    Color = clBlack
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = #39'please, type your response and press enter.'#39
    Visible = False
    OnKeyPress = responseBoxKeyPress
  end
  object fixationTimer: TTimer
    Enabled = False
    OnTimer = fixationTimerTimer
    Left = 112
    Top = 64
  end
  object stimuliTimer: TTimer
    Enabled = False
    OnTimer = stimuliTimerTimer
    Left = 112
    Top = 112
  end
end
