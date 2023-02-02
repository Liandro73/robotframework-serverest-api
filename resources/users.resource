*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

*** Keywords ***
Criando sessão na API ServeRest
    ${HEADERS}                        Create Dictionary
    ...                               accept=application/json
    ...                               Content-Type=application/json
    Create Session                    alias=ServeRest    url=https://serverest.dev    headers=${HEADERS}

Criar um novo usuário
    ${RANDOM_STRING}                  Generate Random String    length=7    chars=[LETTERS]
    ${RANDOM_STRING}                  Convert To Lower Case     ${RANDOM_STRING}
    Set Test Variable                 ${EMAIL_TEST}             ${RANDOM_STRING}@emailteste.com
    Log                               ${EMAIL_TEST}

Cadastrar o usuário criado na ServeRest
    ${BODY}                           Create Dictionary
    ...                               nome=Testing Porter
    ...                               email=${EMAIL_TEST}
    ...                               password=teste
    ...                               administrador=true

    Criando sessão na API ServeRest

    ${RESPONSE}                       POST On Session
    ...                               alias=ServeRest
    ...                               url=/usuarios
    ...                               json=${BODY}
    
    Set Test Variable                 ${REPOSTA}    ${RESPONSE.json()}

Conferir se o usuário foi cadastrado corretamente
    Log                               ${REPOSTA}
    Dictionary Should Contain Item    ${REPOSTA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${REPOSTA}    _id