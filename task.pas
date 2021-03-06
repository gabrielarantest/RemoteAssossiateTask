//Code developed by Gabriel Arantes Tiraboschi

unit task;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TtaskForm = class(TForm)
    firstWord: TLabel;
    secondWord: TLabel;
    thirdWord: TLabel;
    fixationCross: TLabel;
    fixationTimer: TTimer;
    stimuliTimer: TTimer;
    responseBox: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure firstScreen;
    procedure secondScreen;
    procedure thridScreen;
    function  getStimuli () : integer;
    procedure saveData;
    procedure fixationTimerTimer(Sender: TObject);
    procedure stimuliTimerTimer(Sender: TObject);
    procedure responseBoxKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const //Those are the experiment constants
FIXATION_TIMER_INTERVAL = 1000; //Time in milliseconds that fixation will appear (first screen)
STIMULI_TIMER_INTERVAL = 15000;//Time in milliseconds that stimuli will be presented
ASK_FOR_RESPONSE = 'Please, type your response and press ENTER.'; //string that ask for response

var //global variables
  taskForm: TtaskForm;

implementation

uses firstForm;

{$R *.dfm}

 var
 {private global variables}
  hTaskBar: HWND;  //windows taskbar variable
  trialNumber : integer; //the variable to count the number of trials
  stimuliArray1, stimuliArray2, stimuliArray3, correctRespArray, responseArray,
  summaryArray : array of string; //arrays that contain all stimuli words and responses
  startTime : string;
  numberOfTrials : integer; //the total number of trials

{procedure that executes when the form is closed}
procedure TtaskForm.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    ShowWindow(hTaskBar, SW_SHOW); //Displays the windows taskbar again
    ShowCursor(True); //Shows the  mouse cursor
    saveData;
  end;

{procedure for when the form is created}
procedure TtaskForm.FormCreate(Sender: TObject);
  begin
    {changes the window to full screen and without border}
    BorderStyle := bsNone; //no window border
    BringToFront;
    //These below hide the windows taskbar
    hTaskBar := FindWindow('Shell_TrayWnd', nil);
    ShowWindow(hTaskBar, SW_HIDE);
    WindowState := wsMaximized; //maximize the window
    DoubleBuffered := true; //This stops flickering
    ShowCursor(False); //hides the  mouse cursor

    {Setting the timers for the experiment}
    fixationTimer.Interval := FIXATION_TIMER_INTERVAL;
    stimuliTimer.Interval := STIMULI_TIMER_INTERVAL;

    {starts the experiment}
    trialNumber := 0; //Sets the first trial to zero
    startTime := DateTimeToStr (Now); //records starting time
    numberOfTrials := getStimuli (); //reads the triads.txt file and fills the arrays
    firstScreen; //starts the experiment
  end;

  {In the procedure bellow we read the triads.txt file and we fill
  the arrays of stimuli and correct responses to be used in the experimental run}
 function TtaskForm.getStimuli () : integer;
 var
 myFile : TextFile;
 text, word1, word2, word3, correctResponse   : string;
 numberOfStimuli, i : integer;

   begin
      //assing a file to be created or changed
     try
       // Try to open the Test.txt file for writing to
      AssignFile(myFile, 'triads.txt');
      // Reopen the file for reading
      Reset(myFile);
      // Reads the file contents
      ReadLn (myFile, text); //Reads the total number of triads
      numberOfStimuli := StrToInt(text); //This variables is the total number of triads

      {Bellow we set the lenght of the dynamic arrays
      to accomodate all variables}
      SetLength (stimuliArray1, numberOfStimuli);
      SetLength (stimuliArray2, numberOfStimuli);
      SetLength (stimuliArray3, numberOfStimuli);
      SetLength (correctRespArray, numberOfStimuli);
      SetLength (responseArray, numberOfStimuli);
      SetLength (summaryArray, numberOfStimuli);

      for i := 0 to (numberOfStimuli-1) do
        begin
          {Bellow we read all stimuli from the file triads.txt}
          ReadLn (myFile, word1); //Reads Stimuli
          ReadLn (myFile, word2); //Reads Stimuli
          ReadLn (myFile, word3); //Reads Stimuli
          ReadLn (myFile, correctResponse); //Reads Stimuli
          {Bellow we fill the arrays with the stimuli and correct responses}
          stimuliArray1 [i] := word1;
          stimuliArray2 [i] := word2;
          stimuliArray3 [i] := word3;
          correctRespArray [i] := correctResponse;
        end;

     except
      ShowMessage('A problem occured when reading the triads.txt file');
     end;

     result := numberOfStimuli; // returns the number of stimuli
   end;

