{
 * The contents of this file are subject to the InterBase Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License.
 * 
 * You may obtain a copy of the License at http://www.Inprise.com/IPL.html.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.  The Original Code was created by Inprise
 * Corporation and its predecessors.
 * 
 * Portions created by Inprise Corporation are Copyright (C) Inprise
 * Corporation. All Rights Reserved.
 * 
 * Contributor(s): Krzysztof Golko.
}

unit frmuDBRestore;

{$MODE Delphi}
                  
interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, zluibcClasses, Grids, IB, frmuDlgClass,
  FileUtil, resstring;

type
  TfrmDBRestore = class(TDialog)
    gbDatabaseFiles: TGroupBox;
    lblDestinationServer: TLabel;
    lblDBAlias: TLabel;
    sgDatabaseFiles: TStringGrid;
    cbDBServer: TComboBox;
    cbDBAlias: TComboBox;
    imgDownArrow: TImage;
    gbBackupFiles: TGroupBox;
    lblBackupServer: TLabel;
    lblBackupAlias: TLabel;
    stxBackupServer: TStaticText;
    sgBackupFiles: TStringGrid;
    cbBackupAlias: TComboBox;
    lblOptions: TLabel;
    sgOptions: TStringGrid;
    btnOK: TButton;
    btnCancel: TButton;
    pnlOptionName: TPanel;
    cbOptions: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbOptionsChange(Sender: TObject);
    procedure cbOptionsDblClick(Sender: TObject);
    procedure cbOptionsExit(Sender: TObject);
    procedure cbOptionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtDestinationDBChange(Sender: TObject);
    procedure edtSourceDBChange(Sender: TObject);
    procedure sgBackupFilesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgDatabaseFilesDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgDatabaseFilesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure cbDBServerChange(Sender: TObject);
    procedure cbDBAliasChange(Sender: TObject);
    procedure cbBackupAliasChange(Sender: TObject);
    procedure IncreaseRows(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    Procedure TranslateVisual;override;
  private
    { Private declarations }
    FVerboseFile: string;

    FSourceServerNode: TibcServerNode;
    function VerifyInputData(): boolean;
  public
    { Public declarations }
    FFileList: TStringList;
  end;

function DoDBRestore(const SourceServerNode: TibcServerNode;
                     const SourceBackupAliasNode: TibcTreeNode): integer;

implementation

uses zluGlobal, zluPersistent, IBServices,frmuMessage,
  frmuMain, zluUtility, IBErrorCodes;

{$R *.lfm}

const
  OPTION_NAME_COL = 0;
  OPTION_VALUE_COL = 1;
  PAGE_SIZE_ROW = 0;
  OVERWRITE_ROW = 1;
  COMMIT_EACH_TABLE_ROW = 2;
  CREATE_SHADOW_FILES_ROW = 3;
  DEACTIVATE_INDICES_ROW = 4;
  VALIDITY_CONDITIONS_ROW = 5;
  USE_ALL_SPACE_ROW = 6;
  VERBOSE_OUTPUT_ROW = 7;

procedure TfrmDBRestore.FormCreate(Sender: TObject);
begin
  inherited;
  FFileList := TStringList.Create;
  sgOptions.DefaultRowHeight := cbOptions.Height;
  cbOptions.Visible := True;
  pnlOptionName.Visible := True;

  sgBackupFiles.Cells[0,0] := LZTDBRestoreFilename;

  sgDatabaseFiles.Cells[0,0] := LZTDBRestoreFilename;
  sgDatabaseFiles.Cells[1,0] := LZTDBRestorePages;

  sgOptions.RowCount := 8;

  sgOptions.Cells[OPTION_NAME_COL,PAGE_SIZE_ROW] := 'Page Size (Bytes)';
  sgOptions.Cells[OPTION_VALUE_COL,PAGE_SIZE_ROW] := '1024';

  sgOptions.Cells[OPTION_NAME_COL,OVERWRITE_ROW] := 'Overwrite';
  sgOptions.Cells[OPTION_VALUE_COL,OVERWRITE_ROW] := LZTDBRestoreFalse;

  sgOptions.Cells[OPTION_NAME_COL,COMMIT_EACH_TABLE_ROW] := 'Commit After Each Table';
  sgOptions.Cells[OPTION_VALUE_COL,COMMIT_EACH_TABLE_ROW] := LZTDBRestoreFalse;

  sgOptions.Cells[OPTION_NAME_COL,CREATE_SHADOW_FILES_ROW] := 'Create Shadow Files';
  sgOptions.Cells[OPTION_VALUE_COL,CREATE_SHADOW_FILES_ROW] := LZTDBRestoreTrue;

  sgOptions.Cells[OPTION_NAME_COL,DEACTIVATE_INDICES_ROW] := 'Deactivate Indices';
  sgOptions.Cells[OPTION_VALUE_COL,DEACTIVATE_INDICES_ROW] := LZTDBRestoreFalse;

  sgOptions.Cells[OPTION_NAME_COL,VALIDITY_CONDITIONS_ROW] := 'Validity Conditions';
  sgOptions.Cells[OPTION_VALUE_COL,VALIDITY_CONDITIONS_ROW] := LZTDBRestoreRestore;

  sgOptions.Cells[OPTION_NAME_COL,USE_ALL_SPACE_ROW] := 'Use All Space';
  sgOptions.Cells[OPTION_VALUE_COL,USE_ALL_SPACE_ROW] := LZTDBRestoreFalse;

  sgOptions.Cells[OPTION_NAME_COL,VERBOSE_OUTPUT_ROW] := 'Verbose Output';
  sgOptions.Cells[OPTION_VALUE_COL,VERBOSE_OUTPUT_ROW] := LZTDBRestoreToScreen;

  pnlOptionName.Caption := LZTDBRestorePageSize;
  cbOptions.Items.Add('1024');
  cbOptions.Items.Add('2048');
  cbOptions.Items.Add('4096');
  cbOptions.Items.Add('8192');
  cbOptions.ItemIndex := 0;
end;

procedure TfrmDBRestore.FormDestroy(Sender: TObject);
begin
  FFileList.Free;
end;

procedure TfrmDBRestore.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDBRestore.btnOKClick(Sender: TObject);
var
  j: integer;
  lRestoreService: TIBRestoreService;
  lOptions: TRestoreOptions;
  lVerboseInfo: TStringList;
  dbProps: TibcDatabaseProps;
begin
  if VerifyInputData() then
  begin
    Screen.Cursor := crHourglass;
    lVerboseInfo := TStringList.Create;
    lRestoreService := TIBRestoreService.Create(nil);
    try
      try
        lRestoreService.LoginPrompt := false;
        lRestoreService.ServerName := FSourceServerNode.Server.ServerName;
        lRestoreService.Protocol := FSourceServerNode.Server.Protocol;
        lRestoreService.Params.Clear;
        lRestoreService.Params.Assign(FSourceServerNode.Server.Params);
        lRestoreService.Attach();
      except
        on E:EIBError do
        begin
          DisplayMsg(EIBInterBaseError(E).IBErrorCode, E.Message);
          Screen.Cursor := crDefault;
          if (EIBInterBaseError(E).IBErrorCode = isc_lost_db_connection) or
             (EIBInterBaseError(E).IBErrorCode = isc_unavailable) or
             (EIBInterBaseError(E).IBErrorCode = isc_network_error) then
            frmMain.SetErrorState;
          SetErrorState;
          Exit;
        end;
      end;

      lOptions := [];
      if lRestoreService.Active = true then
      begin
        if sgOptions.Cells[OPTION_VALUE_COL,OVERWRITE_ROW] = LZTDBRestoreTrue then
        begin
          Include(lOptions, Replace);
        end
        else
        begin
          Include(lOptions, CreateNewDB);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,COMMIT_EACH_TABLE_ROW] = LZTDBRestoreTrue then
        begin
          Include(lOptions, OneRelationAtATime);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,CREATE_SHADOW_FILES_ROW] = LZTDBRestoreFalse then
        begin
          Include(lOptions, NoShadow);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,DEACTIVATE_INDICES_ROW] = LZTDBRestoreTrue then
        begin
          Include(lOptions, DeactivateIndexes);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,VALIDITY_CONDITIONS_ROW] = LZTDBRestoreFalse then
        begin
          Include(lOptions, NoValidityCheck);
        end;

        lRestoreService.Options := lOptions;
        lRestoreService.PageSize := StrToInt(sgOptions.Cells[OPTION_VALUE_COL,PAGE_SIZE_ROW]);

        if (sgOptions.Cells[OPTION_VALUE_COL,VERBOSE_OUTPUT_ROW] = LZTDBRestoreToScreen) or
          (sgOptions.Cells[OPTION_VALUE_COL,VERBOSE_OUTPUT_ROW] = LZTDBRestoreToFile) then
        begin
          lRestoreService.Verbose := true;
        end;

        for j := 1 to sgBackupFiles.RowCount - 1 do
        begin
          if sgBackupFiles.Cells[0,j] <> '' then
            lRestoreService.BackupFile.Add(Format('%s',[sgBackupFiles.Cells[0,j]]));
        end;

        if cbDBServer.ItemIndex > -1 then
        begin
          for j := 1 to sgDatabaseFiles.RowCount - 1 do
          begin
            if not (IsValidDBName(sgDatabaseFiles.Cells[0,j])) then
              DisplayMsg(WAR_REMOTE_FILENAME, Format(LZTDBRestoreFile, [sgDatabaseFiles.Cells[0,j]]));

            if (sgDatabaseFiles.Cells[0,j] <> '') and (sgDatabaseFiles.Cells[1,j] <> '')then
            begin
              lRestoreService.DatabaseName.Add(Format('%s=%s',[sgDatabaseFiles.Cells[0,j],sgDatabaseFiles.Cells[1,j]]));
            end
            else
            begin
              lRestoreService.DatabaseName.Add(sgDatabaseFiles.Cells[0,j]);
            end;
          end;
        end;
        Screen.Cursor := crHourGlass;
        try
          lRestoreService.ServiceStart;
          FSourceServerNode.OpenTextViewer (lRestoreService, LZTDBRestoreDatabaseRestore);
          while (lRestoreService.IsServiceRunning) and (not gApplShutdown) do
          begin
            Application.ProcessMessages;
            Screen.Cursor := crHourGlass;
          end;

          if lRestoreService.Active then
            lRestoreService.Detach();

          { If the database alias entered does not already exist, create it }
          // kris start
          if not PersistentInfo.DatabaseAliasExists(FSourceServerNode.ServerName, cbDBAlias.Text) then
          begin
            PersistentInfo.GetDatabaseProps(cbDBServer.Text, cbDBAlias.Text, dbProps);
            dbProps.DatabaseFiles := lRestoreService.DatabaseName.Text;
            dbProps.Username := FSourceServerNode.UserName;
            PersistentInfo.StoreDatabaseProps(cbDBServer.Text, cbDBAlias.Text, dbProps);
            frmMain.tvMainChange(nil, nil);
            end;
          ModalResult := mrOK;          
        except
          on E: EIBError do
          begin
            DisplayMsg(EIBInterBaseError(E).IBErrorCode, E.Message);
            if (EIBInterBaseError(E).IBErrorCode = isc_lost_db_connection) or
               (EIBInterBaseError(E).IBErrorCode = isc_unavailable) or
               (EIBInterBaseError(E).IBErrorCode = isc_network_error) then
              frmMain.SetErrorState;
            SetErrorState;
          end;
        end;
      end;
    finally
      if lRestoreService.Active then
        lRestoreService.Detach();
      lRestoreService.Free();
      lVerboseInfo.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmDBRestore.cbOptionsChange(Sender: TObject);
