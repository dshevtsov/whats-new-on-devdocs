Feature: Since
  In order to get updates since some date
  As a CLI
  I want to get valid formatted content

  Scenario: Basic
    When I run `whatsup_github since 'jun 10'`
    Then the output should contain "Searching on"
  
  Scenario: With no subcommand or argument
    When I run `whatsup_github`
    Then the output should contain "Searching on"