{the first screen (fixation) method}
procedure TtaskForm.firstScreen;
  begin
    if trialNumber < numberOfTrials then //if there trials left then
      begin
        {make stimuli invisible}
        firstWord.Visible := false;
        secondWord.Visible := false;
        thirdWord.Visible := false;
        {show fixation cross}
        fixationCross.Visible := true;
        {start timer for the fixation cross}
        fixationTimer.Enabled := true;
      end
    else
      begin
        PostMessage(Self.Handle, WM_CLOSE, 0, 0); //closes the form
      end;

  end;

{procedure to call the second screen when the time is up for the fixation}
procedure TtaskForm.fixationTimerTimer(Sender: TObject);
  begin
   fixationTimer.Enabled := false; //reset timer
   secondScreen;
  end;

{second screen procedure}
procedure TtaskForm.secondScreen;
  begin
    {present the stimuli}
    firstWord.Visible := true;
    firstWord.Caption := stimuliArray1 [trialNumber];
    secondWord.Visible := true;
    secondWord.Caption := stimuliArray2 [trialNumber];
    thirdWord.Visible := true;
    thirdWord.Caption := stimuliArray3 [trialNumber];
    {hide fixation cross}
    fixationCross.Visible := false;
    {star timer for the stimuli}
    stimuliTimer.Enabled := true;
  end;

 {when time is up for stimuli presentation}
procedure TtaskForm.stimuliTimerTimer(Sender: TObject);
  begin
   thridScreen; //calls the response screen
   stimuliTimer.Enabled := false; //reset timer
  end;

{procedure of the last screen (response)}
procedure TtaskForm.thridScreen;

  begin
    {hide stimuli and fixation cross}
    firstWord.Visible := false;
    secondWord.Visible := false;
    thirdWord.Visible := false;
    fixationCross.Visible := false;
    {shows response box (Tedit)}
    responseBox.Enabled := true;
    responseBox.Visible := true;
    responseBox.Text := ASK_FOR_RESPONSE; //change the text
    responseBox.SetFocus; //Focus on the TEdit
  end;

{Procedure that is called when the user presses a Key in the response box
  Since the response box is only enabled during the third screes,
  theoretically this procedures only is called in the response screen}
procedure TtaskForm.responseBoxKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key = #13 then //if the user presses enter then
    begin
      responseArray [trialNumber] := responseBox.Text; //records participant response
      {bellow we condense data from all arrays into the summary array}
      summaryArray [trialNumber] :=
        'Triad: ' + stimuliArray1 [trialNumber] + '/' + stimuliArray2 [trialNumber]
          + '/' + stimuliArray3 [trialNumber] +
          ' -- Correct Response: ' + correctRespArray [trialNumber] +
          ' -- Participant Response: ' + responseArray [trialNumber];
      Inc(trialNumber);//Increase by one the number of trials elapsed
      responseBox.Enabled := false; //Disable Edit Box
      responseBox.Visible := false;
      firstScreen; //Calls the first screen method to complete the loop
    end;

  end;

procedure TtaskForm.saveData;
  var
  myFile : TextFile;
  finishingTime   : string;
  i, score : integer;
  begin
    try

    // Try to open the Test.txt file for writing all stimuli and responses
    AssignFile(myFile, 'P#'+ entryForm.pNumber + '_' + entryForm.pName + '.txt');
    ReWrite(myFile);

    // Write data into the file
    finishingTime := DateTimeToStr (Now);
    {First we start the heading of the file by writing the date and time}
    WriteLn (myFile, 'Participant Number: ' + entryForm.pNumber);
    WriteLn (myFile, 'Participant Name: ' + entryForm.pName);
    WriteLn (myFile, 'Participant Sex: ' + entryForm.pSex);
    WriteLn (myFile, 'Time that the experiment started: ' + startTime);
    WriteLn (myFile, 'Time that the experiment ended: ' + finishingTime);
    WriteLn (myFile, 'Bellow the triads, correct responses and participants actual response ');
    // the code bllow saves in the file the summary array of the experiment
    for i := 0 to numberOfTrials-1 do
      begin
        WriteLn(myFile, summaryArray [i]);
      end;

    {the code bellow computes the score by comparing strings}
    score := 0; //sets score to zero
    for i := 0 to numberOfTrials-1 do
      begin //compares each response with the correct response
        if correctRespArray [i] = responseArray [i] then Inc(score);
      end;
    //wirstes down the score
    WriteLn (myFile, 'The total score of the participant was: ' + IntToStr(score));

    finally
    // Close the file
    CloseFile(myFile);
  end;
end;


end.
