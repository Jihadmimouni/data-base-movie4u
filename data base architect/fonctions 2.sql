alter session set "_ORACLE_SCRIPT"=true;  
/
create or replace PROCEDURE DELETE_USER (p_name in varchar2) as
tmp_query varchar2(100);
BEGIN
DELETE FROM users WHERE name = p_name;
commit;
END;
/
--creating fonction to add notification when media is added
create or replace procedure add_notification (p_id in number,m_id in number,msg VARCHAR2) as
not_id number;
BEGIN
SELECT max(id) INTO not_id from notification ;
IF not_id IS NULL THEN not_id := 0; END IF;
INSERT INTO notification (id,media_id, users_id , MESSAGE) values (not_id+1,m_id,p_id, msg);
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
open media_cursor FOR select * from media where name = media_name;
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
OPEN media_cursor FOR SELECT * FROM MEDIA where id = media_id;
RETURN media_cursor;
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

--creating procedure for inserting new comment 
create or replace procedure insert_comment (p_user_id in number, p_media_id in number, p_comment in varchar2) as
comment_id number;
BEGIN
SELECT max(id) INTO comment_id from comments ;
IF comment_id IS NULL THEN comment_id := 0; END IF;
INSERT INTO comments (id, users_id, media_id, COMMENTS) values (comment_id + 1, p_user_id, p_media_id, p_comment);
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
create or replace function get_comment (p_id number,media_id number) return sys_refcursor as
comment_cursor sys_refcursor;
BEGIN
OPEN comment_cursor FOR SELECT * FROM comments where media_id = media_id AND users_id = p_id;
RETURN comment_cursor;
END;
/
--creating procedure for adding media to favorite
create or replace procedure add_favorite (p_user_id in number, p_media_id in number) as
favorite_id number;
BEGIN
SELECT max(id) INTO favorite_id from favorite ;
IF favorite_id IS NULL THEN favorite_id := 0; END IF;
INSERT INTO favorite (id, users_id, media_id) values (favorite_id + 1, p_user_id, p_media_id);
commit;
END;
/
--creattng fonction for getting favorite by user id
create or replace function get_favorite (p_user_id number) return sys_refcursor as
favorite_cursor sys_refcursor;
begin
open favorite_cursor for select * from favorite where users_id = p_user_id;
return favorite_cursor;
end;
/
--creating procedure for deleting favorite
create or replace procedure delete_favorite (p_user_id in number, p_media_id in number) as
BEGIN
DELETE FROM favorite WHERE media_id = p_media_id and users_id = p_user_id;
commit;
END;
/
--creating procedure to add to preferences 
create or replace procedure add_preferences (p_user_id in number, p_genre_id in number) as
preferences_id number;
BEGIN
SELECT max(id) INTO preferences_id from preferences ;
IF preferences_id IS NULL THEN preferences_id := 0; END IF;
INSERT INTO preferences (id, users_id, genre_id) values (preferences_id + 1, p_user_id, p_genre_id);
commit;
END;
/
--creating procedure to delete preferences
create or replace procedure delete_preferences (p_preferences_id in number) as
BEGIN
DELETE FROM preferences WHERE id = p_preferences_id;
commit;
END;
/

--creating procedure for adding rating 
create or replace procedure add_rating (p_user_id in number, p_media_id in number, p_rating in number) as
rating_id number;
BEGIN
SELECT max(id) INTO rating_id from rating ;
IF rating_id IS NULL THEN rating_id := 0; END IF;
INSERT INTO rating (id, users_id, media_id, score) values (rating_id + 1, p_user_id, p_media_id, p_rating);
commit;
END;
/


--creating procedure for adding serie
create or replace procedure add_serie (p_name in varchar, p_release_date in NUMBER, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,p_genre_id in number,istexts VARCHAR2) as
serie_id number;
MEDIA_ID number;
SYNOPSIS_ID number;
VIDEO_ID number;
im_id number;
BEGIN
SELECT max(id) INTO synopsis_id from SYNOPSIS ;
SELECT max(id) INTO serie_id from serie ;
SELECT max(id) INTO im_id from image ;
SELECT max(id) INTO MEDIA_ID from media ;
SELECT max(id) INTO VIDEO_ID from video ;
IF serie_id IS NULL THEN serie_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
IF MEDIA_ID IS NULL THEN MEDIA_ID := 0; END IF;
IF SYNOPSIS_ID IS NULL THEN SYNOPSIS_ID := 0; END IF;
IF VIDEO_ID IS NULL THEN VIDEO_ID := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO MEDIA(
    ID,
    "NAME",
    "YEAR",
    "LANGUAGE",
    COUNTRY,
    PRODUCER_ID,
    IMAGE_ID,
    "TYPE"
) VALUES (
    MEDIA_ID + 1,
    p_name,
    p_release_date,
    p_language,
    p_country,
    p_producer_id,
    im_id + 1,
    'SERIE'
);
INSERT INTO VIDEO(
    ID,
    VIDEO,
    view_count
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video,
    0
  );

INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID,
    istext
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1,
    istexts
  );
INSERT INTO serie (id, media_id, synopsis_id, genre_id) values (serie_id + 1, MEDIA_ID + 1, SYNOPSIS_ID + 1, p_genre_id);
commit;
END;
/

--creating procedure for adding season
create or replace procedure  add_season (p_serie_id in number, p_name in varchar, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,air_time date,istexts VARCHAR2) as
saison_id number;
MEDIA_ID number;
SYNOPSIS_ID number;
VIDEO_ID number;
im_id number;
numero number;
BEGIN
SELECT max(id) INTO synopsis_id from SYNOPSIS ;
SELECT max(id) INTO saison_id from season ;
SELECT max(id) INTO im_id from image ;
SELECT max(id) INTO MEDIA_ID from media ;
SELECT max(id) INTO VIDEO_ID from video ;
IF saison_id IS NULL THEN saison_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
IF MEDIA_ID IS NULL THEN MEDIA_ID := 0; END IF;
IF SYNOPSIS_ID IS NULL THEN SYNOPSIS_ID := 0; END IF;
IF VIDEO_ID IS NULL THEN VIDEO_ID := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO MEDIA(
    ID,
    "NAME",
    "YEAR",
    "LANGUAGE",
    COUNTRY,
    PRODUCER_ID,
    IMAGE_ID,
    "TYPE"
) VALUES (
    MEDIA_ID + 1,
    p_name,
    0,
    p_language,
    p_country,
    p_producer_id,
    im_id + 1,
    'SAISON'
);
INSERT INTO VIDEO(
    ID,
    VIDEO,
    view_count
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video,
    0
  );
INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID,
    istext
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1,
    istexts
  );
SELECT max(numero) INTO numero from season where serie_id = p_serie_id;
INSERT INTO season (id, media_id, synopsis_id, serie_id, START_DATE,NUMERO) values (saison_id + 1, MEDIA_ID + 1, SYNOPSIS_ID + 1, p_serie_id,air_time,numero+1);
commit;
END;
/
--creating procedure for adding episode
create or replace procedure add_episode (p_saison_id in number, p_name in varchar, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,air_time date,p_video BLOB,istexts VARCHAR2) as
episode_id number;
MEDIA_ID number;
SYNOPSIS_ID number;
VIDEO_ID number;
im_id number;
numeros number;
BEGIN
SELECT max(id) INTO synopsis_id from SYNOPSIS ;
SELECT max(id) INTO episode_id from episode ;
SELECT max(id) INTO im_id from image ;
SELECT max(id) INTO MEDIA_ID from media ;
SELECT max(id) INTO VIDEO_ID from video ;
IF episode_id IS NULL THEN episode_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
IF MEDIA_ID IS NULL THEN MEDIA_ID := 0; END IF;
IF SYNOPSIS_ID IS NULL THEN SYNOPSIS_ID := 0; END IF;
IF VIDEO_ID IS NULL THEN VIDEO_ID := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO MEDIA(
    ID,
    "NAME",
    "YEAR",
    "LANGUAGE",
    COUNTRY,
    PRODUCER_ID,
    IMAGE_ID,
    "TYPE"
) VALUES (
    MEDIA_ID + 1,
    p_name,
    0,
    p_language,
    p_country,
    p_producer_id,
    im_id + 1,
    'EPISODE'
);
INSERT INTO VIDEO(
    ID,
    VIDEO,
    view_count
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video,
    0
  );
INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID,
    istext
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1,
    istexts
  );
SELECT max(numero) INTO numeros from episode where season_id = p_saison_id;
IF numeros IS NULL THEN numeros := 0; END IF;
INSERT INTO VIDEO(
    ID,
    VIDEO,
    view_count
  )
VALUES
  (
    VIDEO_ID + 2,
    p_video,
    0
  );

