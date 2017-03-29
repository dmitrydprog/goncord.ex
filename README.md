# Goncord

## Оглавление
[Регистрация](#register)

## Правила поиска токена
Проверяется заголовок `Authorization` запроса:
   * Если заголовок присутствует, то jwt cookie не учитывается.
   * Если заголовок отсутствует, то на его место подставляется значение из cookie `jwt`.

---

<a name="register"></a>
## Регистрация

Ссылка: `api/v0/users`

Метод: `post`

Формат: `json`

Параметры: 
  * login 
  * password 
  * email 
  * first_name 
  * last_name 
  * second_name 
  * birthday

Пример запроса:
```json
POST /api/v0/users HTTP/1.1
Host: localhost:4000
Content-Type: application/json
Cache-Control: no-cache

{
    "login": "test",
    "password": "password",
    "email": "test@gmail.com",
    "first_name": "Дмитрий",
    "last_name": "Дубина",
    "second_name": "Евгеньевич",
    "birthday": "1995-03-30"
}
```

Пример ответа:
```json
{
    "second_name": "Евгеньевич",
    "roles": [],
    "login": "test",
    "last_name": "Дубина",
    "first_name": "Дмитрий",
    "email": "test@gmail.com",
    "birthday": "1995-03-30",
    "apps": {}
}
```

---

<a name="auth"></a>
## Авторизация
Для логина можно использовать `email` или `login`. Оба поля в раз не обязательны

Ссылка: `api/v0/tokens`

Метод: `post`

Формат: `json`

Параметры: 
  * login
  * email
  * password

Пример запроса:
```json
POST /api/v0/tokens HTTP/1.1
Host: localhost:4000
Content-Type: application/json
Cache-Control: no-cache

{
    "email": "test@gmail.com",
    "password": "password"
}
```

Пример ответа:
```json
{
  "user": {
    "second_name": "Евгеньевич",
    "roles": [],
    "login": "test",
    "last_name": "Дубина",
    "first_name": "Дмитрий",
    "email": "test@gmail.com",
    "birthday": "1995-03-30",
    "apps": {}
  },
  "jwt": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDYyMzYsImlhdCI6MTQ5MDc5NjYzNiwiaXNzIjoiR29uY29yZCIsImp0aSI6IjU2NzM2ZWFiLTE1OTQtNDI0YS1iMWNkLWM0M2ZmYTBmNmZhYSIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.G9Qeqrh4pmfghBrqGBRzUIMN7lyUXeOR--LBijBfbdfYmHoforv6i4Vi3U8ZFEYxX2a6q5vFBtJqVp5rSbzsqw"
}
```

---

## Валидация

Ссылка: `v0/tokens/validate`

Метод: `get`

Пример запроса с токеном в заголовке:
```json
GET /api/v0/tokens/validate HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDYyMzYsImlhdCI6MTQ5MDc5NjYzNiwiaXNzIjoiR29uY29yZCIsImp0aSI6IjU2NzM2ZWFiLTE1OTQtNDI0YS1iMWNkLWM0M2ZmYTBmNmZhYSIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.G9Qeqrh4pmfghBrqGBRzUIMN7lyUXeOR--LBijBfbdfYmHoforv6i4Vi3U8ZFEYxX2a6q5vFBtJqVp5rSbzsqw
Cache-Control: no-cache
```

Пример запроса с токеном в куках:
```json
GET /api/v0/tokens/validate HTTP/1.1
Host: localhost:4000
Cookie: jwt=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDYyMzYsImlhdCI6MTQ5MDc5NjYzNiwiaXNzIjoiR29uY29yZCIsImp0aSI6IjU2NzM2ZWFiLTE1OTQtNDI0YS1iMWNkLWM0M2ZmYTBmNmZhYSIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.G9Qeqrh4pmfghBrqGBRzUIMN7lyUXeOR--LBijBfbdfYmHoforv6i4Vi3U8ZFEYxX2a6q5vFBtJqVp5rSbzsqw
Cache-Control: no-cache
```

Пример ответа:
```json
{
  "second_name": "Евгеньевич",
  "roles": [],
  "login": "test",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "test@gmail.com",
  "birthday": "1995-03-30",
  "apps": {}
}
```

---

## Обновление
Для обновления пользователя:
1. В запросе должен присутствовать заголовок (`x-app-token`) с токеном приложения.
2. Приложения должно иметь статус `super`.

Ссылка: api/v0/users

Метод: `patch`

Параметры:
  * second_name
  * last_name
  * first_name
  * birthday
  * roles (массив)
  * apps (словарь)

При обновление массива ролей (`roles`), можно добавлять любые роли. Если роли не были найдены в БД, они будут созданы.

Пример запроса:
```json
PATCH /api/v0/users HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDYyMzYsImlhdCI6MTQ5MDc5NjYzNiwiaXNzIjoiR29uY29yZCIsImp0aSI6IjU2NzM2ZWFiLTE1OTQtNDI0YS1iMWNkLWM0M2ZmYTBmNmZhYSIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.G9Qeqrh4pmfghBrqGBRzUIMN7lyUXeOR--LBijBfbdfYmHoforv6i4Vi3U8ZFEYxX2a6q5vFBtJqVp5rSbzsqw
Content-Type: application/json
x-app-token: 3333cd49-ee9e-4ece-aa4f-345d236a7416
Cache-Control: no-cache

{
    "second_name": "Евгеньевич",
    "last_name": "Дубина",
    "first_name": "Дмитрий",
    "birthday": "1995-03-30",
    "roles": [
        "teacher",
        "admin"
    ],
    "apps": {
    }
}
```

Пример ответа:
```json
{
  "second_name": "Евгеньевич",
  "roles": [
      "teacher",
      "admin"
  ],
  "login": "test",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "test@gmail.com",
  "birthday": "1995-03-30",
  "apps": {}
}
```

Если у пользователя присутствуют ресурсы, как в примере ниже, а так же если текущий `x-app-token` принадлежит ресурсурсу с правами `super`, существует возможность обновлять поля `payload` других ресурсов.

Текущая модель пользователя:
```json
{
  "second_name": "Евгеньевич",
  "roles": [],
  "login": "test",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "test@gmail.com",
  "birthday": "1995-03-30",
  "apps": {
    "http://google.com": {},
    "http://dissw.ru": {}
  }
}
```

Пример запроса на обновление payload ресурса `http://dissw.ru`:
```json
PATCH /api/v0/users HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDYyMzYsImlhdCI6MTQ5MDc5NjYzNiwiaXNzIjoiR29uY29yZCIsImp0aSI6IjU2NzM2ZWFiLTE1OTQtNDI0YS1iMWNkLWM0M2ZmYTBmNmZhYSIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.G9Qeqrh4pmfghBrqGBRzUIMN7lyUXeOR--LBijBfbdfYmHoforv6i4Vi3U8ZFEYxX2a6q5vFBtJqVp5rSbzsqw
Content-Type: application/json
x-app-token: 3333cd49-ee9e-4ece-aa4f-345d236a7416
Cache-Control: no-cache
{
    "second_name": "Евгеньевич",
    "last_name": "Дубина",
    "first_name": "Дмитрий",
    "birthday": "1995-03-30",
    "roles": [
    ],
    "apps": {
        "http://google.com": {
        },
        "http://dissw.ru": {
            "secret_field": {
                "foo": "bar",
                "baz": 2017
            }
        }
    }
}
```

Пример ответа:
```json
{
  "second_name": "Евгеньевич",
  "roles": [],
  "login": "test",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "test@gmail.com",
  "birthday": "1995-03-30",
  "apps": {
    "http://google.com": {},
    "http://dissw.ru": {
      "secret_field": {
        "foo": "bar",
        "baz": 2017
      }
    }
  }
}
```