var
  lSaveDialog: TSaveDialog;
begin
  lSaveDialog := nil;
  if (cbOptions.Text = LZTDBRestoreToFile) and (sgOptions.Row = VERBOSE_OUTPUT_ROW) then
  begin
    try
      lSaveDialog := TSaveDialog.Create(Self);
      lSaveDialog.Title := LZTDBRestoreSelectVerboseFile;
      lSaveDialog.DefaultExt := 'txt';
      lSaveDialog.Filter := LZTDBRestoreFileFilter;
      lSaveDialog.Options := [ofHideReadOnly,ofEnableSizing];
      if lSaveDialog.Execute then
      begin
        if FileExists(lSaveDialog.FileName) then
        begin
          if MessageDlg(Format(LZTDBRestoreOverWrite, [lSaveDialog.FileName]),
              mtConfirmation, mbYesNoCancel, 0) <> idYes then
          begin
            cbOptions.ItemIndex := cbOptions.Items.IndexOf(LZTDBRestoreToScreen);
            Exit;
          end;
        end;
        FVerboseFile := lSaveDialog.FileName;
      end
      else
        cbOptions.ItemIndex := cbOptions.Items.IndexOf(LZTDBRestoreToScreen);
    finally
      lSaveDialog.free;
    end;
  end;

  {
  sgOptions.Cells[sgOptions.Col,sgOptions.Row] :=
    cbOptions.Items[cbOptions.ItemIndex];
  cbOptions.Visible := false;
  sgOptions.SetFocus;
  }
