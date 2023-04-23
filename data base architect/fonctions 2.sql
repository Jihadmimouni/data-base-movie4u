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
create or replace procedure add_serie (p_name in varchar, p_release_date in NUMBER, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,p_genre_id in number) as
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
    VIDEO
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video
  );

INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1
  );
INSERT INTO serie (id, media_id, synopsis_id, genre_id) values (serie_id + 1, MEDIA_ID + 1, SYNOPSIS_ID + 1, p_genre_id);
commit;
END;
/

--creating procedure for adding season
create or replace procedure  add_season (p_serie_id in number, p_name in varchar, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,air_time date) as
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
    VIDEO
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video
  );
INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1
  );
SELECT max(numero) INTO numero from season where serie_id = p_serie_id;
INSERT INTO season (id, media_id, synopsis_id, serie_id, START_DATE,NUMERO) values (saison_id + 1, MEDIA_ID + 1, SYNOPSIS_ID + 1, p_serie_id,air_time,numero+1);
commit;
END;
/
--creating procedure for adding episode
create or replace procedure add_episode (p_saison_id in number, p_name in varchar, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,air_time date,p_video BLOB) as
episode_id number;
MEDIA_ID number;
SYNOPSIS_ID number;
VIDEO_ID number;
im_id number;
numero number;
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
    VIDEO
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video
  );
INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1
  );
SELECT max(numero) INTO numero from episode where season_id = p_saison_id;
IF numero IS NULL THEN numero := 0; END IF;
INSERT INTO VIDEO(
    ID,
    VIDEO
  )
VALUES
  (
    VIDEO_ID + 2,
    p_video
  );

INSERT INTO EPISODE(
    ID,
    SEASON_ID,
    TITLE,
    AIR_DATE,
    MEDIA_ID,
    VIDEO_ID,
    SYNOPSIS_ID
  )
VALUES
  (
    episode_id + 1,
    p_saison_id,
    p_name,
    air_time,
    MEDIA_ID + 1,
    VIDEO_ID + 2,
    SYNOPSIS_ID + 1
  );
commit;
end;
/

--creating procedure for adding film
create or replace procedure add_film (p_name in varchar, p_language in varchar,p_synopsis_text in VARCHAR, p_synopsis_video in BLOB, p_image BLOB, p_producer_id in number,p_country in varchar,year number,p_video BLOB,GENRE_ID number,DURATION number) as
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
    VIDEO
  )
VALUES
  (
    VIDEO_ID + 1,
    p_synopsis_video
  );
INSERT INTO SYNOPSIS(
    ID,
    TEXT,
    VIDEO_ID
  )
VALUES
  (
    SYNOPSIS_ID + 1,
    p_synopsis_text,
    VIDEO_ID + 1
  );
INSERT INTO VIDEO(
    ID,
    VIDEO
  )
VALUES
  (
    VIDEO_ID + 2,
    p_video
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
cmnt sys_refcursor
BEGIN
open cmnt for SELECT * FROM COMMENTS where MEDIA_ID = medias_id;
return cmnt;
end;
/
--creating fonction that return average of rating of a media
create or replace function get_average_rating (medias_id NUMBER) return NUMBER as
avg_rating NUMBER;
BEGIN
SELECT avg(rating) INTO avg_rating FROM RATING where MEDIA_ID = medias_id;
return avg_rating;
end;
/ 


--creating procedure for adding actor
create or replace procedure add_actor (p_name in varchar2, p_birthdate in DATE, p_image BLOB) as
actor_id number;
im_id number;
tmp_query varchar(150);
BEGIN
SELECT max(id) INTO actor_id from actor ;
SELECT max(id) INTO im_id from image ;
IF actor_id IS NULL THEN actor_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO actor (id, name, birthdate, image_id) values (actor_id + 1, p_name, p_birthdate, im_id + 1);
tmp_query := 'CREATE' || User  || ' P_NAME IDENTIFIED BY ' || P_PASSWORD ;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant create session to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
commit;
END;
/

--creating procedure for adding producer
create or replace procedure add_producer (p_name in varchar2, p_birthdate in DATE, p_image BLOB) as
producer_id number;
im_id number;
tmp_query varchar(150);
BEGIN
SELECT max(id) INTO producer_id from producer ;
SELECT max(id) INTO im_id from image ;
IF producer_id IS NULL THEN producer_id := 0; END IF;
IF im_id IS NULL THEN im_id := 0; END IF;
INSERT INTO image (id, image) values (im_id + 1, p_image);
INSERT INTO producer (id, name, birthdate, image_id) values (producer_id + 1, p_name, p_birthdate, im_id + 1);
tmp_query := 'CREATE' || User  || ' P_NAME IDENTIFIED BY ' || P_PASSWORD ;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant create session to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on add_serie to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on add_film to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on add_season to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on add_episode to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_average_rating to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_comments_by_media_id to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_media_producer to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
commit;
END;
/

--creating procedure for inserting new user and creating new user for database

create or replace procedure insert_user (p_name in varchar2, p_email in varchar2, p_password in varchar2 , p_birthdate in DATE,p_image BLOB) as 
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
tmp_query := 'CREATE' || User  || ' P_NAME IDENTIFIED BY ' || P_PASSWORD ;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant create session to ' ||P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on delete_user to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on update_user to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_user to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on check_admin to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_film_genre to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_serie_genre to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_media_name to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_media_actor to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_media_id to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_media_producer to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on insert_comment to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on delete_comment to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_comment to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_film to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
tmp_query := 'grant execute on get_serie to' || P_NAME;
EXECUTE IMMEDIATE tmp_query;
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










--creating new user for inserting when first login
create user newuser IDENTIFIED BY 1234;
grant EXECUTE on insert_user to newuser;
grant EXECUTE on check_user to newuser;
grant EXECUTE on add_actor to newuser;
grant EXECUTE on add_producer to newuser;
grant create session to newuser;




