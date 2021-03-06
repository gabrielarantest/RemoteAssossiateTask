unit training;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TtrainingForm = class(TForm)
    firstWord: TLabel;
    secondWord: TLabel;
    thirdWord: TLabel;
    fixationCross: TLabel;
    responseBox: TEdit;
    fixationTimer: TTimer;
    stimuliTimer: TTimer;
    feedBack: TLabel;
    feedBackTimer: TTimer;
    instructionsLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure instructions;
    procedure firstScreen;
    procedure secondScreen;
    procedure thridScreen;
    function  getStimuli () : integer;
    procedure fixationTimerTimer(Sender: TObject);
    procedure stimuliTimerTimer(Sender: TObject);
    procedure responseBoxKeyPress(Sender: TObject; var Key: Char);
    procedure feedBackTimerTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const //Those are the experiment constants
FIXATION_TIMER_INTERVAL = 1000; //Time in milliseconds that fixation will appear (first screen)
STIMULI_TIMER_INTERVAL = 15000;//Time in milliseconds that stimuli will be presented
FEEDBACK_TIMER_INTERVAL = 2000; //Time in milliseconds that feedback will be presented
ASK_FOR_RESPONSE = 'Please, type your response NOW and press ENTER.'; //string that ask for response
{bellow are the training trials}

var //global variables
  taskForm: TtrainingForm;


implementation

{$R *.dfm}

 var
 {private global variables}
  hTaskBar: HWND;  //windows taskbar variable
  trialNumber : integer; //the variable to count the number of trials
  stimuliArray1, stimuliArray2, stimuliArray3, correctRespArray, responseArray,
  summaryArray : array of string; //arrays that contain all stimuli words and responses
  numberOfTrials, currentScreen : integer; //the total number of trials
  instructionsMode : boolean;



{procedure for when the form is created}
procedure TtrainingForm.FormCreate(Sender: TObject);
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

    {Shows the instruction}
    instructions;
  end;

{procedure that executes when the form is closed}
procedure TtrainingForm.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    ShowWindow(hTaskBar, SW_SHOW); //Displays the windows taskbar again
    ShowCursor(True); //Shows the  mouse cursor
  end;