end;

procedure TfrmDBRestore.cbOptionsDblClick(Sender: TObject);
begin
  if (sgOptions.Col = OPTION_VALUE_COL) or (sgOptions.Col = OPTION_NAME_COL) then
  begin
    if cbOptions.ItemIndex = cbOptions.Items.Count - 1 then
      cbOptions.ItemIndex := 0
    else
      cbOptions.ItemIndex := cbOptions.ItemIndex + 1;

    if sgOptions.Col = OPTION_VALUE_COL then
      sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[cbOptions.ItemIndex];

    // cbOptions.Visible := True;
    // sgOptions.SetFocus;
  end;
end;

procedure TfrmDBRestore.cbOptionsExit(Sender: TObject);
var
  lR : TRect;
  iIndex : Integer;
begin
  iIndex := cbOptions.Items.IndexOf(cbOptions.Text);

  if (iIndex = -1) then
  begin
    MessageDlg(LZTDBRestoreInvalidOptionValue, mtError, [mbOK], 0);

    cbOptions.ItemIndex := 0;
    //Size and position the combo box to fit the cell
    lR := sgOptions.CellRect(OPTION_VALUE_COL, sgOptions.Row);
    lR.Left := lR.Left + sgOptions.Left;
    lR.Right := lR.Right + sgOptions.Left;
    lR.Top := lR.Top + sgOptions.Top;
    lR.Bottom := lR.Bottom + sgOptions.Top;
    cbOptions.Left := lR.Left + 1;
    cbOptions.Top := lR.Top + 1;
    cbOptions.Width := (lR.Right + 1) - lR.Left;
    cbOptions.Height := (lR.Bottom + 1) - lR.Top;
    cbOptions.Visible := True;
    cbOptions.SetFocus;
  end
  else if (sgOptions.Col <> OPTION_NAME_COL) then
  begin
    sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[iIndex];
  end
  else
  begin
    sgOptions.Cells[OPTION_VALUE_COL,sgOptions.Row] := cbOptions.Items[iIndex];
  end;
