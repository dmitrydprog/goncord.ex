# Goncord

## Оглавление
* [Правила поиска токена](#find_token)
* [Регистрация](#register)
* [Авторизация](#auth)
* [Выход](#logout)
* [Валидация](#validate)
* [Обновление](#update)
* [Обновление pyaloads](#update_payloads)
* [Добавление групп](#add_group)
* [Удаление групп](#del_group)
* [Смена пароля](#change_password)
* [Меню](#menu)

<a name="find_token"></a>
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
  * `login`
  * `password`
  * `email`
  * `first_name`
  * `last_name`
  * `second_name`
  * `birthday`
  * `roles (массив)` 

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
    "birthday": "1995-03-30",
    "roles": [
	{ "name": "rle1"},
	{ "name": "rle2"}
    ]
}
```

Пример ответа:
```json
{
    "second_name": "Евгеньевич",
    "roles": [
        {
            "name": "rle1"
        },
        {
            "name": "rle2"
        }
    ],
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
Для логина можно использовать `email` или `login`. Оба поля вместе указывать не обязательно.

Ссылка: `api/v0/tokens`

Метод: `post`

Формат: `json`

Параметры: 
  * `login`
  * `email`
  * `password`

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

<a name="validate"></a>
## Валидация

Ссылка: `api/v0/tokens/validate`

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

<a name="update"></a>
## Обновление
Для обновления пользователя:
1. В запросе должен присутствовать заголовок (`x-app-token`) с токеном приложения.
2. Приложения должно иметь статус `super`.

Ссылка: `api/v0/users`

Метод: `patch`

Параметры:
  * `second_name`
  * `last_name`
  * `first_name`
  * `birthday`

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
    "birthday": "1995-03-30"
}
```

Пример ответа:
```json
{
  "second_name": "Евгеньевич",
  "roles": [...],
  "login": "test",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "test@gmail.com",
  "birthday": "1995-03-30",
  "apps": {...}
}
```

Если у пользователя присутствуют ресурсы, как в примере ниже, а так же если текущий `x-app-token` принадлежит ресурсу с правами `super`, существует возможность обновлять поля `payload` других ресурсов.

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
---

<a name="update_payloads"></a>
## Обновление payloads
Запрос на данный url обновляет `payloads` ресурса по токену из заголовка.

Ссылка: `api/v0/resource/self_update`

Метод: `patch`

Параметры:
  JSON обьект payload

Пример запроса:
```json
PATCH /api/v0/resource/self_update HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjIiLCJleHAiOjE0OTI1MjAzMDIsImlhdCI6MTQ5MTMxMDcwMiwiaXNzIjoiR29uY29yZCIsImp0aSI6ImYzYmQyNTExLTU1ZGEtNGM5Mi04YjMzLTRjZTU0OTdjMmVjOSIsInBlbSI6e30sInN1YiI6IlVzZXI6MiIsInR5cCI6InRva2VuIn0.EnnrbEN7JMXl5Vw2smobGrb1o7eHVGa2P1-kT2FcLRgbExR09Mc_DFqjqoSST03M9XScnTW2M2Fp2Pvwwn4rog
Content-Type: application/json
x-app-token: 1d702c2f-0ed9-463d-bb9b-7772202eebe0
Cache-Control: no-cache

{
	"foo": "bar",
	"baz": 123
}
```

Пример ответа:
```json
{
  "second_name": "Евгеньевич1",
  "roles": [...],
  "login": "kylebyaka2",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "blablabla@gmail.com",
  "birthday": "1995-03-30",
  "apps": {
    "http://google.com": {
      "foo": "bar",
      "baz": 123
    }
  }
}
```

**Ресурс со статусом `super` имеет возможность обновлять `payloads` чужих ресурсов.**

Ссылка: `api/v0/resource/update`

Метод: `patch`

Параметры:
  JSON обьект состоящий из ключей (`url` ресурса) и значения (`payload` ресурса).
  Пример:
  
    ```json
    {
	"http://google.com": {
	    "new_foo": "new_bar"
	},
	"http://ya.ru": {
	    "ya-bar": "ya-foo",
	    "baz": {
	        "value": 123
	    }
        }
    }
    ```

Пример запроса:
```json
PATCH /api/v0/resource/update HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjIiLCJleHAiOjE0OTI1MjAzMDIsImlhdCI6MTQ5MTMxMDcwMiwiaXNzIjoiR29uY29yZCIsImp0aSI6ImYzYmQyNTExLTU1ZGEtNGM5Mi04YjMzLTRjZTU0OTdjMmVjOSIsInBlbSI6e30sInN1YiI6IlVzZXI6MiIsInR5cCI6InRva2VuIn0.EnnrbEN7JMXl5Vw2smobGrb1o7eHVGa2P1-kT2FcLRgbExR09Mc_DFqjqoSST03M9XScnTW2M2Fp2Pvwwn4rog
Content-Type: application/json
x-app-token: 1d702c2f-0ed9-463d-bb9b-7772202eebe0
Cache-Control: no-cache

{
	"http://google.com": {
		"new_foo": "new_bar"
	},
	"http://ya.ru": {
		"ya-bar": "ya-foo",
		"baz": {
			"value": 123
		}
	}
}
```

Пример ответа:
```json
{
  "second_name": "Евгеньевич1",
  "roles": [...],
  "login": "kylebyaka2",
  "last_name": "Дубина",
  "first_name": "Дмитрий",
  "email": "blablabla@gmail.com",
  "birthday": "1995-03-30",
  "apps": {
    "http://ya.ru": {
      "ya-bar": "ya-foo",
      "baz": {
        "value": 123
      }
    },
    "http://google.com": {
      "new_foo": "new_bar"
    }
  }
}
```

---

<a name="add_group"></a>
## Добавление групп

Ссылка: `api/v0/roles`

Метод: `post`

Параметры:
  * `roles (массив)`

Примеры запроса:
```json
POST /api/v0/roles HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjciLCJleHAiOjE0OTIxNzgyMzEsImlhdCI6MTQ5MDk2ODYzMSwiaXNzIjoiR29uY29yZCIsImp0aSI6IjBlZWVkOGIyLTVjMDgtNDRjNi1hZGIxLWQxMzgxYTcwNmZiYiIsInBlbSI6e30sInN1YiI6IlVzZXI6NyIsInR5cCI6InRva2VuIn0.HCnHryDC8aGt4Ajtf2ZWgHjiCHmZQdA3RqLyDCUCXIcNu7ECi15QOVj1vAhgRCadpp5FfzlRpBdTqf2Nb0mblQ
Content-Type: application/json
x-app-token: 38181955-c43d-411b-ad85-26cfb1a79a36
Cache-Control: no-cache

{
	"roles": ["admin", "student", "teacher"]
}
```

Пример ответа:
```json
[
  {
    "name": "admin"
  },
  {
    "name": "student"
  },
  {
    "name": "teacher"
  }
]
```

---

<a name="del_group"></a>
## Удаление групп

Ссылка: `api/v0/roles`

Метод: `delete`

Параметры:
  * `roles (массив)`

Примеры запроса:
```json
POST /api/v0/roles HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjciLCJleHAiOjE0OTIxNzgyMzEsImlhdCI6MTQ5MDk2ODYzMSwiaXNzIjoiR29uY29yZCIsImp0aSI6IjBlZWVkOGIyLTVjMDgtNDRjNi1hZGIxLWQxMzgxYTcwNmZiYiIsInBlbSI6e30sInN1YiI6IlVzZXI6NyIsInR5cCI6InRva2VuIn0.HCnHryDC8aGt4Ajtf2ZWgHjiCHmZQdA3RqLyDCUCXIcNu7ECi15QOVj1vAhgRCadpp5FfzlRpBdTqf2Nb0mblQ
Content-Type: application/json
x-app-token: 38181955-c43d-411b-ad85-26cfb1a79a36
Cache-Control: no-cache

{
	"roles": ["admin"]
}
```

---

<a name="logout"></a>
## Выход

Ссылка: `api/v0/tokens`

Метод: `delete`

Пример запроса:
```json
DELETE /api/v0/tokens HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDYyMzYsImlhdCI6MTQ5MDc5NjYzNiwiaXNzIjoiR29uY29yZCIsImp0aSI6IjU2NzM2ZWFiLTE1OTQtNDI0YS1iMWNkLWM0M2ZmYTBmNmZhYSIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.G9Qeqrh4pmfghBrqGBRzUIMN7lyUXeOR--LBijBfbdfYmHoforv6i4Vi3U8ZFEYxX2a6q5vFBtJqVp5rSbzsqw
Cache-Control: no-cache
```

Вместо ответа возвращается статус 204, что свидетельствует об успешном выходе из аккаунта.

---

<a name="change_password"></a>
## Смена пароля

Ссылка: `api/v0/users/change_password`

Метод: `post`

Формат: `json`

Параметры: 
  * `old_password`
  * `new_password`

Пример запроса:
```json
POST /api/v0/users/change_password HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjQiLCJleHAiOjE0OTIwMDk3NTQsImlhdCI6MTQ5MDgwMDE1NCwiaXNzIjoiR29uY29yZCIsImp0aSI6IjNiMWVmMDBkLTc3ZTctNDY5Yi1hOThkLTE4NmQ5YjljN2VjNCIsInBlbSI6e30sInN1YiI6IlVzZXI6NCIsInR5cCI6InRva2VuIn0.lOb7HsF7zq_Q1VXVoLIQD4H0s2I4cnMmglKJkF0MN80DrnG-yaDX6Cv1MnSoS-bxjyCb7vxG4HuFlLn0NZaz6w
Content-Type: application/json
Cache-Control: no-cache

{
    "old_password": "password",
    "new_password": "new_password"
}
```

Вместо ответа возвращается статус 200, что свидетельствует об успешной смене пароля.

---

<a name="menu"></a>
## Меню

Ссылка: `api/v0/menu`

Метод: `get`

Пример запроса:
```json
GET /api/v0/menu HTTP/1.1
Host: localhost:4000
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjEiLCJleHAiOjE0OTIwMDM3MzMsImlhdCI6MTQ5MDc5NDEzMywiaXNzIjoiR29uY29yZCIsImp0aSI6ImM0YmU0OGIwLTRlMzAtNDQzNC1hYzZlLTk3ODg2YzRiMGU1NSIsInBlbSI6e30sInN1YiI6IlVzZXI6MSIsInR5cCI6InRva2VuIn0._WVYRrKGopTEW-p_F6nQAnA-wygu8vNrVxNisgeekcBlVmrjwqqxAZrScPjGnObENz1-Aj_pBlhSYa8uV6CHzA
Cache-Control: no-cache
```

Пример ответа:
```json
[
  {
    "url": "http://google.com",
    "name": "admin"
  }
]
```