INSERT INTO EPISODE(
    ID,
    SEASON_ID,
    TITLE,
    AIR_DATE,
    MEDIA_ID,
    VIDEO_ID,
    SYNOPSIS_ID,
    NUMERO
  )
VALUES
  (
    episode_id + 1,
    p_saison_id,
    p_name,
    air_time,
    MEDIA_ID + 1,
    VIDEO_ID + 2,
    SYNOPSIS_ID + 1,
    numeros+1
  );
  for i in (select * from favorite where media_id = (select serie_id from season where id=p_saison_id))
  loop
  add_notification (i.users_id,MEDIA_ID +1,'new episode');
  end loop;
commit;
end;
/

--creating procedure for adding film
create or replace procedure add_film (p_name in varchar, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,year number,p_video BLOB,GENRE_ID number,DURATION number,istexts VARCHAR2) as
film_id number;
MEDIA_ID number;
SYNOPSIS_ID number;
VIDEO_ID number;
im_id number;
BEGIN
SELECT max(id) INTO synopsis_id from SYNOPSIS ;
SELECT max(id) INTO film_id from film ;
SELECT max(id) INTO im_id from image ;
SELECT max(id) INTO MEDIA_ID from media ;
SELECT max(id) INTO VIDEO_ID from video ;
IF film_id IS NULL THEN film_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
IF MEDIA_ID IS NULL THEN MEDIA_ID := 0; END IF;
IF SYNOPSIS_ID IS NULL THEN SYNOPSIS_ID := 0; END IF;
IF VIDEO_ID IS NULL THEN VIDEO_ID := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO MEDIA(
    ID,
    "NAME",
    "YEAR",
    "LANGUAGE",
    COUNTRY,
    PRODUCER_ID,
    IMAGE_ID,
    "TYPE"
) VALUES (
    MEDIA_ID + 1,
    p_name,
    year,
    p_language,
    p_country,
    p_producer_id,
    im_id + 1,
    'FILM'
);
INSERT INTO VIDEO(
    ID,
    VIDEO,
    view_count
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video,
    0
  );
INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID,
    istext
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1,
    istexts
  );
INSERT INTO VIDEO(
    ID,
    VIDEO,
    view_count
  )
VALUES
  (
    VIDEO_ID + 2,
    p_video,
    0
  );
INSERT INTO FILM(
    ID,
    MEDIA_ID,
    SYNOPSIS_ID,
    GENRE_ID,
    VIDEO_ID,
    DURATION
  )
VALUES
  (
    film_id + 1,
    MEDIA_ID + 1,
    SYNOPSIS_ID + 1,
    GENRE_ID,
    VIDEO_ID + 2,
    DURATION
  );
commit;
end;
/

--creating fonction for getting all comments on media by producer
create or replace function get_comments_by_media_id (medias_id NUMBER) return SYS_REFCURSOR as
cmnt sys_refcursor;
BEGIN
open cmnt for SELECT * FROM COMMENTS where MEDIA_ID = medias_id;
return cmnt;
end;
/
--creating fonction that return average of rating of a media
create or replace function get_average_rating (medias_id NUMBER) return NUMBER as
avg_rating NUMBER;
BEGIN
SELECT avg(SCORE) INTO avg_rating FROM RATING where MEDIA_ID = medias_id;
return avg_rating;
end;
/ 

--creating procedure that add actor and role to role table
create or replace procedure add_actor_to_role (p_actor_name in VARCHAR, p_role VARCHAR,MEDIA_ID NUMBER) as
actor_id number;
role_id number;
BEGIN
SELECT id INTO actor_id from actor where name = p_actor_name;
SELECT max(id) INTO role_id from role ;
IF role_id IS NULL THEN role_id := 0; END IF;
INSERT INTO ROLE(
    ID,
    ACTOR_ID,
    MEDIA_ID,
    name
  )
VALUES
  (
    role_id + 1,
    actor_id,
    MEDIA_ID,
    p_role
  );
commit;
end;
/



--creating procedure for adding actor
create or replace procedure add_actor (p_name in varchar2,p_email VARCHAR2,p_password in VARCHAR2, p_birthdate in DATE, p_image BLOB) as
actor_id number;
im_id number;
tmp_query varchar(150);
BEGIN
SELECT max(id) INTO actor_id from actor ;
SELECT max(id) INTO im_id from image ;
IF actor_id IS NULL THEN actor_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO actor (id, name, birthdate,EMAIL,PASSWORD , image_id) values (actor_id + 1, p_name, p_birthdate,p_email,p_password, im_id + 1);
commit;
END;
/