end;

procedure TfrmDBRestore.cbOptionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) then
    cbOptions.DroppedDown := true;
end;

procedure TfrmDBRestore.edtDestinationDBChange(Sender: TObject);
begin
//  edtDestinationDB.Hint := edtDestinationDB.Text;
end;

procedure TfrmDBRestore.edtSourceDBChange(Sender: TObject);
begin
//  edtSourceDB.Hint := edtSourceDB.Text;
end;

procedure TfrmDBRestore.sgBackupFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    if sgBackupFiles.Col < sgBackupFiles.ColCount - 1 then
    begin
      sgBackupFiles.Col := sgBackupFiles.Col + 1;
    end
    else
    begin
      if sgBackupFiles.Row = sgBackupFiles.RowCount - 1 then
        sgBackupFiles.RowCount := sgBackupFiles.RowCount + 1;
      sgBackupFiles.Col := 0;
      sgBackupFiles.Row := sgBackupFiles.Row + 1;
    end;
  end;
end;

procedure TfrmDBRestore.sgDatabaseFilesDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  INDENT = 2;
var
  lLeft: integer;
  lText: string;
begin
  with Sender as TStringGrid do //sgDatabaseFiles.canvas do
  begin
    if (ACol = 2) and (ARow <> 0) then
    begin
      canvas.font.color := clBlack;
      if canvas.brush.color = clHighlight then
        canvas.font.color := clWhite;
      lText := Cells[ACol,ARow];
      lLeft := Rect.Left + INDENT;
      Canvas.TextRect(Rect, lLeft, Rect.top + INDENT, lText);
    end;
  end;
