*** Settings ***
Resource    ../page_objects/wikipedia_home.robot
Library     SeleniumLibrary

*** Keywords ***
Open Wikipedia Language Page
    [Arguments]    ${lang}
    Log To Console    \n>>> Opening Wikipedia page in language: ${lang}
    Log              Opening Wikipedia page in language: ${lang}
    Click Element    ${LANG_LINKS}[${lang}]
    Wait Until Page Contains    ${LANG_HEADERS}[${lang}]    timeout=10s

Get Wikipedia Header Text
    [Arguments]    ${lang}
    ${expected}=    Set Variable    ${LANG_HEADERS}[${lang}]
    Log To Console    >>> Expected header for ${lang}: ${expected}
    Log              Expected header for ${lang}: ${expected}
    RETURN    ${expected}
