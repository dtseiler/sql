-- Testing SMTP sending via mailgun with PLAIN auth

set serveroutput on;

declare
        c utl_smtp.connection;
        v_smtp_server   varchar2(32) := 'smtp.mailgun.org';
        v_smtp_port     number := 25;
        v_smtp_domain   varchar2(32) := 'your_domain_here.com';
        v_smtp_authid   varchar2(32) := 'your_mailgun_account_login_here';
        v_smtp_username varchar2(32) := 'your_mailgun_domain_smtp_login_here';
        v_smtp_password varchar2(32) := 'your_mailgun_domain_smtp_password_here';
        v_auth_string   varchar2(512);
        v_sender        varchar2(32) := 'foo@your_domain_here.com';
        v_recipient     varchar2(32) := 'whoever_you_want@bar.com';
begin
	-- Mailgun does not use the SMTP username as the AuthID as many other SMTP servers do.
	-- You have to use your Mailgun account login as the AuthID when using PLAIN auth
	-- FYI: SMTP AUTH LOGIN just uses the SMTP username/password
        v_auth_string := utl_raw.cast_to_varchar2(
                utl_encode.base64_encode(utl_raw.cast_to_raw(v_smtp_authid||chr(0)||v_smtp_username||chr(0)||v_smtp_password))
        );

        c := utl_smtp.open_connection(v_smtp_server, v_smtp_port);
        utl_smtp.ehlo(c, v_smtp_domain);
        utl_smtp.command(c, 'AUTH', 'PLAIN ' || v_auth_string);

        utl_smtp.mail(c, '<'||v_sender||'>');
        utl_smtp.rcpt(c, '<'||v_recipient||'>');
        utl_smtp.open_data(c);
        utl_smtp.write_data(c, 'From: '||v_sender||utl_tcp.crlf);
        utl_smtp.write_data(c, 'To: '||v_recipient||utl_tcp.crlf);
        utl_smtp.write_data(c, 'Date: '||to_char(systimestamp,'Dy, dd Mon yyyy hh24:mi:ss tzhtzm')||utl_tcp.crlf);
        utl_smtp.write_data(c, 'Subject: Hello World!'||utl_tcp.crlf);
        utl_smtp.write_data(c, utl_tcp.crlf||'This is a test of SMTP plain auth via '||v_smtp_server||'.');
        utl_smtp.close_data(c);
        utl_smtp.quit(c);
end;
/