end;

procedure TfrmDBRestore.sgDatabaseFilesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lKey : Word;
begin
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    if sgDatabaseFiles.Col < sgDatabaseFiles.ColCount - 1 then
    begin
      sgDatabaseFiles.Col := sgDatabaseFiles.Col + 1;
    end
    else
    begin
      if sgDatabaseFiles.Row = sgDatabaseFiles.RowCount - 1 then
        sgDatabaseFiles.RowCount := sgDatabaseFiles.RowCount + 1;
      sgDatabaseFiles.Col := 0;
      sgDatabaseFiles.Row := sgDatabaseFiles.Row + 1;
    end;
  end;

  if (Key = VK_RETURN) and
    (sgDatabaseFiles.Cells[sgDatabaseFiles.Col,sgDatabaseFiles.Row] <> '') then
  begin
    lKey := VK_TAB;
    sgDatabaseFilesKeyDown(Self, lKey, [ssCtrl]);
  end;

end;

procedure TfrmDBRestore.sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const
  INDENT = 2;
var
  lLeft: integer;
  lText: string;
begin
  with sgOptions.canvas do
  begin
    if ACol = OPTION_VALUE_COL then
    begin
      font.color := clBlue;
      if brush.color = clHighlight then
        font.color := clWhite;
      lText := sgOptions.Cells[ACol,ARow];
      lLeft := Rect.Left + INDENT;
      TextRect(Rect, lLeft, Rect.top + INDENT, lText);
    end;
  end;
end;

procedure TfrmDBRestore.sgOptionsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  lR, lName : TRect;
begin
  cbOptions.Items.Clear;
  case ARow of
    PAGE_SIZE_ROW:
    begin
      cbOptions.Items.Add('1024');
      cbOptions.Items.Add('2048');
      cbOptions.Items.Add('4096');
      cbOptions.Items.Add('8192');
    end;
    OVERWRITE_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreTrue);
      cbOptions.Items.Add(LZTDBRestoreFalse);
    end;
    COMMIT_EACH_TABLE_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreTrue);
      cbOptions.Items.Add(LZTDBRestoreFalse);
    end;
    CREATE_SHADOW_FILES_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreTrue);
      cbOptions.Items.Add(LZTDBRestoreFalse);
    end;
    DEACTIVATE_INDICES_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreTrue);
      cbOptions.Items.Add(LZTDBRestoreFalse);
    end;
    VALIDITY_CONDITIONS_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreRestore);
      cbOptions.Items.Add(LZTDBRestoreIgnore);
    end;
    USE_ALL_SPACE_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreTrue);
      cbOptions.Items.Add(LZTDBRestoreFalse);
    end;
    VERBOSE_OUTPUT_ROW:
    begin
      cbOptions.Items.Add(LZTDBRestoreNone);
      cbOptions.Items.Add(LZTDBRestoreToScreen);
      cbOptions.Items.Add(LZTDBRestoreToFile);
    end;
  end;

  pnlOptionName.Caption := sgOptions.Cells[OPTION_NAME_COL, ARow];

  if ACol = OPTION_NAME_COL then
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol+1,ARow])
  else if ACol = OPTION_VALUE_COL then
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol,ARow]);

  if ACol = OPTION_NAME_COL then
  begin
    lName := sgOptions.CellRect(ACol, ARow);
    lR := sgOptions.CellRect(ACol + 1, ARow);
  end
  else
  begin
    lName := sgOptions.CellRect(ACol - 1, ARow);
    lR := sgOptions.CellRect(ACol, ARow);
  end;

  // lName := sgOptions.CellRect(ACol, ARow);
  lName.Left := lName.Left + sgOptions.Left;
  lName.Right := lName.Right + sgOptions.Left;
  lName.Top := lName.Top + sgOptions.Top;
  lName.Bottom := lName.Bottom + sgOptions.Top;
  pnlOptionName.Left := lName.Left + 1;
  pnlOptionName.Top := lName.Top + 1;
  pnlOptionName.Width := (lName.Right + 1) - lName.Left;
  pnlOptionName.Height := (lName.Bottom + 1) - lName.Top;
  pnlOptionName.Visible := True;

  // lR := sgOptions.CellRect(ACol, ARow);
  lR.Left := lR.Left + sgOptions.Left;
  lR.Right := lR.Right + sgOptions.Left;
  lR.Top := lR.Top + sgOptions.Top;
  lR.Bottom := lR.Bottom + sgOptions.Top;
  cbOptions.Left := lR.Left + 1;
  cbOptions.Top := lR.Top + 1;
  cbOptions.Width := (lR.Right + 1) - lR.Left;
  cbOptions.Height := (lR.Bottom + 1) - lR.Top;
  cbOptions.Visible := True;
  cbOptions.SetFocus;
