# EVOLVERE_PDSI  
# Instruções sobre o projeto:  
Configurações necessárias para rodar o projeto.    
# BACKEND  
Fora da pasta frontend e backend (alinhado com o .gitignore) crie o arquivo **.env** com informações sobre seu banco de dados  

```python
HOST=
USER=
PASSWORD=
DATABASE=
PORT=
SECRET=
```  

entre na pasta backend e crie a pasta chamada **uploads** dentro de public, caso a public não esteva criada, crie. **public/uploads**

```javascript
evolvere
    backend/
        controllers/
        database/
        middleware/
        migrations/
        models/
        public/
        routes/
        index.js
        knexfile.js
        package.json
    frontend/
    .env
    .gitignore
    readme.md
``` 

```javascript
npm install // para baixar as bibliotecas 
npm install --save-dev knex
``` 

## pegar as migrations  
```javascript
npx knex migrate:make nome_da_migration // nova migration
npx knex migrate:latest // pegar a migration atual
npx knex migrate:rollback // reverter a migration  
npx knex migrate:status // status 
```  

essa sequencia de comandos é para criar, excluir, pegar as atualizações e ver status do banco de dados  

e para rodar o backend use:  

```javascript
nodemon index.js
``` 

# FRONTEND  

dentro da pasta **frontend** crie o arquivo **.env** para adicionar seu endereço IP
```javascript
API_URL='http://seu_ip:8080'
``` 

```javascript
flutter pub get // para baixar as dependências de pubspec.yaml
``` 

## Estrutura de pastas

```javascript
frontend/
    android/
    assets/
    build/
    ios/
    lib/
        features/
            user/ TUDO RELACIONADO AO USUARIO
                components/ //componentes globais que vão ser usados em diversas telas
                themes/ //temas globais que vão ser usados em diversas telas
                widgets/ //widgets globais que vão ser usados em diversas telas
                register_user/ TELA DE CADASTRO DE USUARIO
                    components/ //componentes internos que vão ser usados apenas nessa tela
                    themes/ //temas internos que vão ser usados apenas nessa tela
                    widgets/ //widgets internos que vão ser usados apenas nessa tela
                login/ TELA DE LOGIN
                    components/ 
                    themes/ 
                    widgets/ 
            habits/ TUDO RELACIONADO AO HABITOS
            home/
            welcome/
            habits/
        main.dart
    linux/
    macos/
    web/
    windowns/
    .env
    analysis_options.yaml
    pubspec.yaml
    readme.md
``` 

para rodar o frontend

```javascript
flutter run
``` 


Flutter run key commands.

```javascript
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).
``` 


# GIT

para baixar o projeto

```python
git clone https://github.com/Josmateussilva0110/EVOLVERE_PDSI
``` 

entre em uma branch fora da main 

```python
git checkout -b nome_da_sua_branch
``` 

Commits semânticos
```javascript
feat: Adição de uma nova funcionalidade.

fix: Correção de um bug.

docs: Alterações na documentação.

style: Alterações de formatação (sem impactar lógica).

refactor: Refatoração de código (sem adicionar funcionalidade ou corrigir bugs).

test: Adição ou ajuste de testes.

chore: Tarefas de manutenção (ex.: atualizar dependências).
``` 

para fazer um commit e enviar para o repositório remoto 

```javascript
git add .
git commit -m "opção semântica: sua mensagem"
git push origin HEAD 
``` 

quando fazer o push vai abrir um link no terminal copia e cole no seu navegador, lá preencha as seguintes informações

* **titulo**
* **descrição**
* **revisor do pull request**
* **atribui a você a tarefa**
* **coloque a label**
* **repositorio do projeto**
* **milestone**  
* **status da tarefa**
* **data de inicio e fim da tarefa**

para pegar as atualizações da main **dentro de sua branch**

```javascript
git fetch origin
git rebase origin/main
``` 
caso ocorra algum conflito resolva e depois:

```javascript
git add .
git commit
``` 

