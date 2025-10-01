*** Settings ***
Documentation    30 heavy-duty ApiDemos mobile tests — pure page-objects, assertions, screenshots, gestures
Resource    ../../resources/keywords/mobile/mobile_keywords.robot
Resource    ../../resources/variables/mobile/apidemos_variables.robot
Library     AppiumLibrary

Test Setup       Launch ApiDemos Application 
Test Teardown    Restart ApiDemos Application 

*** Test Cases ***

01 Verify app title visible
    Verify Accessibility TextView

02 Open Accessibility and verify subitem
    Click Element    ${MENU_ACCESSIBILITY}
    Page Should Contain Text    ${TXT_ACCESSIBILITY_NODE_PROVIDER}

03 Open Access'ibility
    Click Element    ${MENU_ACCESS_APOSTR}
    Page Should Contain Text    ${TXT_ACCESSIBILITY_NODE_PROVIDER}

04 Open Animation and navigate back
    Click Element    ${MENU_ANIMATION}
    Page Should Contain Text    ${TXT_BOUNCING}
    Go Back
    Page Should Not Contain Text    ${TXT_BOUNCING}

05 Open App menu and assert presence
    Click Element    ${MENU_APP}
    Page Should Contain Text    ${TXT_ACTIVITY}

06 Open Content and assert contains expected text
    Click Element    ${MENU_CONTENT}
    Page Should Contain Text    ${TXT_ASSETS}

07 Open Graphics and check entry exists
    Click Element    ${MENU_GRAPHICS}
    Page Should Contain Text    ${TXT_ARCS}

08 Open Media and validate presence
    Click Element    ${MENU_MEDIA}
    Page Should Contain Text    ${TXT_AUDIO_FX}

09 Open Views, verify Buttons entry then back
    Click Element    ${MENU_VIEWS}
    Page Should Contain Text    ${TXT_BUTTONS}
    Go Back
    Page Should Not Contain Text    ${TXT_BUTTONS}

10 Scroll to NFC and assert visible
    Scroll To Text    ${TXT_NFC}
    Page Should Contain Text    ${TXT_NFC}

11 Scroll to OS and assert visible
    Scroll To Text    ${TXT_OS}
    Page Should Contain Text    ${TXT_OS}

12 Scroll to Preference and assert visible
    Scroll To Text    ${TXT_PREFERENCE}
    Page Should Contain Text    ${TXT_PREFERENCE}

13 Scroll to Text section and assert visible
    Scroll To Text    ${TXT_TEXT}
    Page Should Contain Text    ${TXT_TEXT}

14 Tap Accessibility element (click)
    Click Element    ${MENU_ACCESSIBILITY}
    Page Should Contain Text    ${TXT_ACCESSIBILITY_NODE_PROVIDER}
    Go Back

15 Long press Accessibility and capture evidence
    Tap    ${MENU_ACCESSIBILITY}    1500
    Capture ApiDemos Screenshot

16 Swipe the main list and ensure Views appears (gesture)
    Swipe By Percent    50    80    50    20    800
    Scroll To Text    ${TXT_VIEWS}
    Page Should Contain Text    ${TXT_VIEWS}

17 Verify accessibility element attributes (text & clickable)
    ${text}=    Get Element Attribute    ${MENU_ACCESSIBILITY}    text
    Should Be Equal    ${text}    ${TXT_ACCESSIBILITY}
    ${clickable}=    Get Element Attribute    ${MENU_ACCESSIBILITY}    clickable
    Should Be Equal    ${clickable}    true

18 Verify accessibility element is enabled & visible
    Element Should Be Enabled    ${MENU_ACCESSIBILITY}
    Element Should Be Visible    ${MENU_ACCESSIBILITY}

19 Negative: non-existent text must not be present
    Page Should Not Contain Text    ${TXT_NEGATIVE_NOT_EXIST}

20 Back navigation from nested screen returns to main
    Click Element    ${MENU_VIEWS}
    Click Element    ${MENU_ANIMATION}
    Go Back
    Go Back
    Verify Accessibility TextView

21 Background app and resume
    Background Application    2
    Verify Accessibility TextView

22 Verify main menu contains expected items (iterate variables)
    FOR    ${loc}    IN
    ...    ${MENU_ACCESS_APOSTR}
    ...    ${MENU_ACCESSIBILITY}
    ...    ${MENU_ANIMATION}
    ...    ${MENU_APP}
    ...    ${MENU_CONTENT}
    ...    ${MENU_GRAPHICS}
    ...    ${MENU_MEDIA}
    ...    ${MENU_NFC}
    ...    ${MENU_OS}
    ...    ${MENU_PREFERENCE}
    ...    ${MENU_TEXT}
    ...    ${MENU_VIEWS}
        Element Should Be Visible    ${loc}
    END

23 Capture visual evidence and use AI-placeholder (if configured)
    Capture ApiDemos Screenshot
    ${last}=    Capture Page Screenshot
    Log To Console    Screenshot saved: ${last}

24 Verify content-desc attribute for Access'ibility item
    ${desc}=    Get Element Attribute    ${MENU_ACCESS_APOSTR}    content-desc
    Should Contain    ${desc}    ${TXT_ACCESS_APOSTR_DESC}

25 Complex flow: open App → Alert Dialogs → confirm dialog text then back
    Scroll To Text    ${TXT_APP}
    Click Element    ${MENU_APP}
    Scroll To Text    ${TXT_ALERT_DIALOGS}
    Click Text    ${TXT_ALERT_DIALOGS}
    Page Should Contain Text    ${TXT_SELECT_A_COMMAND}
    Capture ApiDemos Screenshot
    Go Back
    Go Back
