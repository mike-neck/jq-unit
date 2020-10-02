module {
  "name": "jq-unit",
  "description": "jq-unit is a testframework for jq script.",
  "repository": {
    "type": "git",
    "url": "https://github.com/mike-neck/jq-unit.git",
    "license": "MIT",
    "author": "Shinya Mochida(mike-neck)"
  }
};

# type-name: TestTitle
# properties:
# - name: string

# type-name: TestInput
# properties:
# - name: string
# - input: object | array | string | number | boolean | null

# type-name: TestSubject
# properties:
# - name: string
# - subject: object | array | string | number | boolean | null
# - error: object | null

# type-name: Test
# properties:
# - name: string
# - subject: object | array | string | number | boolean | null
# - test: boolean

# argument: string
# input: N/A
# output: TestTitle
def test(title):
  {name: "\(title)"}
;

# argument: object | array | string | number | boolean | null
# input: TestTitle
# output: TestInput
def Given(input):
  { name: .name, input: input }
;

# argument: filter(to subject: object | array | string | number | boolean | null)
# input: TestInput
# output: TestSubject
def When(operation):
  . as $input |
  try
    { name: $input.name, subject: ($input.input | operation) }
  catch
    { name: $input.name, error: "\(.)" }
;

# argument: filter(to test: boolean)
# input: TestSubject
# output: Test
def Then(condition):
  if .error == null then
    {
      name: .name,
      subject: .subject,
      test: (.subject | condition)
    }
  else
    {
      name: .name,
      subject: .error,
      test: false
    }
  end
;

# argument: iterator(of: Test)
# input: N/A
# output: Test
def all(tests):
  [tests] |
  length as $testSize |
  map(select(.test != true)) |
  if length == 0
  then "ok - tests: \($testSize)"
  else
    ["test failed", (map( "test: \(.name) [unexpected-value: \(.subject)]" ) | .[]), "count: \(length)/\($testSize)"] |
    join("\n") |
    error(.)
  end
;

