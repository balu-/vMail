vMail
=====

some simple Scripts to manage my virtual Users &amp; Domains in my postfix/dovecot setup


Config
------

for this scripts to work you have to have the following config + files:

###Postfix

<code>
`# virtual domains`
virtual_mailbox_domains = /etc/postfix/vdomains
virtual_transport = dovecot
`#vmailbox liste`
virtual_mailbox_maps = hash:/etc/postfix/vmaps
`#vmail alias db`
virtual_alias_maps = hash:/etc/postfix/valias
`#basis Pfad fuer Virtuelle Mailboxen`
virtual_mailbox_base = /var/mail/
</code>

###Dovecot

<code>
  passdb passwd-file {
      args = username_format=%u /var/mail/auth.d/%d/passwd
  }
</code>

