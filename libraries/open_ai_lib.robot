*** Settings ***
Library    OperatingSystem
Library    RequestsLibrary
Library    Collections

*** Variables ***
${OPENAI_BASE_URL}    https://api.openai.com/v1/chat/completions
${OPENAI_MODEL}       gpt-4o-mini
${OPENAI_TIMEOUT}     20

*** Keywords ***
Create OpenAI Session
    ${api_key}=    Get Environment Variable    OPENAI_API_KEY
    Run Keyword If    '${api_key}' == ''    Fail    OPENAI_API_KEY environment variable is not set
    Create Session    openai    ${OPENAI_BASE_URL}    headers={"Authorization":"Bearer ${api_key}", "Content-Type":"application/json"}

Ask OpenAI
    [Arguments]    ${prompt}    ${temperature}=0.0    ${max_tokens}=256
    Create OpenAI Session
    ${payload}=    Create Dictionary
    ...    model=${OPENAI_MODEL}
    ...    messages=${[{"role": "system", "content": "You are a QA automation assistant."}, {"role": "user", "content": "${prompt}"}]}
    ...    temperature=${temperature}
    ...    max_tokens=${max_tokens}
    ${resp}=    POST On Session    openai    ${EMPTY}    json=${payload}    timeout=${OPENAI_TIMEOUT}
    ${json}=    To Json    ${resp.content}
    ${text}=    Get From Dictionary    ${json["choices"][0]["message"]}    content
    RETURN   ${text}

Ask OpenAI With Image
    [Arguments]    ${prompt}    ${image_path}
    ${exists}=    Run Keyword And Return Status    File Should Exist    ${image_path}
    Run Keyword If    not ${exists}    Fail    Image not found: ${image_path}
    ${bytes}=    Get Binary File    ${image_path}
    ${b64}=      Evaluate    __import__('base64').b64encode(${bytes}).decode('utf-8')
    ${combined}=    Catenate    SEPARATOR=\n\n    ${prompt}    [IMAGE_BASE64]    ${b64}
    ${answer}=    Ask OpenAI    ${combined}
    RETURN    ${answer}

Validate Screenshot With OpenAI
    [Arguments]    ${image_path}    ${prompt}    ${must_contain}=${EMPTY}
    ${answer}=    Ask OpenAI With Image    ${prompt}    ${image_path}
    RETURN    ${answer}
