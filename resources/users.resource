*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

*** Keywords ***
Criando sessão na API ServeRest
    ${HEADERS}                          Create Dictionary
    ...                                 accept=application/json
    ...                                 Content-Type=application/json
    Create Session                      alias=ServeRest    url=https://serverest.dev    headers=${HEADERS}

Criar um novo usuário
    ${RANDOM_STRING}                    Generate Random String    length=7    chars=[LETTERS]
    ${RANDOM_STRING}                    Convert To Lower Case     ${RANDOM_STRING}
    Set Test Variable                   ${EMAIL_TEST}             ${RANDOM_STRING}@emailteste.com
    Log                                 ${EMAIL_TEST}

Cadastrar o usuário na ServeRest    
    [Arguments]                         ${email}
    ...                                 ${status}
    ${BODY}                             Create Dictionary
    ...                                 nome=Testing Porter
    ...                                 email=${EMAIL_TEST}
    ...                                 password=teste
    ...                                 administrador=true

    Criando sessão na API ServeRest
    ${RESPONSE}                         POST On Session
    ...                                 alias=ServeRest
    ...                                 url=/usuarios
    ...                                 json=${BODY}
    ...                                 expected_status=${status}
    
    IF    ${RESPONSE.status_code} == 201
        Set Test Variable                   ${USER_ID}    ${RESPONSE.json()["_id"]}
    END
    Set Test Variable                   ${REPOSTA}    ${RESPONSE.json()}

Conferir se o usuário foi cadastrado corretamente
    Log                                 ${REPOSTA}
    Dictionary Should Contain Item      ${REPOSTA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key       ${REPOSTA}    _id

Vou repetir o cadastro com mesmo email
    Cadastrar o usuário na ServeRest    ${EMAIL_TEST}    400

Verificar se foi exibida mensagem de erro "${MESSAGE_ERRO_REGISTERED_USER}" pela API
    Dictionary Should Contain Item      ${REPOSTA}    message    ${MESSAGE_ERRO_REGISTERED_USER}

Consultar os dados do novo usuário
    ${RESPONSE}                         GET On Session
    ...                                 alias=ServeRest
    ...                                 url=/usuarios/${USER_ID}
    ...                                 expected_status=200
    
    Set Test Variable                   ${GET_RESPONSE}    ${RESPONSE.json()}

Conferir dados retornados
    Dictionary Should Contain Item    ${GET_RESPONSE}    nome               Testing Porter
    Dictionary Should Contain Item    ${GET_RESPONSE}    email              ${EMAIL_TEST}
    Dictionary Should Contain Item    ${GET_RESPONSE}    password           teste
    Dictionary Should Contain Item    ${GET_RESPONSE}    administrador      true
    Dictionary Should Contain Item    ${GET_RESPONSE}    _id                ${USER_ID}