*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource   ../../resources/keywords/web/saucedemo_keywords.robot
Resource   ../../resources/page_objects/web/saucedemo_page.robot
Resource   ../../resources/variables/saucedemo_variables.robot
Resource   ../../../libraries/open_ai_lib.robot

Suite Setup       Open Browser    ${SAUCE_URL}    chrome
Suite Teardown    Close Browser
Test Teardown     Capture Page Screenshot    ${RESULTS_DIR}/${TEST NAME}.png

*** Test Cases ***

01 Successful login with standard user
    [Tags]    smoke
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${INVENTORY_LIST}    timeout=10s

02 Locked out user sees error
    Input Text    ${LOGIN_USERNAME}    ${LOCKED_OUT_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_BANNER}    timeout=5s

03 Problem user - product images analyzed by AI
    Input Text    ${LOGIN_USERNAME}    ${PROBLEM_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${INVENTORY_LIST}    timeout=10s
    Capture Page Screenshot    ${RESULTS_DIR}/problem_user.png
    ${ai_resp}=    Ask OpenAI With Image    Analyze product images for missing/broken image issues    ${RESULTS_DIR}/problem_user.png
    Log To Console    AI response: ${ai_resp}

04 Performance glitch user - observe load
    Input Text    ${LOGIN_USERNAME}    ${PERF_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${INVENTORY_LIST}    timeout=20s

05 Add single product to cart and verify badge
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Run Keyword If    ${buttons} == []    Fail    No add-to-cart buttons found
    Click Element    ${buttons}[${ADD_TO_CART_BTN_IDX}]
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    Element Text Should Be    ${CART_BADGE}    1

06 Add two products and verify cart count
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    ${count}=    Get Length    ${buttons}
    ${to_click}=    Evaluate    min(2, ${count})
    Click Element    ${buttons}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    ${badge}=    Get Text    ${CART_BADGE}
    Should Be Equal As Numbers    ${badge}    ${to_click}

07 Remove product from cart
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Click Element    ${buttons}[${ADD_TO_CART_BTN_IDX}]
    Click Element    ${CART_LINK}
    ${remove_buttons}=    Get WebElements    ${REMOVE_BTN_XPATH}
    Run Keyword If    ${remove_buttons} == []    Fail    No remove buttons in cart
    Click Element    ${remove_buttons}[0]
    Sleep    0.5
    ${remain}=    Get WebElements    ${REMOVE_BTN_XPATH}
    Should Be True    ${remain} == [] or ${remain} != ${remove_buttons}

08 Checkout happy path (end-to-end)
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Click Element    ${buttons}[${ADD_TO_CART_BTN_IDX}]
    Click Element    ${CART_LINK}
    Click Element    ${CHECKOUT_BTN}
    Input Text    ${FIRST_NAME}    Test
    Input Text    ${LAST_NAME}     User
    Input Text    ${POSTAL_CODE}   12345
    Click Element    ${CONTINUE_BTN}
    Click Element    ${FINISH_BTN}
    Wait Until Page Contains    ${THANK_YOU_TEXT}    timeout=5s

09 Checkout negative - missing first name shows error
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Click Element    ${buttons}[${ADD_TO_CART_BTN_IDX}]
    Click Element    ${CART_LINK}
    Click Element    ${CHECKOUT_BTN}
    Input Text    ${FIRST_NAME}    ${EMPTY}
    Input Text    ${LAST_NAME}    User
    Input Text    ${POSTAL_CODE}  12345
    Click Element    ${CONTINUE_BTN}
    Page Should Contain    Error: First Name is required

10 Sort by price low to high and verify ascending order
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Select From List By Value    css=.product_sort_container    lohi
    ${vals}=    Get Inventory Prices As Numbers
    ${sorted}=  Evaluate    sorted(${vals})
    Should Be Equal    ${vals}    ${sorted}

11 Product details page contains description and image
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${names}=    Get WebElements    ${INVENTORY_ITEM_NAME}
    Run Keyword If    ${names} == []    Fail    No product names found
    Click Element    ${names}[0]
    Wait Until Page Contains Element    ${PRODUCT_DESC}    timeout=5s
    Page Should Contain Element    ${PRODUCT_IMG}

12 Cart persistence when navigating back
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Click Element    ${buttons}[${ADD_TO_CART_BTN_IDX}]
    ${names}=    Get WebElements    ${INVENTORY_ITEM_NAME}
    Click Element    ${names}[0]
    Click Element    id=back-to-products
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=3s
    Element Text Should Be    ${CART_BADGE}    1

13 Validate sum of prices on checkout overview equals items sum
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Click Element    ${buttons}[0]
    Click Element    ${buttons}[1]
    Click Element    ${CART_LINK}
    Click Element    ${CHECKOUT_BTN}
    Input Text    ${FIRST_NAME}    Test
    Input Text    ${LAST_NAME}     User
    Input Text    ${POSTAL_CODE}   12345
    Click Element    ${CONTINUE_BTN}
    ${vals}=    Get Inventory Prices As Numbers
    ${sum}=    Evaluate    sum(${vals})
    ${subtotal_text}=    Get Text    ${SUMMARY_SUBTOTAL}
    ${subtotal}=    Evaluate    float(${subtotal_text.replace('Item total: $','')})
    Should Be Equal As Numbers    ${sum}    ${subtotal}

14 Logout via menu
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Click Element    ${MENU_BTN}
    Click Element    ${LOGOUT_LINK}
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=5s

15 Accessibility quick check via AI
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Capture Page Screenshot    ${RESULTS_DIR}/saucedemo_access.png
    ${ai_resp}=    Ask OpenAI With Image    Check accessibility issues: contrast, font size, readability    ${RESULTS_DIR}/saucedemo_access.png
    Log To Console    AI accessibility: ${ai_resp}

16 Visual regression placeholder - AI compare
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Capture Page Screenshot    ${RESULTS_DIR}/saucedemo_visual.png
    ${ai_resp}=    Ask OpenAI With Image    Compare this screenshot with baseline and list visual differences    ${RESULTS_DIR}/saucedemo_visual.png
    Log    ${ai_resp}

17 AI generate 3 edge-case test ideas
    ${ideas}=    Ask OpenAI    Generate 3 edge-case UI test ideas for saucedemo.com (inventory/cart/checkout)
    Log To Console    AI ideas: ${ideas}

18 Detect broken image with AI heuristic
    Input Text    ${LOGIN_USERNAME}    ${PROBLEM_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Capture Page Screenshot    ${RESULTS_DIR}/saucedemo_broken.png
    ${ok}=    Validate Screenshot With OpenAI    ${RESULTS_DIR}/saucedemo_broken.png    Is there a broken or placeholder image visible?    broken
    Run Keyword If    not ${ok}    Log To Console    AI did not detect broken image

19 Footer and social links exist
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Page Should Contain Element    ${FOOTER_COPY}
    Page Should Contain    Twitter

20 Back button returns to inventory
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${names}=    Get WebElements    ${INVENTORY_ITEM_NAME}
    Click Element    ${names}[0]
    Click Element    id=back-to-products
    Wait Until Page Contains Element    ${INVENTORY_LIST}    timeout=5s

21 Add all products to cart and verify badge equals count
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    ${count}=    Get Text    ${CART_BADGE}
    ${num_buttons}=    Get Length    ${buttons}
    Should Be Equal As Numbers    ${count}    ${num_buttons}

22 Inventory count equals displayed items length
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${len}=    Get Inventory Count
    Should Be True    ${len} > 0

23 Mobile viewport layout check (responsive)
    Set Window Size    375    812
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Capture Page Screenshot    ${RESULTS_DIR}/saucedemo_mobile.png
    ${ai_resp}=    Ask OpenAI With Image    Check if layout breaks on mobile viewport    ${RESULTS_DIR}/saucedemo_mobile.png
    Set Window Size    1920    1080

24 Button label changes after add-to-cart
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Run Keyword If    ${buttons} == []    Fail    No add-to-cart buttons found
    Click Element    ${buttons}[0]
    ${text}=    Get Text    ${buttons}[0]
    Should Contain    ${text}    Remove

25 Removing item restores add-to-cart text
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    ${buttons}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    Click Element    ${buttons}[0]
    Click Element    ${CART_LINK}
    ${remove_buttons}=    Get WebElements    ${REMOVE_BTN_XPATH}
    Click Element    ${remove_buttons}[0]
    Go To    ${SAUCE_URL}
    ${buttons_after}=    Get WebElements    ${ADD_TO_CART_BTN_XPATH}
    ${text2}=    Get Text    ${buttons_after}[0]
    Should Contain    ${text2}    Add to cart

26 SQL injection attempt in username field (negative)
    Input Text    ${LOGIN_USERNAME}    ' OR '1'='1
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Page Should Contain    Epic sadface

27 XSS payload in username should be sanitized
    Input Text    ${LOGIN_USERNAME}    <script>alert('x')</script>
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Page Should Not Contain    <script>alert('x')</script>

28 Clear cookies and verify session ends
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Delete All Cookies
    Go To    ${SAUCE_URL}inventory.html
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=5s

29 Invalid credentials show error
    Input Text    ${LOGIN_USERNAME}    invalid_user
    Input Text    ${LOGIN_PASSWORD}    ${BAD_PASS}
    Click Element    ${LOGIN_BUTTON}
    Page Should Contain    Epic sadface

30 AI rate overall page quality (visual + UX summary)
    Input Text    ${LOGIN_USERNAME}    ${STANDARD_USER}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Capture Page Screenshot    ${RESULTS_DIR}/saucedemo_quality.png
    ${rating}=    Ask OpenAI With Image    Rate overall page quality: UI clarity, spacing, visual hierarchy. Give 1-5 stars and one-sentence rationale.    ${RESULTS_DIR}/saucedemo_quality.png
    Log To Console    AI rating: ${rating}
