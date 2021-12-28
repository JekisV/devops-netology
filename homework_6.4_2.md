_Для уникальности можно добавить индекс или первичный ключ:_  
`CREATE INDEX ON orders ((lower(title)));`  
_Так конечно можно, но это фича постгреса, а как сделать по стандарту sql?
Чтобы совместимо было везде:_  

Можно добавить UNIQUE при создании таблицы на title:  
```commandline
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE,
    price integer DEFAULT 0
);
```