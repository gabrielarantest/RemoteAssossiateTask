//Code developed by Gabriel Arantes Tiraboschi
unit firstForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  task, training, about, Vcl.Menus; //importing other classes

type
  TentryForm = class(TForm)
    participantNameField: TEdit;
    participantNumberField: TEdit;
    participantNameLabel: TLabel;
    participantNumberLabel: TLabel;
    participantSexLabel: TLabel;
    participantSexComboBox: TComboBox;
    startButton: TButton;
    creditLabel: TLabel;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    raining1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    Close1: TMenuItem;

    {forward procedures declarations}
    {The declaration of a method inside a class type is also considered a forward declaration.}
    procedure FormCreate(Sender: TObject); //when the form is created
    procedure dataStore;
    procedure startButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
    procedure raining1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    pName: string; //participant's name
    pNumber: string; //participant's number
    pSex : string; //participant's sex
  end;

var   //Global variables
  entryForm: TentryForm;


implementation

{$R *.dfm}

{participants' variables}
//Private global variables -> mudar para var locais
var

hTaskBar: HWND;  //{windows taskbar variables}

{A procedure to execute once the form is created.
 To activate this procedure you have to enable the
 OnCreate event at the form's property}

procedure TentryForm.FormCreate(Sender: TObject);

  begin
    {Creates the options on the sex combo box}
    participantSexComboBox.Items.Add('Female');
    participantSexComboBox.Items.Add('Male');
    participantSexComboBox.Font.Size := 12; //ajust comboBox font size
    ShowCursor(True); //Shows the  mouse cursor

  end;



{procedure for when the button is pressed}
procedure TentryForm.startButtonClick(Sender: TObject);
  var
  taskRun : TtaskForm;
  begin
  dataStore;
  taskRun := TtaskForm.Create (nil); //create a new object form
  ShowCursor(False); //hides the  mouse cursor
    try
      taskRun.ShowModal; {Use ShowModal to show a form as a modal form.
      A modal form is one where the application can't continue to run until the
      form is closed. Thus, ShowModal does not return until the form closes.}
    finally
      taskRun.Free; //destroys and free the memory
    end;
end;

procedure TentryForm.dataStore; //Store participant's info to variables
  begin
    pName := participantNameField.Text;
    pNumber := participantNumberField.Text;
    pSex :=  participantSexComboBox.Text;
  end;


procedure TentryForm.FormClose(Sender: TObject; var Action: TCloseAction);
 var
  hTaskBar: HWND;  //{windows taskbar variables}
  begin
    ShowWindow(hTaskBar, SW_SHOW); //Displays the windows taskbar again
    ShowCursor(True); //Shows the  mouse cursor
  end;

//------- TOP MENU

procedure TentryForm.About1Click(Sender: TObject);
  var
  aboutRun : TaboutForm;
  begin
     aboutRun := TaboutForm.Create(nil);//Create a new object form of about
     try
       aboutRun.ShowModal;
     finally
       aboutRun.Free;
     end;
  end;

procedure TentryForm.Close1Click(Sender: TObject); //when clicks Close
  begin
     Application.Terminate; //closes the experiment
  end;

procedure TentryForm.raining1Click(Sender: TObject); //when clicks Training
  var
  trainingRun : TtrainingForm;
  begin
  trainingRun := TtrainingForm.Create (nil); //create a new object form of training
  ShowCursor(False); //hides the  mouse cursor
    try
      trainingRun.ShowModal; {Use ShowModal to show a form as a modal form.
      A modal form is one where the application can't continue to run until the
      form is closed. Thus, ShowModal does not return until the form closes.}
    finally
      trainingRun.Free; //destroys and free the memory
    end;
  end;



end.
