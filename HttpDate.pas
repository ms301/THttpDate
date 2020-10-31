unit HttpDate;

interface

type
  /// <summary>
  /// Работа с датами вида "Mon, 04 Feb 2013 04:27:24 GMT"
  /// </summary>
  THttpDate = record
  private
    fYear: Word;
    fDayName: string;
    fDay: Word;
    FMonthName: string;
    FMonth: Word;
    FTime: string;
    /// <summary>
    /// Переводит имя месяца в его порядковый номер
    /// </summary>
    function MonthToIndex(const AMonthName: string): Integer;
  public
    /// <summary>
    /// В качестве аргумента передается строка вида "Mon, 04 Feb 2013 04:27:24 GMT"
    /// </summary>
    class function Create(const ADateString: string): THttpDate; overload; static;
    /// <summary>
    /// В качестве аргумента передается TDateTime
    /// </summary>
    class function Create(const ADateTime: TDateTime): THttpDate; overload; static;
    /// <summary>
    /// Возвращает только дату
    /// </summary>
    function AsDate: TDate;
    /// <summary>
    /// Возвращает только время
    /// </summary>
    function AsTime: TTime;
    /// <summary>
    /// Возвращает дату и время
    /// </summary>
    function AsDateTime: TDateTime;
    /// <summary>
    /// Возвращает строку вида "Mon, 04 Feb 2013 04:27:24 GMT"
    /// </summary>
    function ToString: string;
    /// <summary>
    /// День недели
    /// </summary>
    property DayName: string read fDayName write fDayName;
    /// <summary>
    /// Число даты
    /// </summary>
    property Day: Word read fDay write fDay;
    /// <summary>
    /// Название месяца
    /// </summary>
    property MonthName: string read FMonthName write FMonthName;
    /// <summary>
    /// Порядковый номер месяца
    /// </summary>
    property Month: Word read FMonth write FMonth;
    /// <summary>
    /// Год
    /// </summary>
    property Year: Word read fYear write fYear;
    /// <summary>
    /// Время в виде "04:27:24"
    /// </summary>
    property Time: string read FTime write FTime;
  end;

implementation

uses
  System.SysUtils;

{ THttpDate }

function THttpDate.AsDate: TDate;
begin
  Result := EncodeDate(fYear, FMonth, fDay);
end;

function THttpDate.AsDateTime: TDateTime;
begin
  Result := AsDate + AsTime;
end;

function THttpDate.AsTime: TTime;
begin
  Result := StrToTime(FTime);
end;

class function THttpDate.Create(const ADateTime: TDateTime): THttpDate;
var
  LDateFormat: TFormatSettings;
begin
  LDateFormat := TFormatSettings.Invariant;
  DecodeDate(ADateTime, Result.fYear, Result.FMonth, Result.fDay);
  Result.FTime := TimeToStr(ADateTime);
  Result.fDayName := LDateFormat.ShortDayNames[DayOfWeek(ADateTime)];
  Result.FMonthName := LDateFormat.ShortMonthNames[Result.FMonth];
end;

class function THttpDate.Create(const ADateString: string): THttpDate;
var
  lDateStructure: TArray<string>;
begin
  lDateStructure := ADateString.Split([' ']);
  if Length(lDateStructure) <> 6 then
    raise EConvertError.Create('Unknown format of date');
  Result.fDayName := lDateStructure[0].Substring(0, lDateStructure[0].Length - 1);
  Result.fDay := lDateStructure[1].ToInteger;
  Result.FMonthName := lDateStructure[2];
  Result.FMonth := Result.MonthToIndex(lDateStructure[2]);
  Result.fYear := lDateStructure[3].ToInteger;
  Result.FTime := lDateStructure[4];
end;

function THttpDate.MonthToIndex(const AMonthName: string): Integer;
var
  LDateFormat: TFormatSettings;
  I: Integer;
begin
  Result := -1;
  LDateFormat := TFormatSettings.Invariant;
  for I := Low(LDateFormat.ShortMonthNames) to High(LDateFormat.ShortMonthNames) do
    if LDateFormat.ShortMonthNames[I] = AMonthName then
    begin
      Result := I;
      Break;
    end;
end;

function THttpDate.ToString: string;
begin
  Result := Format('%s, %.2d %s %d %s GMT', [fDayName, fDay, FMonthName, fYear, FTime]);
end;

end.
