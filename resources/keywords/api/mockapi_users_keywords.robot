*** Settings ***
Library    RequestsLibrary
Library    FakerLibrary    locale=ru_RU
Library    Collections    # Для Append To List
Resource   ../resources/variables/mockapi_variables.robot    # Проверенный путь

*** Keywords ***
Create Session To MockAPI
    Create Session    mockapi    ${MOCKAPI_BASE_URL}

Generate Test Users
    [Arguments]    ${count}=3
    # Generate a list of user IDs for created users
    @{user_ids}=    Create List
    FOR    ${i}    IN RANGE    ${count}
        ${name}=    FakerLibrary.Name
        Log    Generated name: ${name}    # Для отладки
        ${user_data}=    Create Dictionary    name=${name}
        ${response}=    POST On Session    mockapi    ${USERS_ENDPOINT}    json=${user_data}    expected_status=201
        ${user_id}=    Set Variable    ${response.json()['id']}
        Append To List    ${user_ids}    ${user_id}
        Log    Current user_ids: ${user_ids}    # Для отладки
    END
    Set Suite Variable    @{GENERATED_USER_IDS}    @{user_ids}    # Обновляем глобальную переменную
    Log    Set suite variable GENERATED_USER_IDS: ${GENERATED_USER_IDS}    # Для отладки

Get User By ID
    [Arguments]    ${user_id}
    # Fetch user data by ID
    ${response}=    GET On Session    mockapi    ${USERS_ENDPOINT}/${user_id}    expected_status=200
    RETURN    ${response.json()}

Get User Name By ID
    [Arguments]    ${user_id}
    # Get user name from user data
    ${user_data}=    Get User By ID    ${user_id}
    RETURN    ${user_data['name']}

Validate User Data
    [Arguments]    ${user_id}    ${expected_name}
    # Validate that user data matches expected name
    ${user_data}=    Get User By ID    ${user_id}
    Should Be Equal As Strings    ${user_data['name']}    ${expected_name}

Delete User By ID
    [Arguments]    ${user_id}
    # Delete user by ID
    DELETE On Session    mockapi    ${USERS_ENDPOINT}/${user_id}    expected_status=200

Delete Generated Users
    # Delete all generated users
    Log    Deleting users with IDs: ${GENERATED_USER_IDS}    # Для отладки
    FOR    ${user_id}    IN    @{GENERATED_USER_IDS}
        Delete User By ID    ${user_id}
    END