Feature: Service Double

  Scenario: Remembering something
    When I ask the fake server to remember "the fifth of November"
    Then the fake server remembered to "the fifth of November"

  Scenario: Forgetting everything between scenarios
    When I am in a new scenario 
    Then the fake server should remember nothing from the previous scenario
