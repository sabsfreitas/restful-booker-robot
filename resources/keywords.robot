*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
Authenticate as Admin
    ${body}=    Create Dictionary    username=admin    password=password123
    ${response}=    POST    url=https://restful-booker.herokuapp.com/auth    json=${body}
    Log    ${response.json()}
    ${token}=    Set Variable    ${response.json()}[token]
    Log    ${token}
    Set Suite Variable    ${token}