alter session set "_ORACLE_SCRIPT"=true;  
/
create or replace PROCEDURE DELETE_USER (p_name in varchar2) as
BEGIN
DELETE FROM users WHERE name = p_name;-
EXECUTE IMfilmTE ('drop user '||p_name||' cascade');
commit;
END;
/
--creating procedure for updating user info
create or replace PROCEDURE UPDATE_USER (user_id number ,p_name in varchar2, p_email in varchar2, p_password in varchar2 , p_birthdate in DATE,p_image BLOB) as
im_id number;
BEGIN
SELECT image_id INTO im_id from users where id = user_id;
UPDATE image SET image = p_image where id = im_id;
UPDATE users SET email = p_email, password = p_password, birthdate = p_birthdate, name = P_NAME where id = user_id;
COMMIT;
END;
/
--creating fonction for getting user info by id
create or replace function get_user (user_id number) return sys_refcursor as
user_cursor sys_refcursor;
BEGIN
OPEN user_cursor FOR SELECT * FROM users where id = user_id;
RETURN user_cursor;
END;
/
--creating fonction for getting if user id exist in admin table
create or replace function check_admin (user_id number) return number as
admin_id number;
BEGIN
SELECT id INTO admin_id from admin where users_id = user_id;
if admin_id is null then
return 0;
else
return 1;
end if;
END;
/
--creating fonction for getting film based on genre 
create or replace function get_film_genre (genre_id number) return sys_refcursor as
film_cursor sys_refcursor;
BEGIN
OPEN film_cursor FOR SELECT * FROM Film where genre_id = genre_id;
RETURN film_cursor;
END;
/
--creating fonction for getting serie based on genre
create or replace function get_serie_genre (genre_id number) return sys_refcursor as
serie_cursor sys_refcursor;
BEGIN
OPEN serie_cursor FOR SELECT * FROM Serie where genre_id = genre_id;
RETURN serie_cursor;
END;
/

--creating fonction for getting media based on name
create or replace function get_media_name (media_name varchar2) return sys_refcursor as
media_cursor sys_refcursor;
BEGIN
open media_cursor select * from media where name = media_name;
RETURN media_cursor;
END;

/
--creating fonction for searching media by actor
create or replace function get_media_actor (actor_name varchar2) return sys_refcursor as
actors_id number;
media_id sys_refcursor;
BEGIN
select id into actors_id from actor where name = actor_name;
open media_id for select media_id from ROLE where actor_id = actors_id;
return media_id;
END;
/
--creating fonction for searching media by id
create or replace function get_media_id (media_id number) return sys_refcursor as
media_cursor sys_refcursor;
BEGIN
OPEN media_cursor FOR SELECT * FROM MEDIA where id = i.media_id;
RETURN media_cursor;
END;
/

--creating fonction for getting film by media id
create or replace function get_film (medias_id number) return sys_refcursor as
film_cursor sys_refcursor;
BEGIN
OPEN film_cursor FOR SELECT * FROM Film where media_id = medias_id;
RETURN film_cursor;
END;
/
--creating fonction for getting serie by media id
create or replace function get_serie (medias_id number) return sys_refcursor as
serie_cursor sys_refcursor;
BEGIN
OPEN serie_cursor FOR SELECT * FROM Serie where media_id = medias_id;
RETURN serie_cursor;
END;
/

--creating fonction for searching media by producer
create or replace function get_media_producer (producer_name varchar2) return sys_refcursor as
producer_id number;
media_id sys_refcursor;
BEGIN
select id into producer_id from producer where name = producer_name;
open media_id for select media_id from MEDIA where producer_id = producer_id;
return media_id;
END;
/

--creating procedure for inserting new comment 
create or replace procedure insert_comment (p_user_id in number, p_media_id in number, p_comment in varchar2) as
comment_id number;
BEGIN
SELECT max(id) INTO comment_id from comments ;
IF comment_id IS NULL THEN comment_id := 0; END IF;
INSERT INTO comments (id, user_id, media_id, comment) values (comment_id + 1, p_user_id, p_media_id, p_comment);
commit;
END;
/

--creating procedure for deleting comment
create or replace procedure delete_comment (p_comment_id in number) as
BEGIN
DELETE FROM comments WHERE id = p_comment_id;
commit;
END;
/

--creating fonction for getting comment by media id
create or replace function get_comment (media_id number) return sys_refcursor as
comment_cursor sys_refcursor;
BEGIN
OPEN comment_cursor FOR SELECT * FROM comments where media_id = media_id;
RETURN comment_cursor;
END;
/




--creating procedure for inserting new user and creating new user for database

create or replace procedure insert_user (p_name in varchar2, p_email in varchar2, p_password in varchar2 , p_birthdate in DATE,p_image BLOB) as 
user_id number;
im_id number;
BEGIN
SELECT max(id) INTO user_id from users ;
SELECT max(id) INTO im_id from image ; 
IF user_id IS NULL THEN user_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO users (id, name, email, password, birthdate,image_id) values (user_id + 1, p_name, p_email, p_password, p_birthdate,im_id + 1); 
CREATE User P_NAME IDENTIFIED BY P_PASSWORD;
grant create session to P_NAME;
grant execute on delete_user to P_NAME;
grant execute on update_user to P_NAME;
grant execute on get_user to P_NAME;
grant execute on check_admin to P_NAME;
grant execute on get_film_genre to P_NAME;
grant execute on get_serie_genre to P_NAME;
grant execute on get_media_name to P_NAME;
grant execute on get_media_actor to P_NAME;
grant execute on get_media_id to P_NAME;
grant execute on get_media_producer to P_NAME;
grant execute on insert_comment to P_NAME;
grant execute on delete_comment to P_NAME;
grant execute on get_comment to P_NAME;
commit;
exception
END; 
/

--creating fonction for checking if user exist(used in login)
create or replace function check_user (p_name in varchar2,p_password in varchar2) return number as
user_id number;
BEGIN
SELECT id INTO user_id from users where name = p_name and password = p_password;
if user_id is null then
return 0;
else
return 1;
end if;
END;
/










--creating new user for inserting when first login
create user newuser IDENTIFIED BY 1234;
grant EXECUTE on insert_user to newuser;
grant EXECUTE on check_user to newuser;
grant create session to newuser;