{this procedure is to show the first screen of the instructions}
procedure TtrainingForm.instructions;
  var
  myFile : TextFile;
  i, numOfScreens : integer; //declare the number of screens for the instruction
  numOfLines : array of  integer; //array for the number of lines for each screen
  text, fullText : string;
  begin
     instructionsLabel.Visible := true; //shows instructions
     try
        // Try to open the Test.txt file for writing to
        AssignFile(myFile, 'instructions.txt');
        // Reopen the file for reading
        Reset(myFile);
        // Reads the file contents
        ReadLn (myFile, text); //Reads the total number of triads
        numOfScreens := StrToInt(text); //This variables is the total number of triads
        {Bellow we set the lenght of the dynamic arrays
        to accomodate all variables}
        SetLength (numOfLines, numOfScreens);
        for i := 0 to numOfScreens-1 do
          begin
            ReadLn (myFile, text); //Reads the total number of lines of each screen
            numOfLines [i] := StrToInt(text);
          end;

        {This loop will read each line of the first screen of the instruction}
        for i := 0 to numofLines[0]-1 do //repeat until completed the total number of lines of the screen
          begin
            ReadLn (myFile, text); //Reads the instructions text
            //Assembles each line toghether in a string variable
            fullText := fullText + text + sLineBreak + sLineBreak;
          end;
        instructionsLabel.Caption := fullText; //updates the caption of the label

     except
       ShowMessage('A problem occured when reading the triads.txt file');
       CloseFile(myFile); // Close the file
     end;

     instructionsMode := true; //boolean to signal if it is in the instructions
     currentScreen := 1;//updates the current instruction screen

  end;

  {method when participant press a key (enter) and they are in the instruction mode}
  procedure TtrainingForm.FormKeyPress(Sender: TObject; var Key: Char);
    var
    myFile : TextFile; //variable to stores the text file
    i,j, numOfScreens : integer; //declare the number of screens for the instruction
    numOfLines : array of  integer; //array for the number of lines for each screen
    text, fullText : string; //variable to store text from the txt file
    begin
      numOfScreens := 0; //Initialize variable
      //if the program is at instruction time and the pressed is enter then
      if (instructionsMode = true) and (Key = #13) then
        begin
          try
            // Try to open the Test.txt file for writing to
            AssignFile(myFile, 'instructions.txt');
            // Reopen the file for reading
            Reset(myFile);
            // Reads the file contents
            ReadLn (myFile, text); //Reads the total number of triads
            numOfScreens := StrToInt(text); //This variables is the total number of screens
            {Bellow we set the lenght of the dynamic array that stores the
            total number of lines of each screen. The lenght is the total
            number of screens. Each position in the array represents a screen}
            SetLength (numOfLines, numOfScreens);
            {This loop read from the txt file the total number of lines in each
            screen.}
            for i := 0 to numOfScreens-1 do
              begin
                ReadLn (myFile, text); //Reads the total number of lines of each screen
                numOfLines [i] := StrToInt(text); //stores the number of lines in each screen
              end;

          except
             ShowMessage('A problem occured when reading the triads.txt file');
             CloseFile(myFile); // Close the file

          end;

        {In this first loop we jump the pointer to the line of the current screen.
        So if the number of the current screen is less than the total number
        of screens, the first loop will jump the lines that have already been read,
        and the following loop will read the lines of the current instruction screen.}
        if currentScreen < numOfScreens then
            begin
              for i := 0 to currentScreen-1 do //for each screen that have elapsed
                begin
                  for j := 0 to numofLines[i]-1 do //jump the lines of each screen
                  begin
                    ReadLn (myFile, text);
                  end;
                end;
          {This loop will read each line of the current screen of the instruction}
            for i := 0 to numofLines[currentScreen]-1 do
              begin
                ReadLn (myFile, text); //Reads the line from file
              //Assembles and stores the current line with other lines in a string variable
                fullText := fullText + text + sLineBreak + sLineBreak;
              end;

            instructionsLabel.Caption := fullText; //presents the full instruction
            Inc(currentScreen); //adds one to the number of the current instruction screen
            CloseFile(myFile); //closes the .txt file
          end
          else //if the current screen number is greater than the total number of screens
          begin
            instructionsMode := false; //disable instruction mode
            instructionsLabel.Free; //Destroy the instruction object
            {----------------------}
            {starts the experiment}
            trialNumber := 0; //Sets the first trial to zero
            numberOfTrials := getStimuli (); //reads the triads.txt file and fills the arrays
            firstScreen; //starts the experiment
          end;
        end;
    end;

  {In the procedure bellow we read the triads.txt file and we fill
  the arrays of stimuli and correct responses to be used in the experimental run}
 function TtrainingForm.getStimuli () : integer;
 var
 myFile : TextFile;
 text, word1, word2, word3, correctResponse   : string;
 numberOfStimuli, i : integer;

   begin
      numberOfStimuli := 0; //initializes the variable to store screens

      //assing a file to be created or changed
     try
      // Try to open the Test.txt file for writing to
      AssignFile(myFile, 'trainingTriads.txt');
      // Reopen the file for reading
      Reset(myFile);
      // Reads the file contents
      ReadLn (myFile, text); //Reads the total number of triads
      numberOfStimuli := StrToInt(text); //This variables is the total number of triads

      {Bellow we set the lenght of the dynamic arrays
      to accomodate all variables}
      SetLength (stimuliArray1, ((numberOfStimuli+1)));
      SetLength (stimuliArray2, ((numberOfStimuli+1)));
      SetLength (stimuliArray3, ((numberOfStimuli+1)));
      SetLength (correctRespArray, ((numberOfStimuli+1)));
      SetLength (responseArray, ((numberOfStimuli+1)));
      SetLength (summaryArray, ((numberOfStimuli+1)));

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
      // Close the file
      CloseFile(myFile);
     end;

    result := numberOfStimuli; // returns the number of stimuli

   end;

{the first screen (fixation) method}
procedure TtrainingForm.firstScreen;
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
procedure TtrainingForm.fixationTimerTimer(Sender: TObject);
  begin
   fixationTimer.Enabled := false; //reset timer
   secondScreen;
  end;

{second screen procedure}
procedure TtrainingForm.secondScreen;
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
procedure TtrainingForm.stimuliTimerTimer(Sender: TObject);
  begin
   thridScreen; //calls the response screen
   stimuliTimer.Enabled := false; //reset timer
  end;

{procedure of the last screen (response)}
procedure TtrainingForm.thridScreen;

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

procedure TtrainingForm.responseBoxKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key = #13 then //if the user presses enter then
    begin
      responseArray [trialNumber] := responseBox.Text; //records participant response
      responseBox.Enabled := false; //Disable Edit Box
      responseBox.Visible := false;
      feedBack.Visible := true; //Shows feedback
      {if the response is correct shows a corect feedback}
      if responseArray [trialNumber] = correctRespArray [trialNumber] then
        begin
          feedBack.Caption := 'Correct';
          feedBack.Font.Color := clBlue;
        end
      {if the response is incorrect shows an incorect feedback}
      else
        begin
          feedBack.Caption := 'Incorrect. The correct response is: ' +
          correctRespArray [trialNumber]; //shows correct response
          feedBack.Font.Color := clRed;
        end;

      {starts the timer to show feedback}
      feedBackTimer.Interval := FEEDBACK_TIMER_INTERVAL;
      feedBackTimer.Enabled := true;
      Inc(trialNumber);//Increase by one the number of trials elapsed
    end;

  end;

procedure TtrainingForm.feedBackTimerTimer(Sender: TObject);
  begin
    feedBackTimer.Enabled := false; //closes the timer
    feedBack.Visible := false;
    firstScreen; //Calls the first screen method to complete the loop
  end;

end.