end;

function TfrmDBRestore.VerifyInputData(): boolean;
var
  lCnt: integer;
  found: boolean;

begin
  result := true;
  found := false;
  // check if backup alias combo box is not empty
  // problem: how to restore if there's no backup alias
  if cbBackupAlias.Text = '' then
  begin
    DisplayMsg(ERR_BACKUP_ALIAS, '');
    cbBackupAlias.SetFocus;
    Result := false;
    Exit;
  end;

  // check if combo box is empty or nothing selected
  if (cbDBServer.ItemIndex = -1) or (cbDBServer.Text = '') or (cbDBServer.Text = ' ') then
  begin
    DisplayMsg(ERR_SERVER_NAME,'');
    cbDBServer.SetFocus;
    result := false;
    Exit;
  end;

  // check if combo box is empty
  if (cbDBAlias.Text = '') or (cbDBAlias.Text = ' ') then
  begin
    DisplayMsg(ERR_DB_ALIAS,'');
    cbDBAlias.SetFocus;
    result := false;
    Exit;
  end;

  for lCnt := 1 to sgDatabaseFiles.RowCount - 1 do
  begin
    if (sgDatabaseFiles.Cells[0,lCnt] <> '') then
      found := true;
  end;

  if not found then
  begin
    DisplayMsg (ERR_NO_FILES,'');
    result := false;
    exit;
  end;

end;

function DoDBRestore(const SourceServerNode: TibcServerNode;
                     const SourceBackupAliasNode: TibcTreeNode): integer;
var
  i: integer;
  frmDBRestore: TfrmDBRestore;
  lBackupAliasNode: TibcBackupAliasNode;
  lCurrBackupAliasesNode: TTreeNode;
  AliasName: String;

begin
  frmDBRestore := nil;
  lBackupAliasNode := nil;

  if SourceBackupAliasNode is TibcBackupAliasNode then
    lBackupAliasNode := TibcBackupAliasNode(SourceBackupAliasNode);
  try
    frmDBRestore := TfrmDBRestore.Create(Application.MainForm);
    frmDBRestore.FSourceServerNode := SourceServerNode;
    frmDBRestore.stxBackupServer.Caption := SourceServerNode.NodeName;
    lCurrBackupAliasesNode := frmMain.tvMain.Items[SourceServerNode.BackupFilesID];

    for i := 1 to TibcTreeNode(lCurrBackupAliasesNode.Data).ObjectList.Count - 1 do
    begin
      AliasName := TibcTreeNode(lCurrBackupAliasesNode.Data).ObjectList.Strings[i];

      frmDBRestore.cbBackupAlias.Items.AddObject(GetNextField (AliasName, DEL),
      TibcBackupAliasNode(TTreeNode(TibcTreeNode(lCurrBackupAliasesNode.Data).ObjectList.Objects[i]).Data));
    end;

    for i := 1 to TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Count - 1 do
    begin
      AliasName := TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Strings[i];
      frmDBRestore.cbDBServer.Items.AddObject(GetNextField(AliasName, DEL),
        TibcServerNode(TTreeNode(TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Objects[i]).Data));
    end;

    if Assigned(SourceBackupAliasNode) then
    begin
      frmDBRestore.cbBackupAlias.ItemIndex := frmDBRestore.cbBackupAlias.Items.IndexOf(SourceBackupAliasNode.NodeName);
      frmDBRestore.cbBackupAliasChange(frmDBRestore);

      if Assigned (lBackupAliasNode) then
      begin
        frmDBRestore.cbDBServer.ItemIndex := frmDBRestore.cbDBServer.Items.IndexOf(lBackupAliasNode.SourceDBServer);
        frmDBRestore.cbDBServerChange(frmDBRestore);
        frmDBRestore.cbDBAlias.ItemIndex := frmDBRestore.cbDBAlias.Items.IndexOf(lBackupAliasNode.SourceDBAlias);
        frmDBRestore.cbDBAliasChange(frmDBRestore);
      end;
    end;

    frmDBRestore.ShowModal;
    if (frmDBRestore.ModalResult = mrOK) and
       (not frmDBRestore.GetErrorState)then
    begin
      if Assigned (lBackupAliasNode) then
      begin
        if lBackupAliasNode.SourceDBAlias = '' then
          lBackupAliasNode.SourceDBAlias := frmDBRestore.cbDBAlias.Text;
      end;
      DisplayMsg(INF_RESTORE_DB_SUCCESS,'');
      result := SUCCESS;
    end
    else
      result := FAILURE;
  finally
    frmDBRestore.Free;
  end;
