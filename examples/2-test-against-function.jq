import "jq-unit" as jqunit;

def unitFizzBuzzFunction:
  if . % 15 == 0
  then "FizzBuzz"

  elif . % 5 == 0
  then "Buzz"

  elif . % 3 == 0
  then "Fizz"

  else "\(.)"
  end
;

def createTest(expectString):
  . as $numero |
  jqunit::test("\($numero) becomes \(expectString)") |
  jqunit::Given($numero) |
  jqunit::When(. | unitFizzBuzzFunction) |
  jqunit::Then(. == expectString)
;

def multiplesOf15BecomeFizzBuzz:
  range(20) |
  . * 15 |
  createTest("FizzBuzz")
;

def multiplesOf5WithoutMultiplesOf3BecomeBuzz:
  range(20) |
  if . % 3== 0 then empty else . end |
  . * 5 |
  createTest("Buzz")
;

def multiplesOf3WithoutMultiplesOf5BecomeFizz:
  range(20) |
  if . % 5 == 0 then empty else . end |
  . * 3 |
  createTest("Fizz")
;

def numberWithoutMultiplesOf3And5BecomesItself:
  range(30) |
  if (. % 5 == 0) or (. % 3 == 0) then empty else . end |
  createTest("\(.)")
;

def runAll:
  jqunit::all(
      multiplesOf15BecomeFizzBuzz,
      multiplesOf5WithoutMultiplesOf3BecomeBuzz,
      multiplesOf3WithoutMultiplesOf5BecomeFizz,
      numberWithoutMultiplesOf3And5BecomesItself
  )
;