--creating procedure for adding producer
create or replace procedure add_producer (p_name in varchar2,p_email VARCHAR2,p_password in VARCHAR2, p_birthdate in DATE, p_image BLOB) as
producer_id number;
im_id number;
tmp_query varchar(150);
BEGIN
SELECT max(id) INTO producer_id from producer ;
SELECT max(id) INTO im_id from image ;
IF producer_id IS NULL THEN producer_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO producer (id, name, birthdate,EMAIL,PASSWORD ,image_id) values (producer_id + 1, p_name, p_birthdate,p_email,p_password, im_id + 1);
commit;
END;
/

--creating procedure for inserting new user and creating new user for database

CREATE OR REPLACE procedure insert_user (p_name in varchar2, p_email in varchar2, p_password in varchar2 , p_birthdate in DATE,p_image BLOB) as
user_id number;
im_id number;
tmp_query varchar(150);
BEGIN
SELECT max(id) INTO user_id from users ;
SELECT max(id) INTO im_id from image ;
IF user_id IS NULL THEN user_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO users (id, name, email, password, birthdate,image_id) values (user_id + 1, p_name, p_email, p_password, p_birthdate,im_id + 1);
commit;
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

--creating fonction for checking if actor exist(used in login)
create or replace function check_actor (p_name in varchar2,p_password in varchar2) return number as
actor_id number;
BEGIN
SELECT id INTO actor_id from actor where name = p_name and password = p_password;
if actor_id is null then
return 0;
else
return 1;
end if;
END;
/

--creating fonction for checking if producer exist(used in login)
create or replace function check_producer (p_name in varchar2,p_password in varchar2) return number as
producer_id number;
BEGIN
SELECT id INTO producer_id from producer where name = p_name and password = p_password;
if producer_id is null then
return 0;
else
return 1;
end if;
END;
/

--creating fonction to get user by name and password
create or replace function get_user_log (p_name in varchar2,p_password in varchar2) return SYS_REFCURSOR as
user_id number;
user SYS_REFCURSOR;
BEGIN
SELECT id INTO user_id from users where name = p_name and password = p_password;
OPEN user FOR SELECT * FROM users where id = user_id;
return user;
END;
/

--creating fonction to return image by id
create or replace function get_image (p_id in number) return SYS_REFCURSOR as
image SYS_REFCURSOR;
BEGIN
OPEN image FOR SELECT * FROM image where id = p_id;
return image;
END;
/

--creating fonction to delete producer by id
create or replace procedure delete_producer (p_name in varchar2) as
BEGIN
DELETE FROM producer where name = p_name;
commit;
END;
/

--creating fonction to delete actor by id
create or replace procedure delete_actor (p_name in varchar2) as
BEGIN
DELETE FROM actor where name = p_name;
commit;
END;
/

--creating fonction to get producer by name and password
create or replace function get_producer_log (p_name in varchar2,p_password in varchar2) return SYS_REFCURSOR as
producer_id number;
producer SYS_REFCURSOR;
BEGIN
SELECT id INTO producer_id from producer where name = p_name and password = p_password;
OPEN producer FOR SELECT * FROM producer where id = producer_id;
return producer;
END;
/

--creating fonction to get actor by name and password
create or replace function get_actor_log (p_name in varchar2,p_password in varchar2) return SYS_REFCURSOR as
actor_id number;
actor SYS_REFCURSOR;
BEGIN
SELECT id INTO actor_id from actor where name = p_name and password = p_password;
OPEN actor FOR SELECT * FROM actor where id = actor_id;
return actor;
END;
/


--creating procedure for updating actor
create or replace procedure update_actor (p_id in number,p_name in varchar2,p_email in varchar2,p_password in varchar2, p_birthdate in DATE, p_image BLOB) as
im_id number;
BEGIN
SELECT max(id) INTO im_id from image ;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
UPDATE actor SET name = p_name, email = p_email, password = p_password, birthdate = p_birthdate, image_id = im_id + 1 where id = p_id;
commit;
END;
/

