program RAT;

uses
  Vcl.Forms,
  firstForm in 'firstForm.pas' {entryForm},
  task in 'task.pas' {taskForm},
  training in 'training.pas' {trainingForm},
  about in 'about.pas' {aboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TentryForm, entryForm);
  Application.Run;
end.
