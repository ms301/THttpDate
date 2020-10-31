unit HttpDate.Test;

interface

uses
  DUnitX.TestFramework;

type

  [TestFixture]
  THttpDateTest = class
  public
    [Test]
    [TestCase('TestA', 'Mon, 04 Feb 2013 04:27:24 GMT', ';')]
    procedure Test(const AHttpDateStr: string);
  end;

implementation

uses
  HttpDate;

{ THttpDateTest }

procedure THttpDateTest.Test(const AHttpDateStr: string);
var
  lHttpDate: THttpDate;
  LDateTime: TDateTime;
begin
  // Парсинг строки
  lHttpDate := THttpDate.Create(AHttpDateStr);
  // Проверка обратного перевода в строку
  Assert.AreEqual(AHttpDateStr, lHttpDate.ToString);
  // Проверка перевода в TDateTime
  LDateTime := lHttpDate.AsDateTime;
  // Заполнение THttpDate из TDateTime
  lHttpDate := THttpDate.Create(LDateTime);
  // Проверка перевода в строку
  Assert.AreEqual(AHttpDateStr, lHttpDate.ToString);
end;

initialization

TDUnitX.RegisterTestFixture(THttpDateTest);

end.
