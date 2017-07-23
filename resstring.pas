unit resstring;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Resourcestring
  {All}
  LZTFilterProgramFiles    = 'Program Files ';
  LZTToolPropertiesTitleLbl = '&Title:';
  LZTToolPropertiesProgramLbl = '&Program';
  LZTToolPropertiesWorkingDirLbl = '&Working Dir:';
  LZTToolPropertiesParameterLbl = 'P&arameters:';
  LZTToolPropertiesButtonOkFiles = '&OK';
  LZTToolPropertiesButtonCancelFiles = '&Cancel';
  LZTToolPropertiesButtonBrowseFiles = '&Browse';
  LZTToolPropertiesFormTitle = 'Tool Properties';
  LZTAboutFormTitle = 'About';
  LZTAboutFbMStudioVer = 'Version: ';
  LZTAboutFirebirdVer = 'Firebird Version: ';
  LZTAboutInterbase = 'Interbase Version: ';
  LZTAboutButtonOkFiles = '&OK';
  LZTCommDiagOpenDialogDefaultExt = 'fdb';
  LZTCommDiagOpenDialogFilter = 'Database File (*.fdb)|*.FDB|All files (*.*)|*.*';
  LZTCommDiagPinging = 'Pinging';
  LZTCommDiagWith = 'with';
  LZTCommDiagBytesOfData = 'bytes of data:';
  LZTCommDiagReplyFrom = 'Reply from';
  LZTCommDiagBytes = 'bytes';
  LZTCommDiagTime = 'time';
  LZTCommDiagPingStat = 'Ping statistics for';
  LZTCommDiagPacketsSend = 'Packets: Send';
  LZTCommDiagPacketsReceived = 'Received';
  LZTCommDiagLost = 'Lost';
  LZTCommDiagApproxRoundTripTimes = 'Approximate round trip times in milli-seconds:';
  LZTCommDiagMin = 'Minimum';
  LZTCommDiagMax = 'Maximum';
  LZTCommDiagAvg = 'Average';
  LZTCommDiagUnknow = 'Unknown host';
  LZTCommDiagAttemptConnect = 'Attempting to connect to:';
  LZTCommDiagVersion = 'Version :';
  LZTCommDiagAttachPassed = 'Attaching    ... Passed!';
  LZTCommDiagDetachPassed = 'Detaching    ... Passed!';
  LZTCommDiagErrorOccured = 'An Firebird error has occurred while';
  LZTCommDiagError = 'Error - ';
  LZTCommDiagAttaching = 'attaching.';
  LZTCommDiagDetaching = 'detaching';
  LZTCommDiagCommTest = 'Firebird Communication Test';
  LZTCommDiagPassed = 'Passed!';
  LZTCommDiagFailed = 'Failed!';
  LZTCommDiagAttempingConnection = 'Attempting connection to';
  LZTCommDiagSocketConnectionObtained = 'Socket for connection obtained.';
  LZTCommDiagFoundService = 'Found service';
  LZTCommDiagAtPort = 'at port';
  LZTCommDiagCouldNotResolveService = 'Could not resolve service';
  LZTCommDiagFailedConnectHost = 'Failed to connect to host';
  LZTCommDiagErrorMessage = 'Error Message:';
  LZTCommDiagOnPort = 'on port';
  LZTCommDiagConnectEstablishedToHost = 'Connection established to host';
  LZTCommDiagTCPIPCommTest = 'TCP/IP Communication Test';
  LZTCommDiagFormTitle = 'Communication Diagnostics';
  LZTCommDiagtabDBConnectionCaption = 'DB Connection';
  LZTCommDiagbtnTestCaption = '&Test';
  LZTCommDiagbtnCancelCaption = '&Cancel';
  LZTCommDiagtabTCPIPCaption = 'TCP/IP';
  LZTCommDiaggbTCPIPServerInfoCaption = 'Server Information';
  LZTCommDiaglblWinsockServerCaption = '&Host:';
  LZTCommDiaglblServiceCaption = '&Service:';
  LZTCommDiaglblWinSockResultsCaption = '&Results:';
  LZTCommDiagrbLocalServerCaption = '&Local Server';
  LZTCommDiagrbRemoteServerCaption = 'R&emote Server';
  LZTCommDiaglblServerNameCaption = '&Server Name:';
  LZTCommDiaglblProtocolCaption = '&Network Protocol:';
  LZTCommDiaggbDatabaseInfoCaption = ' Database Information';
  LZTCommDiaglblDatabaseCaption = '&Database:';
  LZTCommDiaglblUsernameCaption = '&User Name:';
  LZTCommDiaglblPasswordCaption = '&Password:';
  LZTCommDiagbtnSelDBHint = 'Select database';
  LZTCommDiagcbProtocolItem1 = 'TCP/IP';
  LZTCommDiagcbProtocolItem2 = 'NetBEUI';
  LZTCommDiagcbProtocolItem3 = 'SPX';
  LZTCommDiagcbProtocolItem4 = 'Local Server';
  LZTCommDiagcbServiceItem1 = '21';
  LZTCommDiagcbServiceItem2 = 'ftp';
  LZTCommDiagcbServiceItem3 = '3050';
  LZTCommDiagcbServiceItem4 = 'gds_db';
  LZTCommDiagcbServiceItem5 = 'ping';
  LZTCommDiagsPropsServerNameLocalServer = 'Local Server';
  LZTMessageFormTitle = 'Message';
  LZTMessagebtnOKCaption = '&OK';
  LZTMessagelblDetailMsgCaption = 'Detail Message:';
  LZTMessageErrorCaption = 'Error';
  LZTMessageWarningCaption = 'Warning';
  LZTMessageInformationCaption = 'Information';
  LZTMessage1Caption = 'Initialization failure.';
  LZTMessage2Caption = 'Invalid username. Please enter a valid username.';
  LZTMessage3Caption = 'Invalid password. Please enter a valid password.';
  LZTMessage4Caption = 'The password does not match the confirmation password.';
  LZTMessage5Caption = 'Unable to add user.';
  LZTMessage6Caption = 'Unable to modify user account.';
  LZTMessage7Caption = 'Unable to delete user.';
  LZTMessage8Caption = 'Unable to retrieve user list.';
  LZTMessage9Caption = 'Unable to retrieve user information.';
  LZTMessage10Caption = 'Invalid source database name. Please enter a valid database name.';
  LZTMessage11Caption = 'Invalid destination database name. Please enter a valid database name.';
  LZTMessage12Caption = 'The source and destination must be different.';
  LZTMessage13Caption = 'Invalid database file or the file does not exist.';
  LZTMessage14Caption = 'Invalid server name. Please enter a valid server name.';
  LZTMessage15Caption = 'Invalid network protocol. Please select a network protocol from the list.';
  LZTMessage16Caption = 'Database backup failed.';
  LZTMessage17Caption = 'Database restore failed.';
  LZTMessage18Caption = 'Unable to retrieve a list of tables.';
  LZTMessage19Caption = 'Unable to retrieve a list of views.';
  LZTMessage20Caption = 'Invalid service. Please select a service from the list.';
  LZTMessage21Caption = 'Invalid numeric value. Please enter a valid numeric value.';
  LZTMessage22Caption = 'Unable to retrieve data.';
  LZTMessage23Caption = 'Invalid database alias. Please enter a valid database name.';
  LZTMessage24Caption = 'Unable to retrieve a list of roles.';
  LZTMessage25Caption = 'Error logging into the requested server.';
  LZTMessage26Caption = 'Error connecting to the requested database.';
  LZTMessage27Caption = 'Error disconnecting from database.';
  LZTMessage28Caption = 'Unable to retrieve a list of procedures.';
  LZTMessage29Caption = 'Unable to retrieve a list of functions.';
  LZTMessage30Caption = 'Unable to retrieve a list of generators.';
  LZTMessage31Caption = 'Unable to retrieve a list of exceptions.';
  LZTMessage32Caption = 'Unable to retrieve a list of blob filters.';
  LZTMessage33Caption = 'Unable to retrieve a list of columns.';
  LZTMessage34Caption = 'Unable to retrieve a list of indices.';
  LZTMessage35Caption = 'Unable to retrieve a list of referential constraints.';
  LZTMessage36Caption = 'Unable to retrieve a list of unique constraints.';
  LZTMessage37Caption = 'Unable to retrieve a list of check constraints.';
  LZTMessage38Caption = 'Unable to retrieve a list of triggers.';
  LZTMessage39Caption = 'An error occured while attempting to extract metadata information.';
  LZTMessage40Caption = 'Invalid Property Value.';
  LZTMessage41Caption = 'An error occured while attempting to extract dependency information.';
  LZTMessage42Caption = 'An error occured while attempting to retrieve database properties.';
  LZTMessage43Caption = 'Invalid database file size.';
  LZTMessage44Caption = 'SQL Error';
  LZTMessage45Caption = 'Service Error';
  LZTMessage46Caption = 'External Editor Error';
  LZTMessage47Caption = 'Invalid server alias. Please enter a valid server alias.';
  LZTMessage48Caption = 'Invalid backup alias. Please enter a valid backup alias.';
  LZTMessage49Caption = 'Database shutdown unsuccessful.';
  LZTMessage50Caption = 'Unable to modify database properties.';
  LZTMessage51Caption = 'An error occured while attempting to drop the database.';
  LZTMessage52Caption = 'An error occured while attempting to open file.';
  LZTMessage53Caption = 'The editor specified is invalid.';
  LZTMessage54Caption = 'The external editor is not specified.';
  LZTMessage55Caption = 'Unable to display blob.  The format is not graphical.';
  LZTMessage56Caption = 'Unable to change the client dialect.';
  LZTMessage57Caption = 'Error occured opening file.';
  LZTMessage58Caption = 'Search string not found.';
  LZTMessage59Caption = 'Unable to print.  Make sure your printer is installed and working.';
  LZTMessage60Caption = 'No path was specified for the backup file or database.';
  LZTMessage61Caption = 'No files were specified for backup or restore.';
  LZTMessage62Caption = 'Unable to retrieve a list of domains.';
  LZTMessage63Caption = 'Unable to launch external tool';
  LZTMessage64Caption = 'Unable to retrieve properties for the object';
  LZTMessage65Caption = 'Invalid alias.  This alias already exists.';
  LZTMessage66Caption = 'Insufficient rights for this operation.';
  LZTMessage67Caption = 'The server is already registered.';
  LZTMessage68Caption = 'This database alias already exists.';
  LZTMessage69Caption = 'The backup file is already registered.';
  LZTMessage70Caption = 'The client dialect does not match the database dialect.';
  LZTMessage71Caption = 'The file name specified may contain a server name.'+#13#10+ 'Some operations may not work correctly.';
  LZTMessage72Caption = 'The user was added successfully.';
  LZTMessage73Caption = 'Database backup completed.';
  LZTMessage74Caption = 'Database restore completed.';
  LZTMessage75Caption = 'No pending transactions were found.';
  LZTMessage76Caption = 'You must restart the server in order for the changes to go into effect.';
  LZTMessage77Caption = 'Database shutdown completed successfully.';
  LZTMessage78Caption = 'Database restart completed successfully.';
  LZTMessage79Caption = 'SQL script done.';
  LZTMessage80Caption = 'Database sweep completed.';
  LZTMessage81Caption = 'To overwrite an existing database, set the Overwrite option to TRUE';
  LZTMessage82Caption = 'An invalid option was specified for the operation.';
  LZTMessage83Caption = 'The parameters for this operation are conflicting.';
  LZTMessage84Caption = 'An operation was not specified.';
  LZTMessage85Caption = 'A database was not specified for the operation';
  LZTMessage86Caption = 'The page size must be specified.';
  LZTMessage87Caption = 'The security database could not be opened.';
  LZTMessage88Caption = 'User name missing.  A user name must be specified for all operations.';
  LZTMessage89Caption = 'An unknown error was encountered while attempting to add the user record.';
  LZTMessage90Caption = 'An unknown error was encountered while attempting to modify the user record.';
  LZTMessage91Caption = 'An unknown error was encountered while attempting to find/modify the user record.';
  LZTMessage92Caption = 'The information for the user was not found.';
  LZTMessage93Caption = 'An unknown error was encountered while attempting to delete the user record.';
  LZTMessage94Caption = 'An unknown error was encountered while attempting to find/delete the user record.';
  LZTMessage95Caption = 'An unknown error was encountered while attempting to find/display the user record.';
  LZTMessage96Caption = 'An unknown error attempting to open a file on the server.';
  LZTMessage97Caption = 'An Unknown Error Occured';
  LZTUtilityTable = 'Table';
  LZTUtilityView = 'View';
  LZTUtilityTrigger = 'Trigger';
  LZTUtilityComputedField = 'Computed Field';
  LZTUtilityValidation = 'Validation';
  LZTUtilityProcedure = 'Procedure';
  LZTUtilityExpressionIndex = 'Expression Index';
  LZTUtilityException = 'Exception';
  LZTUtilityUser = 'User';
  LZTUtilityField = 'Field';
  LZTUtilityIndex = 'Index';
  LZTUtilityRole = 'Role';
  LZTUtilityUnknown = 'Unknown';
  LZTUtilityInterbaseNotInstalled = 'InterBase server is not installed on your computer.';
  LZTUtilityErrorAttemtingCreateDirectCancel = 'An error occurred while attemting to create directory %s. Operation cancelled.';
  LZTUtilityDirectotyNotExistCreateIt = 'The directory %s does not exist. Do you wish to create it?';


implementation

end.

