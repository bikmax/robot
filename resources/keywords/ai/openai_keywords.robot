*** Settings ***
Resource    ../../../libraries/open_ai_lib.robot


*** Keywords ***
Ask OpenAI About Wikipedia
    [Arguments]    ${lang}
    ${question}=    Set Variable    What is the greeting text for Wikipedia in ${lang} language?
    ${answer}=      Ask OpenAI    ${question}
    Log To Console  \n>>> OpenAI answered: ${answer}
    RETURN          ${answer}

Ask OpenAI With Screenshot
    [Arguments]    ${screenshot_path}    ${prompt}
    ${answer}=    Ask OpenAI With Image    ${prompt}    ${screenshot_path}
    Log To Console  \n>>> OpenAI answered: ${answer}
    RETURN    ${answer}

Validate Screenshot With OpenAI
    [Arguments]    ${screenshot_path}    ${prompt}    ${must_contain}=${EMPTY}
    ${result}=    Validate Screenshot With OpenAI    ${screenshot_path}    ${prompt}    ${must_contain}
    Log To Console    >>> AI validation result: ${result}
    RETURN    ${result}
