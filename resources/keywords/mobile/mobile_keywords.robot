*** Settings ***
Documentation    Keywords for mobile automation with ApiDemos
Library    AppiumLibrary
Library    OperatingSystem
Resource    ../resources/page_objects/mobile/apidemos_locators.robot

*** Variables ***
${CAPS_FILE_PATH}    ${EXECDIR}\\android\\caps\\apidemos_caps.json

*** Keywords ***
Launch ApiDemos Application
    [Documentation]    Launches the ApiDemos application using defined capabilities
    ${caps}=    Get File    ${CAPS_FILE_PATH}
    ${caps_dict}=    Evaluate    json.loads('''${caps}''')    json
    Open Application    http://127.0.0.1:4724    &{caps_dict}

Terminate ApiDemos Application
    [Documentation]    Closes the ApiDemos application
    Close Application

Capture ApiDemos Screenshot
    [Documentation]    Captures a screenshot of the current ApiDemos screen with a timestamp
    ${timestamp}=    Get Time    epoch
    Capture Page Screenshot    screenshot_api_demos_${timestamp}.png

Verify Accessibility TextView
    [Documentation]    Verifies the visibility of the API Demos title
    Wait Until Page Contains Element    ${API_DEMOS_TITLE_SELECTOR}    10s