end;

procedure TfrmDBRestore.cbDBServerChange(Sender: TObject);
var
  s: string;
  i: integer;
  lCurrDatabaseAliasesNode: TTreeNode;
begin
  cbDBAlias.Items.Clear;
  cbDBAlias.Text := '';

  if cbDBServer.ItemIndex <> -1 then
  begin
    lCurrDatabaseAliasesNode := frmMain.tvMain.Items[TibcServerNode(cbDBServer.Items.Objects[cbDBServer.ItemIndex]).DatabasesID];

    if Assigned(lCurrDatabaseAliasesNode) then
    begin
      if TibcServerNode(lCurrDatabaseAliasesNode.Data).ObjectList.Count <> 0 then
      begin
        for i := 1 to TibcServerNode(lCurrDatabaseAliasesNode.Data).ObjectList.Count - 1 do
        begin
          s := TibcTreeNode(lCurrDatabaseAliasesNode.Data).ObjectList.Strings[i];
          cbDBAlias.Items.AddObject(GetNextField(s, DEL),
            TibcDatabaseNode(TTreeNode(TibcTreeNode(lCurrDatabaseAliasesNode.Data).ObjectList.Objects[i]).Data));
        end;
      end;
    end;
  end;
end;

procedure TfrmDBRestore.cbDBAliasChange(Sender: TObject);
var
  i: integer;
  lCurrDBNode: TTreeNode;
  lCurrServerNode: TTreeNode;
  lCurrLine: string;
begin
  for i := 1 to sgDatabaseFiles.RowCount do
  begin
    sgDatabaseFiles.Cells[0,i] := '';
    sgDatabaseFiles.Cells[1,i] := '';
  end;

  if (cbDBAlias.ItemIndex > -1) and (Assigned(cbDBAlias.Items.Objects[cbDBAlias.ItemIndex])) then
    lCurrDBNode := frmMain.tvMain.Items[TibcDatabaseNode(cbDBAlias.Items.Objects[cbDBAlias.ItemIndex]).NodeID]
  else
    lCurrDBNode := nil;

  if (cbDBAlias.ItemIndex > -1) and (Assigned(cbDBServer.Items.Objects[cbDBServer.ItemIndex])) then
    lCurrServerNode := frmMain.tvMain.Items[TibcServerNode(cbDBServer.Items.Objects[cbDBServer.ItemIndex]).NodeID]
  else
    lCurrServerNode := nil;

  if Assigned(lCurrDBNode) and Assigned(lCurrServerNode) then
  begin

    for i := 1 to TibcDatabaseNode(lCurrDBNode.Data).DatabaseFiles.Count do
    begin
      lCurrLine := TibcDatabaseNode(lCurrDBNode.Data).DatabaseFiles.Strings[i - 1];
      while Length(lCurrLine) > 0 do
      begin
        sgDatabaseFiles.Cells[0,i] := zluUtility.GetNextField(lCurrLine,'=');
        sgDatabaseFiles.Cells[1,i] := zluUtility.GetNextField(lCurrLine,'=');
      end;
      sgDatabaseFiles.RowCount := sgDatabaseFiles.RowCount + 1;
    end;
  end;
