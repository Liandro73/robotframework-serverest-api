*** Settings ***
Resource    ../resources/users.resource

*** Variables ***


*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na API ServeRest
    Criar um novo usuário
    Cadastrar o usuário na ServeRest                        ${EMAIL_TEST}    201
    Conferir se o usuário foi cadastrado corretamente

Cenário 02: Cadastrar usuário existente
    Criar um novo usuário
    Cadastrar o usuário na ServeRest                        ${EMAIL_TEST}    201
    Vou repetir o cadastro com mesmo email
    Verificar se foi exibida mensagem de erro "Este email já está sendo usado" pela API

Cenário 03: Consultar dados de usuário cadastrado
    Criar um novo usuário
    Cadastrar o usuário na ServeRest                        ${EMAIL_TEST}    201
    Consultar os dados do novo usuário
    Conferir dados retornados
     