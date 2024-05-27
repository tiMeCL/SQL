-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.


-- Crear la tabla
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

-- Insertar datos
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('admin@example.com', 'Admin', 'Istrador', 'administrador'),
('user1@example.com', 'Juan', 'Pérez', 'usuario'),
('user2@example.com', 'Ana', 'Gómez', 'usuario'),
('user3@example.com', 'Carlos', 'Ruiz', 'usuario'),
('user4@example.com', 'María', 'López', 'usuario');

-- Conectar a la base de datos
\c mi_base_de_datos;

-- Crear la tabla posts
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Insertar datos en la tabla posts
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Post 1 del Administrador', 'Contenido del post 1 del administrador.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, 1),
('Post 2 del Administrador', 'Contenido del post 2 del administrador.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 1),
('Post del Usuario 1', 'Contenido del post 1 del usuario.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, 2),
('Post del Usuario 2', 'Contenido del post 2 del usuario.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 3),
('Post Sin Usuario', 'Contenido del post sin usuario.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, NULL);

-- Crear la tabla comentarios
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Insertar datos en la tabla comentarios
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Comentario 1', CURRENT_TIMESTAMP, 1, 1),
('Comentario 2', CURRENT_TIMESTAMP, 2, 1),
('Comentario 3', CURRENT_TIMESTAMP, 3, 1),
('Comentario 4', CURRENT_TIMESTAMP, 1, 2),
('Comentario 5', CURRENT_TIMESTAMP, 2, 2);

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

SELECT 
    usuarios.nombre,
    usuarios.email,
    posts.titulo,
    posts.contenido
FROM 
    usuarios
JOIN 
    posts
ON 
    usuarios.id = posts.usuario_id;

-- 3.  Muestra el id, título y contenido de los posts de los administradores.

SELECT 
    posts.id,
    posts.titulo,
    posts.contenido
FROM 
    posts
JOIN 
    usuarios
ON 
    posts.usuario_id = usuarios.id
WHERE 
    usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario. 
-- a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

SELECT 
    usuarios.id,
    usuarios.email,
    COUNT(posts.id) AS cantidad_posts
FROM 
    usuarios
LEFT JOIN 
    posts
ON 
    usuarios.id = posts.usuario_id
GROUP BY 
    usuarios.id,
    usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts.
-- a. Aquí la tabla resultante tiene un único registro y muestra solo el email

SELECT 
    usuarios.email
FROM 
    usuarios
JOIN 
    posts
ON 
    usuarios.id = posts.usuario_id
GROUP BY 
    usuarios.email
ORDER BY 
    COUNT(posts.id) DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT 
    usuarios.id,
    usuarios.email,
    MAX(posts.fecha_creacion) AS ultima_fecha_post
FROM 
    usuarios
JOIN 
    posts
ON 
    usuarios.id = posts.usuario_id
GROUP BY 
    usuarios.id, usuarios.email;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT 
    p.titulo,
    p.contenido
FROM 
    posts p
JOIN 
    comentarios c
ON 
    p.id = c.post_id
GROUP BY 
    p.id, p.titulo, p.contenido
ORDER BY 
    COUNT(c.id) DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT 
    p.titulo,
    p.contenido AS post_contenido,
    c.contenido AS comentario_contenido,
    u.email
FROM 
    posts p
LEFT JOIN 
    comentarios c ON p.id = c.post_id
JOIN 
    usuarios u ON c.usuario_id = u.id
ORDER BY 
    p.titulo;

-- 9. Muestra el contenido del último comentario de cada usuario.

SELECT DISTINCT ON (u.id)
    u.email,
    c.contenido AS ultimo_comentario
FROM
    usuarios u
JOIN
    comentarios c ON u.id = c.usuario_id
ORDER BY
    u.id, c.fecha_creacion DESC;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT
    u.email
FROM
    usuarios u
LEFT JOIN
    comentarios c ON u.id = c.usuario_id
WHERE
    c.id IS NULL;











