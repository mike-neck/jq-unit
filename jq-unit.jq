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

def Given(input):
  { name: .name, input: input }
;

def When(operation):
  . as $input |
  try
    { name: $input.name, subject: ($input.input | operation) }
  catch
    { name: $input.name, error: "\(.)" }
;

def Then(condition):
  satisfies(condition)
;

# argument: filter(boolean)
# input: TestSubject
# output: Test
def satisfies(conditionFilter):
  if .error == null then
    {
      name: .name,
      subject: .subject,
      test: (.subject | conditionFilter)
    }
  else
    {
      name: .name,
      subject: .error,
      test: false
    }
  end
;