--creating procedure for updating producer
create or replace procedure update_producer (p_id in number,p_name in varchar2,p_email in varchar2,p_password in varchar2, p_birthdate in DATE, p_image BLOB) as
im_id number;
BEGIN
SELECT max(id) INTO im_id from image ;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
UPDATE producer SET name = p_name, email = p_email, password = p_password, birthdate = p_birthdate, image_id = im_id + 1 where id = p_id;
commit;
END;
/
--creating fonction to get Synopsis by id
create or replace function get_synopsis (p_id in number) return SYS_REFCURSOR as
synopsis SYS_REFCURSOR;
BEGIN
OPEN synopsis FOR SELECT * FROM synopsis where id = p_id;
return synopsis;
END;
/
--creating fonction to get video by id
create or replace function get_video (p_id in number) return SYS_REFCURSOR as
video SYS_REFCURSOR;
BEGIN
OPEN video FOR SELECT * FROM video where id = p_id;
UPDATE video SET view_count = view_count + 1 where id = p_id;
return video;
END;
/

--creating fonction to get Genre by id
create or replace function get_genre (p_id in number) return SYS_REFCURSOR as
genre SYS_REFCURSOR;
BEGIN
OPEN genre FOR SELECT * FROM genre where id = p_id;
return genre;
END;
/

--creating fonction to get id of genre by name if not exist insert it and return id
create or replace function get_genre_id (p_name in varchar2) return number as
genre_id number;
BEGIN
SELECT id INTO genre_id from genre where name = p_name;
if genre_id is null then
INSERT INTO genre (name) values (p_name);
SELECT id INTO genre_id from genre where name = p_name;
return genre_id;
else
return genre_id;
end if;
END;
/
--creating fonction to get season by series_id
create or replace function get_season (p_id in number) return SYS_REFCURSOR as
season SYS_REFCURSOR;
BEGIN
OPEN season FOR SELECT * FROM season where serie_id = p_id;
return season;
END;
/
--creating fonction to get episode by season_id
create or replace function get_episode (p_id in number) return SYS_REFCURSOR as
episode SYS_REFCURSOR;
BEGIN
OPEN episode FOR SELECT * FROM episode where season_id = p_id;
return episode;
END;
/

--creating fonction to get media name by id
create or replace function get_media_name_id (p_id in number) return varchar2 as
media_name varchar2(100);
BEGIN
SELECT name INTO media_name from media where id = p_id;
return media_name;
END;
/

--creating fonction to get notificaton by user_id
create or replace function get_notification (p_id in number) return SYS_REFCURSOR as
notification SYS_REFCURSOR;
BEGIN
OPEN notification FOR SELECT * FROM notification where users_id = p_id;
return notification;
END;
/




--creating new user for inserting when first login
create user newuser IDENTIFIED BY 1234;
grant EXECUTE on get_user_log to newuser;
grant EXECUTE on insert_user to newuser;
grant EXECUTE on check_user to newuser;
grant EXECUTE on add_actor to newuser;
grant EXECUTE on add_producer to newuser;
GRANT EXECUTE on check_actor to newuser;
GRANT EXECUTE on check_producer to newuser;
grant execute on delete_user to newuser;
grant execute on update_user to newuser;
grant execute on get_user to newuser;
grant execute on check_admin to newuser;
grant execute on get_film_genre to newuser;
grant execute on get_serie_genre to newuser;
grant execute on get_media_name to newuser;
grant execute on get_media_producer to newuser;
grant execute on insert_comment to newuser;
grant execute on delete_comment to newuser;
grant execute on get_comment to newuser;
grant execute on get_film to newuser;
grant execute on get_serie to newuser;
grant execute on add_serie TO newuser;
grant execute on add_film TO newuser;
grant execute on add_season TO newuser;
grant execute on add_episode TO newuser;
grant execute on get_average_rating TO newuser;
grant execute on get_comments_by_media_id TO newuser;
grant execute on get_media_producer TO newuser;
grant execute on add_actor_to_role TO newuser;
grant execute on get_average_rating to newuser;
grant execute on get_media_actor to newuser;
grant execute on get_media_id to newuser;
grant execute on update_producer to newuser;
grant execute on update_actor to newuser;
grant execute on delete_actor to newuser;
grant execute on delete_producer to newuser;
grant execute on get_actor_log to newuser;
grant execute on get_producer_log to newuser;
grant execute on get_image to newuser;
grant execute on get_synopsis to newuser;
grant execute on get_video to newuser;
grant execute on get_genre to newuser;
grant execute on add_favorite to newuser;
grant execute on get_favorite to newuser;
grant execute on get_genre_id to newuser;
grant execute on get_media_name_id to newuser;
grant create session to newuser;
grant EXECUTE on get_notification to newuser;



