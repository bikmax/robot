*** Settings ***
Documentation    Verify Wikipedia loads correctly in multiple languages
Resource    ../resources/keywords/web/browser_keywords.robot
Resource    ../resources/keywords/web/wikipedia_keywords.robot

Suite Setup       Open Browser To Wikipedia
Suite Teardown    Close Browser Session

*** Test Cases ***
Verify Wikipedia Languages
    [Template]    Validate Wikipedia Language
    en
    fr
    ru

*** Keywords ***
Validate Wikipedia Language
    [Arguments]    ${lang}
    Run Keyword And Continue On Failure    Go To    ${WIKIPEDIA_URL}
    Run Keyword And Continue On Failure    Open Wikipedia Language Page    ${lang}
    ${expected}=    Get Wikipedia Header Text    ${lang}
    Run Keyword And Continue On Failure    Page Should Contain    ${expected}
    Capture Page Screenshot
    Run Keyword And Continue On Failure    Go To    ${WIKIPEDIA_URL}

