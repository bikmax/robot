*** Settings ***
Documentation    Keywords for mobile automation with ApiDemos
Library    AppiumLibrary
Library    OperatingSystem
Resource    ../resources/page_objects/mobile/apidemos_locators.robot

*** Variables ***
${CAPS_FILE_PATH}    ${EXECDIR}${/}android${/}caps${/}apidemos_caps.json

*** Keywords ***
Launch ApiDemos Application
    [Documentation]    Launches the ApiDemos application using defined capabilities
    ${caps}=    Get File    ${CAPS_FILE_PATH}
    ${caps_dict}=    Evaluate    json.loads('''${caps}''')    json
    Open Application    http://127.0.0.1:4724    &{caps_dict}

Restart ApiDemos Application
    [Documentation]    Force close and relaunch ApiDemos app with fresh session
    Capture ApiDemos Screenshot
    Run Keyword And Ignore Error    Close Application

Capture ApiDemos Screenshot
    [Documentation]    Captures a screenshot of the current ApiDemos screen with a timestamp
    ${timestamp}=    Get Time    epoch
    Capture Page Screenshot    screenshot_api_demos_${timestamp}.png

Verify Accessibility TextView
    [Documentation]    Verifies the visibility of the API Demos title
    Wait Until Page Contains Element    ${API_DEMOS_TITLE_SELECTOR}    10s

Click Menu Item
    [Arguments]    ${locator}
    [Documentation]    Clicks on a given menu item using locator from page_objects
    Wait Until Page Contains Element    ${locator}    10s
    Click Element    ${locator}

Verify Page Contains Text
    [Arguments]    ${text}
    [Documentation]    Verifies that the page contains the given text
    Wait Until Page Contains    ${text}    10s

Scroll To Text
    [Arguments]    ${text}
    [Documentation]    Scrolls until the specified text is visible
    ${found}=    Run Keyword And Return Status    Page Should Contain Text    ${text}
    WHILE    '${found}' == 'False'
        Swipe By Percent    50    80    50    20    800
        ${found}=    Run Keyword And Return Status    Page Should Contain Text    ${text}
    END

