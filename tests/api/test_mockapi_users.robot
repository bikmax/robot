*** Settings ***
Documentation    Verify MockAPI users endpoint with generated users, update, delete, and cleanup
Resource    ../resources/keywords/api/mockapi_users_keywords.robot
Resource    ../resources/variables/api/mockapi_variables.robot
Library     RequestsLibrary
Library     FakerLibrary    
Library     Collections    

Suite Setup       Create Session To MockAPI
Suite Teardown    Delete All Users

*** Variables ***
@{GENERATED_USER_IDS}    # List to store IDs of generated users

*** Test Cases ***
Verify MockAPI Users Operations
    Delete All Users
    Generate 20 Users
    Log Initial Users List
    Update Users With Surnames
    Log Updated Users List
    Delete 10 Users
    Log Remaining Users List
    Delete All Users
    Log Final Users List

*** Keywords ***
Generate 20 Users
    # Generate 20 users with unique first names
    @{user_ids}=    Create List
    FOR    ${i}    IN RANGE    20
        ${name}=    FakerLibrary.First Name    # Unique first name
        ${user_data}=    Create Dictionary    name=${name}
        ${response}=    POST On Session    mockapi    ${USERS_ENDPOINT}    json=${user_data}
        Log    POST response status: ${response.status_code}    # Debug log
        Log    POST response body: ${response.json()}          # Debug log
        Should Be Equal As Strings    ${response.status_code}    201    # Check API response
        ${user_id}=    Set Variable    ${response.json()['id']}
        Append To List    ${user_ids}    ${user_id}
    END
    Set Suite Variable    @{GENERATED_USER_IDS}    @{user_ids}
    Log    Generated 20 users with IDs: ${GENERATED_USER_IDS}

Log Initial Users List
    # Log the initial list of users
    ${response}=    GET On Session    mockapi    ${USERS_ENDPOINT}
    Should Be Equal As Strings    ${response.status_code}    200    # Check API response
    ${users}=    Set Variable    ${response.json()}
    Log    Initial users list: ${users}
    Should Be Equal As Numbers    ${users.__len__()}    20    

Update Users With Surnames
    # Update each user's name to "FirstName LastName" with unique surname
    FOR    ${user_id}    IN    @{GENERATED_USER_IDS}
        ${user_data}=    Get User By ID    ${user_id}
        ${first_name}=    Set Variable    ${user_data['name']}
        ${surname}=    FakerLibrary.Last Name    # Unique surname
        ${new_name}=    Set Variable    ${first_name} ${surname}
        ${update_data}=    Create Dictionary    name=${new_name}
        ${response}=    PUT On Session    mockapi    ${USERS_ENDPOINT}/${user_id}    json=${update_data}
        Should Be Equal As Strings    ${response.status_code}    200    # Check API response
        Log    Updated user ${user_id} to: ${new_name}
    END

Log Updated Users List
    # Log the updated list of users
    ${response}=    GET On Session    mockapi    ${USERS_ENDPOINT}
    Should Be Equal As Strings    ${response.status_code}    200    # Check API response
    ${users}=    Set Variable    ${response.json()}
    Log    Updated users list: ${users}
    Should Be Equal As Numbers    ${users.__len__()}    20    

Delete 10 Users
    # Delete the first 10 users from newly generated
    ${users_to_delete}=    Get Slice From List    ${GENERATED_USER_IDS}    0    10    # First 10 of 20 new users
    FOR    ${user_id}    IN    @{users_to_delete}
        ${response}=    DELETE On Session    mockapi    ${USERS_ENDPOINT}/${user_id}
        Should Be Equal As Strings    ${response.status_code}    200    # Check API response
        Log    Deleted user ${user_id}
    END
    # Update remaining IDs (last 10 of 20 new users)
    ${remaining_ids}=    Get Slice From List    ${GENERATED_USER_IDS}    10    20
    Set Suite Variable    @{GENERATED_USER_IDS}    @{remaining_ids}
    Log    Remaining user IDs: ${GENERATED_USER_IDS}

Log Remaining Users List
    # Log the list after deleting 10 users
    ${response}=    GET On Session    mockapi    ${USERS_ENDPOINT}
    Should Be Equal As Strings    ${response.status_code}    200    # Check API response
    ${users}=    Set Variable    ${response.json()}
    Log    Remaining users list: ${users}
    Should Be Equal As Numbers    ${users.__len__()}    10    

Delete All Users
    # Delete all remaining users (only the 10 new ones, existing 18 stay)
    FOR    ${user_id}    IN    @{GENERATED_USER_IDS}
        ${response}=    DELETE On Session    mockapi    ${USERS_ENDPOINT}/${user_id}
        Should Be Equal As Strings    ${response.status_code}    200    # Check API response
        Log    Deleted user ${user_id}
    END
    Set Suite Variable    @{GENERATED_USER_IDS}    @{EMPTY}
    Log    All new users deleted

Log Final Users List
    # Log the final list to confirm only existing users left
    ${response}=    GET On Session    mockapi    ${USERS_ENDPOINT}
    Should Be Equal As Strings    ${response.status_code}    200    # Check API response
    ${users}=    Set Variable    ${response.json()}
    Log    Final users list: ${users}
    Should Be Equal As Numbers    ${users.__len__()}    0    