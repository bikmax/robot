*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/page_objects/web/wikipedia_home_page.robot

*** Keywords ***
Open Browser To Wikipedia
    Open Browser    ${WIKIPEDIA_URL}    chrome
    Maximize Browser Window
    Set Selenium Implicit Wait    3 seconds
    Log To Console    >>> Browser opened at ${WIKIPEDIA_URL}
    Log              Browser opened at ${WIKIPEDIA_URL}

Close Browser Session
    Close Browser
