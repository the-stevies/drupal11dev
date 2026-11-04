Database

Drupal-11-Dev
d048d213
d048d213
TACwy33t#CjZqqv0UTiN




cd ~/Sites/drupal11-dev
ddev drush cex -y
git status
git add .
git commit -m "Artikel"
git push


ddev drush cex -y
git init
git add .
git commit -m "Start"
git remote add origin <privates-repo>
git push -u origin main



git remote add origin git@github.com:the-stevies/drupal11dev.git
git push -u origin main



git remote set-url origin git@github.com:the-stevies/drupal11dev.git
git branch -M main
git push -u origin main



ssh nmm
git clone git@github.com:the-stevies/drupal11dev.git drupal11dev && cd drupal11dev
composer install --no-dev --optimize-autoloader







 ssh-keygen -t ed25519 -C "post@stefan-guenther.net"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/stefan/.ssh/id_ed25519):
Enter passphrase for "/Users/stefan/.ssh/id_ed25519" (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/stefan/.ssh/id_ed25519
Your public key has been saved in /Users/stefan/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:/Ox+knatLzRsXSWPB93C9y6tk+ErM09Mpdnj0S1YD2c post@stefan-guenther.net
The key's randomart image is:
+--[ED25519 256]--+
|             . ..|
|              = =|
|              oBE|
|       .     o.XB|
|        S  ...=B=|
|         o  =o=.=|
|          o+ +o* |
|         .+ B.*  |
|         oo+.O+o |
+----[SHA256]-----+



 ssh-add --apple-use-keychain ~/.ssh/id_ed25519
Identity added: /Users/stefan/.ssh/id_ed25519 (post@stefan-guenther.net)
