alter session set "_ORACLE_SCRIPT"=true;  
create or replace PROCEDURE DELETE_USER (p_name in varchar2) as
BEGIN
DELETE FROM users WHERE name = p_name;-
EXECUTE IMMEDIATE ('drop user '||p_name||' cascade');
commit;
END;

create or replace PROCEDURE UPDATE_USER (user_id number ,p_name in varchar2, p_email in varchar2, p_password in varchar2 , p_birthdate in DATE,p_image BLOB) as
im_id number;
BEGIN
SELECT image_id INTO im_id from users where id = user_id;
UPDATE image SET image = p_image where id = im_id;
UPDATE users SET email = p_email, password = p_password, birthdate = p_birthdate, name = P_NAME where id = user_id;
COMMIT;
END;

--creating fonction for getting user info by id
create or replace function get_user (user_id number) return sys_refcursor as
user_cursor sys_refcursor;
BEGIN
OPEN user_cursor FOR SELECT * FROM users where id = user_id;
RETURN user_cursor;
END;


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
commit;
exception
END; 


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











--creating new user for inserting when first login
create user newuser IDENTIFIED BY 1234;
grant EXECUTE on insert_user to newuser;
grant EXECUTE on check_user to newuser;
grant create session to newuser;