end;

procedure TfrmDBRestore.cbBackupAliasChange(Sender: TObject);
var
  i: integer;
  lCurrBackupAliasNode: TTreeNode;
  lCurrLine: string;
  GridOptions: set of TGridOption;
  OpenDlg: TOpenDialog;
begin

  with cbBackupAlias do begin
    with sgBackupFiles do begin
      RowCount := 4;
      for i := 1 to RowCount do
      begin
        Cells[0,i] := '';
        Cells[1,i] := '';
      end;

      if ItemIndex = 0 then
        begin
        // Allow the user to select files for backup
        OnDrawCell := sgDatabaseFilesDrawCell;
        OnKeyDown := sgDatabaseFilesKeyDown;
        Color := clWindow;
        GridOptions := Options;
        Include (GridOptions, goEditing);
        Options := GridOptions;
        sgBackupFiles.SetFocus;

        // If the server is local, allow the user to browse for a file
        if FSourceServerNode.Server.Protocol = Local then
        begin
          OpenDlg := TOpenDialog.Create(Self);
          with OpenDlg do
          begin
            Options := [ofAllowMultiSelect, ofFileMustExist];
            Filter := LZTDBRestoreBackupFileFilter;
            FilterIndex := 1;
            if Execute then
            begin
              if RowCount < Files.Count then
                RowCount := Files.Count;

              for i:= 0 to Files.Count - 1 do
                Cells[0, i+1] := Files.Strings[i];
            end;
            Free;
          end;
        end;
      end
      else begin  // Read the alias for backup information
        if (ItemIndex > 0) and (Assigned(Items.Objects[ItemIndex])) then
        begin
          GridOptions := Options;
          Exclude (GridOptions, goEditing);
          Options := GridOptions;
          OnDrawCell := nil;
          OnKeyDown := nil;
          Color := clbtnFace;
          Row := 1;
          lCurrBackupAliasNode := frmMain.tvMain.Items[TibcBackupAliasNode(Items.Objects[ItemIndex]).NodeID];
          for i := 1 to TibcBackupAliasNode(lCurrBackupAliasNode.Data).BackupFiles.Count do
          begin
            lCurrLine := TibcBackupAliasNode(lCurrBackupAliasNode.Data).BackupFiles.Strings[i-1];
            while Length(lCurrLine) > 0 do
            begin
              Cells[0,i] := zluUtility.GetNextField(lCurrLine,'=');
              Cells[1,i] := zluUtility.GetNextField(lCurrLine,'=');
            end;
            RowCount := RowCount + 1;
          end;
          cbDBServer.ItemIndex := cbDBServer.Items.IndexOf(TibcBackupAliasNode(lCurrBackupAliasNode.Data).SourceDBServer);
          cbDBServerChange(self);
          cbDBAlias.ItemIndex := cbDBAlias.Items.IndexOf(TibcBackupAliasNode(lCurrBackupAliasNode.Data).SourceDBAlias);
          cbDBAliasChange(self);
        end;
      end;
    end;
  end;
end;

procedure TfrmDBRestore.IncreaseRows(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  with Sender as TStringGrid do begin
    if ARow = RowCount-1 then
      RowCount := RowCount + 1;
  end;
end;

Procedure TfrmDBRestore.TranslateVisual;
Begin
  lblOptions.Caption := LZTDBRestorelblOptions;
  gbDatabaseFiles.Caption := LZTDBRestoregbDatabaseFiles;
  lblDestinationServer.Caption := LZTDBRestorelblDestinationServer;
  lblDBAlias.Caption := LZTDBRestorelblDBAlias;
  gbBackupFiles.Caption := LZTDBRestoregbBackupFiles;
  lblBackupServer.Caption := LZTDBRestorelblBackupServer;
  lblBackupAlias.Caption := LZTDBRestorelblBackupAlias;
  btnOK.Caption := LZTDBRestorebtnOK;
  btnCancel.Caption := LZTDBRestorebtnCancel;
  Self.Caption := LZTDBRestoreFormTitle;
End;

end.
