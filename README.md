vMail
=====

Some simple scripts to manage my virtual Users &amp; Domains in my postfix/dovecot setup.



Config
------

main config is done in conf.conf, to change anything please copy the file to conf.local
and change values there

for this scripts to work you have to have the following config + files:

###Postfix

    # virtual domains
      virtual_mailbox_domains = /etc/postfix/vdomains
      virtual_transport = dovecot
    #vmailbox liste
      virtual_mailbox_maps = hash:/etc/postfix/vmaps
    #vmail alias db
      virtual_alias_maps = hash:/etc/postfix/valias
    #Basispfad fuer Virtuelle Mailboxen
      virtual_mailbox_base = /var/mail/

###Dovecot

    passdb passwd-file {
        args = username_format=%u /var/mail/auth.d/%d/passwd
    }

