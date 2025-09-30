*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource   ../../page_objects/web/saucedemo_page.robot
Resource   ../resources/variables/saucedemo_variables.robot
Resource   ../../../libraries/open_ai_lib.robot

*** Keywords ***
Open Browser To Sauce
    [Documentation]    Open browser and navigate to SauceDemo
    Open Browser    ${SAUCE_URL}    chrome
    Maximize Browser Window
    Set Selenium Implicit Wait    3 seconds
    Log    Browser opened at ${SAUCE_URL}

Close Browser Session
    [Documentation]    Close browser cleanly
    Run Keyword And Ignore Error    Capture Page Screenshot    ${RESULTS_DIR}/last_screenshot.png
    Close Browser

Login As
    [Arguments]    ${user}    ${password}=${PASSWORD}
    Input Text    ${LOGIN_USERNAME}    ${user}
    Input Text    ${LOGIN_PASSWORD}    ${password}
    Click Element  ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${INVENTORY_LIST}    timeout=10s

Login Expecting Error
    [Arguments]    ${user}    ${password}=${PASSWORD}
    Input Text    ${LOGIN_USERNAME}    ${user}
    Input Text    ${LOGIN_PASSWORD}    ${password}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_BANNER}    timeout=5s

Add First Product To Cart
    [Documentation]    Click first add-to-cart button on inventory page 
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Run Keyword If    ${buttons} == []    Fail    No add-to-cart buttons found on page
    Click Element    ${buttons}[0]
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=3s

Add N Products To Cart
    [Arguments]    ${n}=2
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    ${count}=      Get Length         ${buttons}
    ${to_click}=   Evaluate           min(${n}, ${count})
    Click Element    ${buttons}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=3s

Go To Product Details By Index
    [Arguments]    ${index}=1
    ${names}=    Get WebElements    ${INVENTORY_ITEM_NAME}
    Run Keyword If    ${names} == []    Fail    No product names found on inventory
    Click Element    ${names}[${index - 1}]
    Wait Until Page Contains Element    ${PRODUCT_DESC}    timeout=5s

Open Cart
    Click Element    ${CART_LINK}
    Wait Until Page Contains Element    ${CONTINUE_BTN}    timeout=5s

Checkout With Info
    [Arguments]    ${first}=Test    ${last}=User    ${zip}=12345
    Click Element    ${CHECKOUT_BTN}
    Input Text     ${FIRST_NAME}    ${first}
    Input Text     ${LAST_NAME}     ${last}
    Input Text     ${POSTAL_CODE}   ${zip}
    Click Element    ${CONTINUE_BTN}

Finish Checkout
    Click Element    ${FINISH_BTN}
    Wait Until Page Contains    ${THANK_YOU_TEXT}    timeout=5s

Get Inventory Prices As Numbers
    ${els}=    Get WebElements    ${INVENTORY_ITEM_PRICE}
    ${vals}=   Create List
    FOR    ${el}    IN    @{els}
        ${txt}=    Get Text    ${el}
        ${num}=    Evaluate    float(${txt.replace('$','')})
        Append To List    ${vals}    ${num}
    END
    RETURN    ${vals}

Get Inventory Count
    @{items}=    Get WebElements    ${INVENTORY_ITEMS}
    ${len}=      Get Length    ${items}
    RETURN   ${len}

Logout From App
    Click Element    ${MENU_BTN}
    Click Element    ${LOGOUT_LINK}
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=5s

# AI-related wrappers 
AI Ask About Page
    [Arguments]    ${prompt}
    ${resp}=    Ask OpenAI    ${prompt}
    Log To Console    >>> AI: ${resp}
    RETURN   ${resp}

AI Ask About Screenshot
    [Arguments]    ${prompt}    ${path}
    ${resp}=    Ask OpenAI With Image    ${prompt}    ${path}
    Log To Console    >>> AI: ${resp}
    RETURN    ${resp}

AI Validate Screenshot Contains
    [Arguments]    ${path}    ${prompt}    ${must}
    ${ok}=    Validate Screenshot With OpenAI    ${path}    ${prompt}    ${must}
    Run Keyword If    not ${ok}    Fail    AI validation failed (must contain ${must})
    RETURN    ${ok}
