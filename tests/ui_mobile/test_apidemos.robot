*** Settings ***
Documentation    Simple test to launch ApiDemos, verify API Demos title, and capture a screenshot
Resource    ../resources/keywords/mobile/mobile_keywords.robot
Library    AppiumLibrary

Suite Setup    Launch ApiDemos Application
Suite Teardown    Terminate ApiDemos Application

*** Test Cases ***
Verify ApiDemos Launch And Screenshot
    [Documentation]    Launches ApiDemos, verifies API Demos title, and saves a screenshot
    Verify Accessibility TextView
    # Page Should Contain Text    API Demos
    Capture ApiDemos Screenshot