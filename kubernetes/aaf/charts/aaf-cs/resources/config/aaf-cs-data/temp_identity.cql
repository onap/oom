USE authz;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.admin','2099-12-31','org','admin') ;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.osaaf.aaf.admin','2099-12-31','org.osaaf.aaf','admin') ;

