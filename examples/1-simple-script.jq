import "jq-unit" as jqunit;

def upperCaseOfFooIsNotBar:
  jqunit::test("upper case of foo is not bar") |
  jqunit::Given("foo") |
  jqunit::When(ascii_upcase) |
  jqunit::Then(. != "bar")
;

def upperCaseOfFooIsFOO:
  jqunit::test("upper case of foo is FOO") |
  jqunit::Given("foo") |
  jqunit::When(ascii_upcase) |
  jqunit::Then(. == "FOO")
;

def runAll:
  jqunit::all(
      upperCaseOfFooIsNotBar,
      upperCaseOfFooIsFOO
  )
;
